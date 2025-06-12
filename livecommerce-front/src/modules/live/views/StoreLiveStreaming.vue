<!--
  StoreLiveStreaming.vue
  입점업체의 라이브 스트리밍 방송 송출을 위한 컴포넌트

  OpenVidu 세션 생성 및 관리
  비디오/마이크 스트림 발행(Publish)
  라이브 설정(제목, 상품 정보 등) 관리
  -> 현재는 title로 sessionId 설정해둠 -> 추후 변경 필요
  방송 시작/종료 기능
-->

<template>
  <div class="host-container">
    <!-- 방송 설정 화면 -->
    <div class="stream-setup" v-if="!session">
      <div class="setup-container">
        <h2 class="setup-title">라이브 방송 준비</h2>

        <div class="setup-grid">
          <!-- 왼쪽 컬럼: 기본 정보 -->
          <div class="setup-column">
      <div class="form-group">
              <label class="form-label">방송 제목</label>
              <input 
                v-model="streamTitle" 
                class="form-control" 
                type="text" 
                placeholder="방송 제목을 입력해주세요"
                required 
              />
      </div>

      <div class="form-group">
              <label class="form-label">공지 사항</label>
              <textarea 
                v-model="announcement" 
                class="form-control" 
                placeholder="시청자들에게 전달할 공지사항을 입력해주세요"
                rows="3"
                required 
              ></textarea>
      </div>

      <div class="form-group">
              <label class="form-label">썸네일 이미지</label>
              <div class="thumbnail-upload">
                <input 
                  @change="handleThumbnailChange" 
                  class="form-control" 
                  type="file" 
                  accept="image/*" 
                  required 
                />
                <div class="thumbnail-preview-container" v-if="thumbnailPreview">
                  <img :src="thumbnailPreview" class="thumbnail-preview" alt="썸네일 미리보기" />
                  <button class="remove-thumbnail" @click="removeThumbnail">✕</button>
                </div>
              </div>
            </div>
      </div>

          <!-- 오른쪽 컬럼: 상품 및 할인 설정 -->
          <div class="setup-column">
      <div class="form-group">
              <label class="form-label">판매 상품 선택 <span class="sub-label">(최대 3개)</span></label>
              <div class="product-selection">
                <div class="product-list">
                  <div 
                    v-for="product in availableProducts" 
                    :key="product.id"
                    class="product-item-select"
                    :class="{ 
                      'selected': selectedProducts.includes(product),
                      'disabled': selectedProducts.length >= 3 && !selectedProducts.includes(product)
                    }"
                    @click="toggleProduct(product)"
                  >
                    <div class="product-info">
                      <div class="product-name">{{ product.name }}</div>
                      <div class="product-price">{{ product.price.toLocaleString() }}원</div>
                    </div>
                    <div class="selection-indicator">
                      <span v-if="selectedProducts.includes(product)">✓</span>
                    </div>
                  </div>
                </div>
              </div>
              <p v-if="showMaxProductsError" class="error-message">
                최대 3개의 상품만 선택할 수 있습니다.
              </p>
      </div>

      <div class="form-group">
              <label class="form-label">할인율 설정</label>
              <select v-model.number="discountRate" class="form-control discount-select">
          <option disabled :value="0">할인율을 선택해주세요</option>
                <option :value="0">할인 미적용</option>
                <option :value="10">10% 할인</option>
                <option :value="15">15% 할인</option>
                <option :value="20">20% 할인</option>
                <option :value="25">25% 할인</option>
                <option :value="30">30% 할인</option>
        </select>
            </div>

            <div v-if="discountedProducts.length" class="discount-preview">
              <h5>할인 적용 예시</h5>
              <div class="discount-items">
                <div v-for="item in discountedProducts" :key="item.id" class="discount-item">
                  <div class="product-name">{{ item.name }}</div>
                  <div class="price-info">
                    <span class="original-price">{{ item.price.toLocaleString() }}원</span>
                    <span class="arrow">→</span>
                    <span class="discounted-price">{{ item.discountedPrice.toLocaleString() }}원</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
      </div>

        <div class="setup-footer">
          <button 
            class="btn btn-primary start-button" 
            @click="enterBroadcast"
            :disabled="!isFormValid"
          >
            방송 시작하기
          </button>
        </div>
      </div>
    </div>

    <!-- 방송 준비/송출 화면 -->

    <!-- 라이브 스트리밍 전체 화면 -->
    <div class="stream-session" v-if="session">
      <div class="stream-content">
        <div class="main-content">
      <div class="stream-header">
        <h2>{{ streamTitle }}</h2>
        <div class="stream-info">
          <span class="viewer-count">👥 시청자 {{ viewerCount }}명</span>
        </div>
      </div>
      <div class="video-container">
        <div v-if="!publisher" class="loading-message">
          카메라 연결 중...
        </div>
        <user-video v-else :stream-manager="publisher" />
          </div>
          <div class="product-info">
            <div class="product-list">
              <div v-for="item in discountedProducts" :key="item.id" class="product-item">
                <h3>{{ item.name }}</h3>
                <p class="price">{{ item.discountedPrice.toLocaleString() }}원</p>
                <p class="original-price">(정가 {{ item.price.toLocaleString() }}원)</p>
                <p class="description">{{ item.description }}</p>
              </div>
            </div>
          </div>
          <button class="btn btn-danger end-stream-button" @click="endStream">방송 종료</button>
      </div>
        <div class="chat-container">
        <ChatContainer />
        </div>
      </div>
    </div>

    
  </div>
</template>

<script setup>

import {useAuthStore} from "@/modules/auth/stores/auth";
const auth = useAuthStore()


import ChatContainer from '@/modules/chat/components/ChatContainer.vue';
import { ref, onBeforeUnmount, onMounted, computed } from 'vue';
import { useRoute } from 'vue-router'
import axios from 'axios';
import { OpenVidu } from 'openvidu-browser';
import UserVideo from '@/modules/live/components/UserVideo.vue';

const APPLICATION_SERVER_URL = process.env.NODE_ENV === 'production' ? ''
  : 'http://localhost:8080/';

// OpenVidu 관련 상태
const OV = ref(undefined);
const session = ref(undefined);
const publisher = ref(undefined);

const route = useRoute();
const vendorId = route.params.vendorId;

// 방송 정보
const streamTitle = ref(''); // 라이브 제목
const announcement = ref(''); // 공지 사항
const thumbnailFile = ref(null); // 썸네일 파일
const thumbnailPreview = ref(''); // 썸네일 미리보기
const availableProducts = ref([]); // 임접업체 상품 목록
const selectedProducts = ref([]); // 선택된 상품들
const discountRate = ref(0); // 할인율
const viewerCount = ref(0); // 시청자 수 상태 관리
const startTime = ref('');
const endTime = ref('');

// 방송 상태 관리
// const isLive = ref(false);

// 할인율 적용
const discountedProducts = computed(() =>
  selectedProducts.value.map(p => ({
    ...p,
    discountedPrice: Math.round(p.price * (100 - discountRate.value) / 100)
  }))
)

// 최대 상품 선택 초과 에러 상태
const showMaxProductsError = ref(false);

//입점업체 상품 가져오기
const productList = async () => {
  try {
    const response = await axios.get(
      `${APPLICATION_SERVER_URL}api/sessions/${vendorId}/productList`,
      { headers: { 'Content-Type': 'application/json' } }
    );
    availableProducts.value = response.data;
    console.log('상품 리스트: ', availableProducts.value);
  } catch (error) {
    console.error('상품 리스트 반환 실패 :', error);
  }
};

// 썸네일 파일 변경 처리
const handleThumbnailChange = (event) => {
  const file = event.target.files[0];
  if (file) {
    thumbnailFile.value = file;
    // 미리보기 URL 생성
    thumbnailPreview.value = URL.createObjectURL(file);
  }
};

// 상품 선택
function toggleProduct(prod) {
  const idx = selectedProducts.value.indexOf(prod);
  if (idx > -1) {
    selectedProducts.value.splice(idx, 1);
    showMaxProductsError.value = false;
  } else if (selectedProducts.value.length < 3) {
    selectedProducts.value.push(prod);
    showMaxProductsError.value = false;
  } else {
    showMaxProductsError.value = true;
  }
}


// 방송 준비 함수 (기존의 startStream 함수를 분리)
const enterBroadcast = async () => {
  if (!streamTitle.value || selectedProducts.value.length === 0 || selectedProducts.value.length
    > 3) {
    alert('방송 제목을 입력하고 1~3개의 상품을 선택해주세요.');
    return;
  }

  // 방송 시작 시간 설정
  startTime.value = new Date().toISOString()
  try {
    // OpenVidu 객체 생성, 세션 생성 
    OV.value = new OpenVidu();
    session.value = OV.value.initSession();

    // 세션 토큰 발급
    const token = await getToken();
    await session.value.connect(token, {
      // 소비자에게 보여줄 데이터 지정
      clientData: {
        type: 'host',
        title: streamTitle.value,
        thumbnail: thumbnailFile.value,
        products: discountedProducts.value
      }
    });

    // 스트림 설정
    const publisherInstance = await OV.value.initPublisherAsync(undefined, {
      audioSource: undefined,
      videoSource: undefined,
      publishAudio: true,
      publishVideo: true,
      resolution: '1280x720',
      frameRate: 30,
      insertMode: 'APPEND',
      mirror: false
    });

    publisher.value = publisherInstance;
    await session.value.publish(publisher.value);

  } catch (error) {
    console.error('방송 준비 중 오류 발생:', error);
    alert('방송 준비 중 오류가 발생했습니다.');
  }
};

// 방송 시작 시 라이브 정보 서버로 전송
// const notifySeverStreamStarted = async (vendorId) => {
//   try {
//     await axios.post(
//
//     )
//   }
// }

// [서버에 방송 종료 알림 전송]
// 방송 종료 시 세션 종료 및 서버에 방송 종료 알림 전송 
const notifyServerStreamEnded = async (sessionId) => {
  endTime.value = new Date().toISOString();
  // 종료 시간 알림
  try {
    await axios.delete(
      `${APPLICATION_SERVER_URL}api/sessions/${sessionId}`,
      {
        headers: { 'Content-Type': 'application/json',
          'Authorization': `Bearer ${auth.token}`},
        //params: {endTime: endTime.value}
      },

    );
    console.log('서버에 방송 종료 알림 완료');
  } catch (error) {
    console.error('서버에 방송 종료 알림 실패:', error);
  }
};

// [방송 종료 함수]
// 방송 종료 시 세션 종료 및 서버에 방송 종료 알림 전송 
const endStream = async () => {
  try {
    if (!session.value) return;

    const currentSessionId = session.value.sessionId;

    // 방송 종료 시 스트림 종료 
    if (publisher.value) {
      await session.value.unpublish(publisher.value);
      publisher.value = undefined;
    }

    // 서버에 세션 종료 알림
    await notifyServerStreamEnded(currentSessionId);
  } catch (error) {
    console.error('방송 종료 중 오류 발생:', error);
  } finally {
    session.value = undefined;
    publisher.value = undefined;
    OV.value = undefined;
  }
};

const getToken = async () => {
  const sessionId = await createSession();
  return await createToken(sessionId);
};

// [세션 생성 후 세션ID를 반환]
// customSessionId를 통해 세션 생성 API를 호출하면 
// 백엔드에서 세션 객체를 생성하고 세션ID를 반환한다. 
const createSession = async () => {
  // FormData 객체 생성
  const formData = new FormData();

  // 기본 세션 정보
  formData.append('title', streamTitle.value);
  formData.append('announcement', announcement.value);
  if (thumbnailFile.value) {
    formData.append('thumbnail', thumbnailFile.value);
  }
  formData.append('products', JSON.stringify(selectedProducts.value));
  formData.append('discountRate', discountRate.value);
  formData.append('startTime', startTime.value);
  formData.append('vendorId', vendorId);

  const response = await axios.post(
      APPLICATION_SERVER_URL + 'api/sessions',
      formData,
      {
        headers: {
          'Content-Type': 'multipart/form-data',
        }
      }
  );
  console.log("여기"+ response.data.sessionId);
  return response.data.sessionId;
};

// [세션ID를 통해 토큰 생성]
// 세션ID를 통해 토큰 생성 API를 호출하면 
// 백엔드에서 토큰을 생성하고 반환한다. 
const createToken = async (sessionId) => {
  const response = await axios.post(
    APPLICATION_SERVER_URL + 'api/sessions/' + sessionId + '/connections',
    {},
    { headers: { 'Content-Type': 'application/json' } }
  );
  return response.data;
};

onMounted(() => {
  productList();
});

// 컴포넌트 언마운트 시 정리
onBeforeUnmount(() => {
  if (thumbnailPreview.value) {
    URL.revokeObjectURL(thumbnailPreview.value);
  }
  endStream();
});

// 페이지 새로고침/종료 시 정리
// window.addEventListener('beforeunload', () => {
//   endStream();
// });

// 폼 유효성 검사
const isFormValid = computed(() => {
  return streamTitle.value && 
         announcement.value && 
         thumbnailFile.value && 
         selectedProducts.value.length > 0 && 
         selectedProducts.value.length <= 3;
});

// 썸네일 제거 함수
const removeThumbnail = () => {
  thumbnailFile.value = null;
  thumbnailPreview.value = '';
};
</script>


<style scoped>
.host-container {
  padding: 20px;
  max-width: 1600px;
  margin: 0 auto;
  background-color: #f8f9fa;
  min-height: 100vh;
}

.stream-setup {
  max-width: 1000px;
  margin: 0 auto;
  padding: 20px;
  min-height: 700px; /* 높이 조정 */
}

.setup-container {
  background: white;
  border-radius: 12px;
  padding: 30px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  min-height: 650px; /* 높이 조정 */
}

.setup-title {
  font-size: 24px;
  font-weight: 600;
  color: #333;
  margin-bottom: 30px;
  text-align: center;
}

.setup-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 30px;
  margin-bottom: 30px;
  min-height: 500px; /* 높이 조정 */
}

.setup-column {
  display: flex;
  flex-direction: column;
  gap: 40px;
  min-height: 500px;
}

.form-group {
  margin-bottom: 0;
}

.form-label {
  display: block;
  font-weight: 600;
  margin-bottom: 12px;
  color: #333;
  font-size: 1.1em;
}

.sub-label {
  font-size: 0.9em;
  color: #666;
  font-weight: normal;
}

.form-control {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 14px;
  transition: border-color 0.2s;
}

.form-control:focus {
  border-color: #007bff;
  outline: none;
  box-shadow: 0 0 0 2px rgba(0,123,255,0.25);
}

.thumbnail-upload {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.thumbnail-preview-container {
  position: relative;
  width: fit-content;
  margin-top: 15px;
}

.thumbnail-preview {
  max-width: 300px;
  max-height: 500px;
  border-radius: 12px;
  object-fit: contain;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.remove-thumbnail {
  position: absolute;
  top: -12px;
  right: -12px;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: #dc3545;
  color: white;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.remove-thumbnail:hover {
  background: #c82333;
  transform: scale(1.05);
  transition: all 0.2s ease;
}

.product-selection {
  border: 1px solid #ddd;
  border-radius: 8px;
  max-height: 450px; /* 높이 조정 */
  overflow-y: auto;
  flex-grow: 1;
}

.product-list {
  display: flex;
  flex-direction: column;
}

.product-item-select {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px;
  border-bottom: 1px solid #eee;
  cursor: pointer;
  transition: background-color 0.2s;
}

.product-item-select:last-child {
  border-bottom: none;
}

.product-item-select:hover {
  background-color: #f8f9fa;
}

.product-item-select.selected {
  background-color: #e8f4ff;
}

.product-item-select.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.product-info {
  flex: 1;
}

.product-name {
  font-weight: 500;
  margin-bottom: 4px;
}

.product-price {
  color: #666;
  font-size: 0.9em;
}

.selection-indicator {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  border: 2px solid #ddd;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #007bff;
}

.selected .selection-indicator {
  background-color: #007bff;
  border-color: #007bff;
  color: white;
}

.discount-select {
  background-color: white;
}

.discount-preview {
  background-color: #f8f9fa;
  padding: 15px;
  border-radius: 8px;
  margin-top: 20px;
}

.discount-preview h5 {
  margin-bottom: 12px;
  color: #333;
}

.discount-items {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.discount-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px;
  background: white;
  border-radius: 6px;
}

.price-info {
  display: flex;
  align-items: center;
  gap: 8px;
}

.original-price {
  color: #666;
  text-decoration: line-through;
}

.arrow {
  color: #666;
}

.discounted-price {
  color: #dc3545;
  font-weight: 600;
}

.setup-footer {
  display: flex;
  justify-content: center;
  margin-top: 30px;
}

.start-button {
  padding: 12px 40px;
  font-size: 16px;
  font-weight: 600;
  border-radius: 8px;
  background-color: #007bff;
  border: none;
  color: white;
  cursor: pointer;
  transition: background-color 0.2s;
}

.start-button:hover {
  background-color: #0056b3;
}

.start-button:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}

.stream-session {
  width: 100%;
  height: 100vh;
  background-color: #f8f9fa;
}

.stream-content {
  display: grid;
  grid-template-columns: 1fr 350px;
  gap: 20px;
  height: 100%;
  padding: 20px;
}

.main-content {
  display: flex;
  flex-direction: column;
  gap: 20px;
  min-width: 0;
}

.chat-container {
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  height: 100%;
}

.stream-header {
  margin-bottom: 20px;
}

.video-container {
  width: 100%;
  height: 0;
  padding-bottom: 56.25%;
  /* 16:9 비율 */
  position: relative;
  background-color: #000;
  margin: 20px auto;
  overflow: hidden;
}

.video-container :deep(.stream-component) {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

.product-info {
  background-color: #f8f9fa;
  padding: 20px;
  border-radius: 8px;
  margin: 20px 0;
}

.loading-message {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: white;
  font-size: 1.2em;
  text-align: center;
}

.text-muted {
  color: #6c757d;
  font-size: 0.875em;
  margin-top: 5px;
  display: block;
}

.product-item {
  margin-bottom: 15px;
  padding-bottom: 15px;
  border-bottom: 1px solid #dee2e6;
}

.product-item:last-child {
  margin-bottom: 0;
  padding-bottom: 0;
  border-bottom: none;
}

.product-item h3 {
  margin: 0 0 10px 0;
  color: #333;
}

.product-item p {
  margin: 5px 0;
  color: #666;
}

.product-item p:first-of-type {
  color: #dc3545;
  font-weight: bold;
  font-size: 1.2em;
}

select option {
  padding: 8px;
}

select option:checked {
  background-color: #007bff;
  color: white;
}

.stream-info {
  margin: 10px 0;
  font-size: 1.1em;
}

.viewer-count {
  color: #666;
  font-weight: bold;
}

.error-message {
  color: #dc3545;
  font-size: 0.9em;
  margin-top: 8px;
  margin-bottom: 0;
}
</style>