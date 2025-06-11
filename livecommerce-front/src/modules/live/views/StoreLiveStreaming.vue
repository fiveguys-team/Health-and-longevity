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
      <h2>라이브 방송 시작하기</h2>

      <div class="form-group">
        <label>방송 제목</label>
        <input v-model="streamTitle" class="form-control" type="text" required/>
      </div>

      <div class="form-group">
        <label>공지 사항</label>
        <input v-model="announcement" class="form-control" type="text" required/>
      </div>

      <div class="form-group">
        <label>썸네일</label>
        <input @change="handleThumbnailChange" class="form-control" type="file" accept="image/*"
               required/>
        <img v-if="thumbnailPreview" :src="thumbnailPreview" class="thumbnail-preview"
             alt="썸네일 미리보기"/>
      </div>

      <div class="form-group">
        <label>판매 상품 선택 (최대 3개)</label>
        <select class="form-control" size="5" multiple>
          <option
              v-for="product in availableProducts"
              :key="product.id"
              :selected="selectedProducts.includes(product)"
              @mousedown.prevent="toggleProduct(product)"
          >
            {{ product.name }} – {{ product.price.toLocaleString() }}원
          </option>
        </select>
        <p>선택된 상품: {{ selectedProducts.map(p => p.name).join(', ') || '없음' }}</p>
      </div>

      <div class="form-group">
        <label>할인율 선택 </label>
        <select v-model.number="discountRate" class="form-control">
          <option disabled :value="0">할인율을 선택해주세요</option>
          <option :value="0">할인을 적용하지 않습니다.</option>
          <option :value="10">10%</option>
          <option :value="15">15%</option>
          <option :value="20">20%</option>
          <option :value="25">25%</option>
          <option :value="30">30%</option>
        </select>
        {{ discountRate }}
      </div>

      <div v-if="discountedProducts.length" class="mt-3">
        <h5>할인 적용된 가격</h5>
        <ul>
          <li v-for="item in discountedProducts" :key="item.id">
            {{ item.name }} –
            <strong>{{ item.discountedPrice.toLocaleString() }}원</strong>
            <small class="text-muted">(원가 {{ item.price.toLocaleString() }}원)</small>
          </li>
        </ul>
      </div>

      <button class="btn btn-primary" @click="enterBroadcast"
              :disabled="selectedProducts.length === 0 || selectedProducts.length > 3">방송 시작
      </button>
    </div>

    <!-- 방송 준비/송출 화면 -->
    <div class="stream-session" v-if="session">
      <div class="stream-header">
        <h2>{{ streamTitle }}</h2>
        <div class="stream-info">
          <span class="viewer-count">👥 시청자 {{ viewerCount }}명</span>
        </div>
        <div class="product-info">
          <div v-for="item in discountedProducts" :key="item.id" class="product-item">
            <h3>{{ item.name }}</h3>
            <strong>{{ item.discountedPrice.toLocaleString() }}원</strong>
            <small class="text-muted">(정가 {{ item.price.toLocaleString() }}원)</small>
            <p>{{ item.description }}</p>
          </div>
        </div>
        <button class="btn btn-danger" @click="endStream">방송 종료</button>
      </div>
      <div class="video-container">
        <div v-if="!publisher" class="loading-message">
          카메라 연결 중...
        </div>
        <user-video v-else :stream-manager="publisher"/>
      </div>
    </div>
  </div>
</template>

<script setup>

import {ref, onBeforeUnmount, onMounted, computed} from 'vue';
import {useRoute} from 'vue-router'
import axios from 'axios';
import {OpenVidu} from 'openvidu-browser';
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


//입점업체 상품 가져오기
const productList = async () => {
  try {
    const response = await axios.get(
        `${APPLICATION_SERVER_URL}api/sessions/${vendorId}/productList`,
        {headers: {'Content-Type': 'application/json'}}
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
  const idx = selectedProducts.value.indexOf(prod)
  if (idx > -1) {
    selectedProducts.value.splice(idx, 1)
  } else if (selectedProducts.value.length < 3) {
    selectedProducts.value.push(prod)
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
          headers: {'Content-Type': 'application/json'},
          // data: {endTime: endTime.value}
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

    // 세션 종료 
    await session.value.disconnect();
    
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
      {headers: {'Content-Type': 'application/json'}}
  );
  return response.data;
};

onMounted(() => {
  productList();
})

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
</script>

<style scoped>
.host-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.stream-setup {
  max-width: 600px;
  margin: 0 auto;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
}

.form-control {
  width: 100%;
  padding: 8px;
  margin-bottom: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.btn {
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.btn-primary {
  background-color: black;
  color: white;
}

.btn-danger {
  background-color: #dc3545;
  color: white;
}

.stream-session {
  width: 100%;
}

.stream-header {
  margin-bottom: 20px;
}

.video-container {
  width: 100%;
  height: 0;
  padding-bottom: 56.25%; /* 16:9 비율 */
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

.form-control[multiple] {
  height: auto;
  min-height: 150px;
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

.thumbnail-preview {
  max-width: 200px;
  max-height: 200px;
  margin-top: 10px;
  border-radius: 4px;
  object-fit: cover;
}

.stream-info {
  margin: 10px 0;
  font-size: 1.1em;
}

.viewer-count {
  color: #666;
  font-weight: bold;
}
</style> 