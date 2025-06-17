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
  <div class="min-h-screen bg-gray-50 p-5">
    <!-- 방송 설정 화면 -->
    <div v-if="!session" class="max-w-5xl mx-auto">
      <div class="bg-white rounded-lg shadow-md p-8">
        <h2 class="text-2xl font-bold text-center text-gray-800 mb-8">라이브 방송 준비</h2>

        <div class="grid md:grid-cols-2 gap-8">
          <!-- 왼쪽 컬럼: 기본 정보 -->
          <div class="space-y-6">
            <!-- 방송 제목 -->
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">방송 제목</label>
              <input v-model="streamTitle" type="text" placeholder="방송 제목을 입력해주세요"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                required />
            </div>

            <!-- 공지사항 -->
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">공지 사항</label>
              <textarea v-model="announcement" placeholder="시청자들에게 전달할 공지사항을 입력해주세요" rows="3"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition resize-none"
                required></textarea>
            </div>

            <!-- 썸네일 업로드 -->
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">썸네일 이미지</label>
              <input @change="handleThumbnailChange" type="file" accept="image/*"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
                required />
              <div v-if="thumbnailPreview" class="relative inline-block mt-4">
                <img :src="thumbnailPreview" class="max-w-[200px] max-h-[200px] rounded-lg shadow-md object-cover"
                  alt="썸네일 미리보기" />
                <button @click="removeThumbnail"
                  class="absolute -top-2 -right-2 w-7 h-7 bg-red-500 text-white rounded-full flex items-center justify-center hover:bg-red-600 transition">
                  ✕
                </button>
              </div>
            </div>

            <!-- 카테고리 선택 -->
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">카테고리 선택</label>
              <select v-model="category"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition">
                <option disabled value="">카테고리를 선택해주세요</option>
                <option value="혈압">혈압</option>
                <option value="눈">눈</option>
                <option value="뼈/관절/연골">뼈/관절/연골</option>
                <option value="장건강">장건강</option>
                <option value="영양보충">영양보충</option>
              </select>
            </div>
          </div>

          <!-- 오른쪽 컬럼: 상품 및 할인 설정 -->
          <div class="space-y-6">
            <!-- 상품 선택 -->
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">
                판매 상품 선택 <span class="text-sm font-normal text-gray-500">(최대 3개)</span>
              </label>
              <div class="border border-gray-300 rounded-lg max-h-80 overflow-y-auto">
                <div v-for="product in availableProducts" :key="product.id" @click="toggleProduct(product)"
                  class="flex justify-between items-center p-4 border-b last:border-b-0 cursor-pointer transition-colors"
                  :class="{
                    'bg-blue-50': selectedProducts.includes(product),
                    'opacity-50 cursor-not-allowed': selectedProducts.length >= 3 && !selectedProducts.includes(product),
                    'hover:bg-gray-50': !selectedProducts.includes(product) && selectedProducts.length < 3
                  }">
                  <div>
                    <div class="font-medium text-gray-800">{{ product.name }}</div>
                    <div class="text-sm text-gray-600">{{ product.price.toLocaleString() }}원</div>
                  </div>
                  <div class="w-6 h-6 rounded-full border-2 flex items-center justify-center"
                    :class="selectedProducts.includes(product) ? 'bg-blue-500 border-blue-500' : 'border-gray-300'">
                    <span v-if="selectedProducts.includes(product)" class="text-white text-sm">✓</span>
                  </div>
                </div>
              </div>
              <p v-if="showMaxProductsError" class="text-red-500 text-sm mt-2">
                최대 3개의 상품만 선택할 수 있습니다.
              </p>
            </div>

            <!-- 할인율 설정 -->
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">할인율 설정</label>
              <select v-model.number="discountRate"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition">
                <option disabled :value="0">할인율을 선택해주세요</option>
                <option :value="0">할인 미적용</option>
                <option :value="10">10% 할인</option>
                <option :value="15">15% 할인</option>
                <option :value="20">20% 할인</option>
                <option :value="25">25% 할인</option>
                <option :value="30">30% 할인</option>
              </select>
            </div>

            <!-- 할인 미리보기 -->
            <div v-if="discountedProducts.length" class="bg-gray-50 p-4 rounded-lg">
              <h5 class="font-semibold text-gray-700 mb-3">할인 적용 예시</h5>
              <div class="space-y-2">
                <div v-for="item in discountedProducts" :key="item.id"
                  class="flex justify-between items-center p-3 bg-white rounded">
                  <div class="font-medium text-gray-800">{{ item.name }}</div>
                  <div class="flex items-center gap-2 text-sm">
                    <span class="text-gray-500 line-through">{{ item.price.toLocaleString() }}원</span>
                    <span class="text-gray-400">→</span>
                    <span class="text-red-600 font-semibold">{{ item.discountedPrice.toLocaleString() }}원</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 방송 시작 버튼 -->
        <div class="mt-8 flex justify-center">
          <button @click="enterBroadcast" :disabled="!isFormValid"
            class="px-8 py-3 bg-blue-600 text-white font-semibold rounded-lg shadow-md transition-all duration-200"
            :class="isFormValid ? 'hover:bg-blue-700 hover:shadow-lg' : 'opacity-50 cursor-not-allowed'">
            방송 시작하기
          </button>
        </div>
      </div>
    </div>

    <!-- 라이브 스트리밍 화면 -->
    <div v-if="session" class="max-w-7xl mx-auto">
      <div class="grid grid-cols-1 lg:grid-cols-[1fr,320px] gap-4">
        <!-- 메인 콘텐츠 영역 -->
        <div class="flex flex-col gap-3">
          <!-- 헤더 -->
          <div class="bg-white rounded-lg shadow-sm px-4 py-3">
            <h2 class="text-lg font-bold text-gray-800">{{ streamTitle }}</h2>
            <div class="mt-1">
              <span class="text-sm text-gray-600">👥 시청자 <span class="font-semibold">{{ viewerCount }}명</span></span>
            </div>
          </div>

          <!-- 비디오 영역 -->
          <div class="relative bg-black rounded-lg overflow-hidden shadow-lg" style="aspect-ratio: 16/9;">
            <div v-if="!publisher" class="absolute inset-0 flex items-center justify-center">
              <span class="text-white">카메라 연결 중...</span>
            </div>
            <user-video v-else :stream-manager="publisher" class="absolute inset-0" />
          </div>

          <!-- 상품 정보 -->
          <div class="bg-white rounded-lg shadow-sm p-4 max-h-48 overflow-y-auto">
            <div class="space-y-3">
              <div v-for="item in discountedProducts" :key="item.id" class="pb-3 border-b last:border-b-0 last:pb-0">
                <h3 class="text-base font-semibold text-gray-800">{{ item.name }}</h3>
                <p class="text-xl font-bold text-red-600">{{ item.discountedPrice.toLocaleString() }}원</p>
                <p class="text-xs text-gray-500">(정가 {{ item.price.toLocaleString() }}원)</p>
                <p class="text-sm text-gray-600 mt-1">{{ item.description }}</p>
              </div>
            </div>
          </div>

          <!-- 방송 종료 버튼 -->
          <button @click="endStream"
            class="self-center px-5 py-2 bg-red-600 text-white text-sm font-medium rounded-lg hover:bg-red-700 transition-colors">
            방송 종료
          </button>
        </div>

        <!-- 채팅 영역 -->
        <div class="bg-white rounded-lg shadow-sm overflow-hidden" style="height: 600px;">
          <!-- 채팅방 ID가 생성된 경우에만 ChatContainer를 렌더링 -->
          <ChatContainer v-if="chatRoomId" :room-id="chatRoomId" :initial-announcement="chatAnnouncement"
            class="h-full" />

          <!-- 채팅방 생성 중 또는 실패 시 표시 -->
          <div v-else class="h-full flex items-center justify-center">
            <div class="text-center text-gray-500">
              <i class="fas fa-spinner fa-spin text-xl mb-2"></i>
              <p class="text-sm">채팅방을 준비하고 있습니다...</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// import {useAuthStore} from "@/modules/auth/stores/auth";
// const auth = useAuthStore()

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
const category = ref('');

// 1. 채팅방 정보를 저장할 ref 추가
const liveId = ref(null);
const chatRoomId = ref(null);        // 생성된 채팅방 ID
const chatAnnouncement = ref('');    // 채팅방 공지사항

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
        products: discountedProducts.value,
        liveId: liveId.value,              // 이제 접근 가능
        chatRoomId: chatRoomId.value,       // 이미 ref로 되어 있음
        announcement: chatAnnouncement.value
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

// [서버에 방송 종료 알림 전송]
// 방송 종료 시 세션 종료 및 서버에 방송 종료 알림 전송 
const notifyServerStreamEnded = async (sessionId) => {
  // 종료 시간 알림
  try {
    await axios.delete(
      `${APPLICATION_SERVER_URL}api/sessions/${sessionId}`,
      {
        headers: {
          'Content-Type': 'application/json',
          //'Authorization': `Bearer ${auth.token}`
        },
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
    if (!session.value) {
      return;
    }

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

// 2. 채팅방 생성 API 호출 함수 추가
/**
 * 라이브 시작 시 채팅방을 자동으로 생성합니다.
 *
 * @param {string} liveId - 생성된 라이브 ID
 * @returns {Promise<Object>} 채팅방 정보 (roomId, announcement)
 */
const createChatRoom = async (liveId) => {
  try {
    const response = await axios.post(
      `${APPLICATION_SERVER_URL}api/chat/room/auto-create`,
      { liveId },
      { headers: { 'Content-Type': 'application/json' } }
    );

    console.log('채팅방 생성 성공:', response.data);
    return response.data;
  } catch (error) {
    console.error('채팅방 생성 실패:', error);
    throw error;
  }
};

// [세션 생성 후 세션ID를 반환]
// customSessionId를 통해 세션 생성 API를 호출하면 
// 백엔드에서 세션 객체를 생성하고 세션ID를 반환한다. 
// 4. createSession 함수 수정 - liveId 받아서 채팅방 생성
const createSession = async () => {
  // FormData 객체 생성
  const formData = new FormData();

  // 기본 세션 정보 설정
  formData.append('title', streamTitle.value);
  formData.append('announcement', announcement.value);
  if (thumbnailFile.value) {
    formData.append('thumbnail', thumbnailFile.value);
  }
  formData.append('products', JSON.stringify(selectedProducts.value));
  formData.append('discountRate', discountRate.value);
  formData.append('startTime', startTime.value);
  formData.append('vendorId', vendorId);
  formData.append('category', category.value);

  // 1단계: 라이브 세션 생성
  const response = await axios.post(
    APPLICATION_SERVER_URL + 'api/sessions',
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data',
      }
    }
  );

  console.log("라이브 생성 응답:", response.data);

  // 2단계: 반환받은 liveId로 채팅방 생성
  liveId.value = response.data.liveId;  //  중요: 서버에서 반환한 liveId

  try {
    // 채팅방 자동 생성 API 호출
    const chatRoomData = await createChatRoom(liveId.value);

    // 채팅방 정보 저장 (ChatContainer에 전달할 데이터)
    chatRoomId.value = chatRoomData.roomId;
    chatAnnouncement.value = chatRoomData.announcement || announcement.value;

    console.log('채팅방 생성 완료 - roomId:', chatRoomId.value);
  } catch (error) {
    console.error('채팅방 생성 실패:', error);
    // 채팅방 생성 실패해도 방송은 진행 (옵션)
    alert('채팅 기능을 사용할 수 없습니다. 방송은 계속 진행됩니다.');
  }

  // 3단계: sessionId 반환 (OpenVidu 연결용)
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
    category.value &&
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

<!-- 모든 컴포넌트 스타일을 제거하고 Tailwind 클래스만 사용 -->
<style scoped>
/* UserVideo 컴포넌트가 부모 크기를 채우도록 설정 */
:deep(.stream-component) {
  width: 100%;
  height: 100%;
}

/* ChatContainer가 부모 높이를 모두 사용하도록 설정 */
:deep(.chat-container) {
  height: 100%;
  display: flex;
  flex-direction: column;
}
</style>