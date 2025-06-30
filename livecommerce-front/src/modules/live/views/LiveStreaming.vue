<template>
  <div class="live-streaming-page">
    <navbar-one />
    <div class="main-wrapper">
      <!-- 헤더 없이 바로 메인 컨텐츠 -->
      <div v-if="!session || !mainStreamManager" class="loading-overlay">
        <div class="text-center">
          <i class="fas fa-spinner fa-spin text-4xl mb-4"></i>
          <p>{{ loadingMessage }}</p>
        </div>
      </div>
      <template v-else>
        <header class="header-bar">
          <div class="stream-info">
            <h1 class="title">{{ streamData.title }}</h1>
            <p class="vendor">{{ streamData.vendorName }}</p>
          </div>
          <div class="live-badge">
            <span class="status">
              <span class="red-dot"></span>
              LIVE
            </span>
            <span class="timer">{{ displayElapsed }}</span>
          </div>
        </header>
        <main class="main-container">
          <div class="content-area">
            <div class="video-wrapper home-shopping">
              <user-video :stream-manager="mainStreamManager"
                style="position: absolute; top:0; left:0; width:100%; height:100%;" />
            </div>
            <div class="products-row" v-if="streamData.products && streamData.products.length">
              <div class="product-card-row" v-for="item in streamData.products.slice(0, 3)" :key="item.id"
                @click="openProductDetails(item.productId)">
                <div class="product-image-row">
                  <img :src="getProductImageSrc(item)" alt="상품 이미지" @error="handleImageError" />
                </div>
                <div class="product-info-row">
                  <div class="name-container">
                    <div class="name">{{ item.name }}</div>
                    <span v-if="item.discountRate > 0" class="discount-badge">
                      {{ item.discountRate }}% 할인
                    </span>
                  </div>
                  <div class="price-container">
                    <span class="discount-price">{{ item.discountedPrice.toLocaleString() }}원</span>
                    <span class="original-price">{{ item.price.toLocaleString() }}원</span>
                  </div>
                  <button class="buy-button" @click.stop="openProductDetails(item.productId)">구매하기</button>
                </div>
              </div>
            </div>
            <div v-else class="no-products">진행 중인 상품이 없습니다.</div>
          </div>
          <aside class="chat-column">
            <chat-container v-if="chatRoomId" :room-id="chatRoomId" :initial-announcement="streamData.announcement" />
            <div v-else class="h-full flex items-center justify-center text-center text-gray-500">
              <div>
                <i class="fas fa-spinner fa-spin text-xl mb-2"></i>
                <p>채팅방을 불러오는 중...</p>
              </div>
            </div>
          </aside>
        </main>
      </template>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useAuthStore } from "@/modules/auth/stores/auth";
import { OpenVidu } from 'openvidu-browser';
import UserVideo from '@/modules/live/components/UserVideo.vue';
import ChatContainer from '@/modules/chat/components/ChatContainer.vue';
import { v4 as uuidv4 } from 'uuid';
import axiosInstance from "@/api/axios";
import NavbarOne from '@/components/navbar/navbar-one.vue';

// 라우터 설정
const route = useRoute();
const router = useRouter();
const auth = useAuthStore();

const sessionId = ref(undefined);
sessionId.value = route.params.sessionId;

// OpenVidu 관련 상태 관리
const OV = ref(undefined);
const session = ref(undefined);
const mainStreamManager = ref(undefined);
const streamData = ref({});
const loadingMessage = ref('방송에 연결 중입니다...');

// 시청자 통계 관련 상태
const viewerCount = ref(0);
const startTime = ref(null); // 호스트의 방송 시작 시간을 저장
const now = ref(Date.now());
let timerId;
let viewerCountInterval;

// OpenVidu 관련 상태 관리 아래에 추가
const chatRoomId = ref(null);  // 채팅방 ID 저장용

// 플래그 선언 (최상단)
let isSessionCleaned = false;

// 사용자 ID 관리
const getUserId = () => {
  // 로그인한 사용자는 auth에서 ID 가져오기
  if (auth.user?.id) {
    return auth.user.id;
  }

  // 비로그인 사용자는 localStorage에서 ID 가져오기 또는 생성
  let anonymousId = localStorage.getItem('anonymousId');
  if (!anonymousId) {
    // 새로운 익명 ID 생성 (UUID v4)
    anonymousId = `anon_${uuidv4()}`;
    localStorage.setItem('anonymousId', anonymousId);
  }
  return anonymousId;
};

// 시청자 입장 처리
const addViewerJoin = async () => {
  try {
    const sessionId = route.params.sessionId;
    console.log("[입장 세션]", sessionId);
    const userId = getUserId();
    await axiosInstance.post(`/api/sessions/${sessionId}/users/${userId}/join`, {
      isAnonymous: !auth.user?.id // 익명 사용자 여부 전달
    });
    console.log('시청자 입장 처리 완료');
  } catch (error) {
    console.error('시청자 입장 처리 실패:', error);
  }
};

// 시청자 퇴장 처리
const saveViewerLeave = async () => {
  try {
    console.log("[퇴장]: 퇴장 처리 호출");
    // const sessionId = route.params.sessionId;
    console.log("[sessionId]", sessionId.value);
    const userId = getUserId();
    await axiosInstance.post(`/api/sessions/${sessionId.value}/users/${userId}/leave`, {
      isAnonymous: !auth.user?.id
    });
    console.log('시청자 퇴장 처리 완료');
  } catch (error) {
    console.error('시청자 퇴장 처리 실패:', error);
  }
};

/**
 * 새로운 스트림 생성 시 호출되는 이벤트 핸들러
 * 1. 스트림을 구독하고 비디오 표시 설정
 * 2. 호스트 정보 저장
 */
const handleStreamCreated = async ({ stream }) => {
  try {
    // 스트림 구독 설정
    mainStreamManager.value = await session.value.subscribeAsync(stream, {
      insertMode: 'APPEND',
    });

    // 호스트 정보 파싱 및 저장
    const connectionData = JSON.parse(stream.connection.data || '{}');
    if (connectionData.clientData?.type === 'host') {
      streamData.value = connectionData.clientData;
      // ✅ 채팅방 ID 저장
      if (connectionData.clientData.chatRoomId) {
        chatRoomId.value = connectionData.clientData.chatRoomId;
        console.log('채팅방 ID 수신:', chatRoomId.value);
      }
      // ✅ 방송 시작 시간 저장
      if (connectionData.clientData.startTime) {
        startTime.value = new Date(connectionData.clientData.startTime).getTime();
        console.log('방송 시작 시간 수신:', new Date(startTime.value));
      }
    }
  } catch (error) {
    console.error('스트림 구독 중 오류 발생:', error);
    loadingMessage.value = '스트림 구독 중 오류가 발생했습니다.';
  }
};

/**
 * 스트림 종료 시 호출되는 이벤트 핸들러
 * - 스트림 정리 및 메인 페이지로 리다이렉트
 */
const handleStreamDestroyed = (event) => {
  console.log('Stream destroyed event:', event);
  if (mainStreamManager.value) {
    mainStreamManager.value = undefined;
    loadingMessage.value = '방송이 종료되었습니다.';
    setTimeout(() => {
      router.push('/');
    }, 2000);
  }
};

/**
 * 세션 연결 해제 시 호출되는 이벤트 핸들러
 * - 세션 정리 및 메인 페이지로 리다이렉트
 */
const handleSessionDisconnected = (event) => {
  console.log('Session disconnected event:', event);
  cleanupSession();
  loadingMessage.value = '방송이 종료되었습니다. 시청해주셔서 감사합니다.';
  setTimeout(() => {
    router.push('/');
  }, 2000);
};

/**
 * 참가자 퇴장 시 호출되는 이벤트 핸들러
 * - 현재 사용자가 퇴장된 경우 세션 정리
 */
const handleParticipantEvicted = (event) => {
  console.log('Participant evicted event:', event);
  try {
    const currentConnectionId = session.value?.connection?.connectionId;
    const evictedConnectionId = event?.connection?.connectionId;

    if (currentConnectionId && evictedConnectionId && currentConnectionId === evictedConnectionId) {
      cleanupSession();
      loadingMessage.value = '방송에서 퇴장되었습니다.';
      setTimeout(() => {
        router.push('/');
      }, 2000);
    }
  } catch (error) {
    console.error('참가자 퇴장 처리 중 오류 발생:', error);
    cleanupSession();
    router.push('/');
  }
};

/**
 * 세션 토큰 발급 함수
 * - 백엔드 서버에 토큰 요청
 * - 에러 처리 및 적절한 메시지 반환
 */
const getToken = async (sessionId) => {
  try {
    const response = await axiosInstance.post(
      `/api/sessions/${sessionId}/connections`,
      {},
      {
        headers: { 'Content-Type': 'application/json' },
        timeout: 5000 // 5초 타임아웃 설정
      }
    );
    return response.data;
  } catch (error) {
    console.error('토큰 발급 중 오류 발생:', error);
    if (error.code === 'ERR_NETWORK') {
      throw new Error('서버에 연결할 수 없습니다. 네트워크 연결을 확인해주세요.');
    }
    if (error.response?.status === 404) {
      throw new Error('존재하지 않는 방송입니다.');
    }
    throw new Error(error.message || '토큰 발급 중 오류가 발생했습니다.');
  }
};

// 시청자 수 업데이트
const updateViewerCount = async () => {
  try {
    const sessionId = route.params.sessionId;
    const response = await axiosInstance.get(`/api/sessions/${sessionId}/viewers/count`);
    viewerCount.value = response.data.count;
  } catch (error) {
    console.error('시청자 수 업데이트 실패:', error);
  }
};

/**
 * OpenVidu 세션에 연결하는 함수
 * 1. OpenVidu 객체 초기화
 * 2. 세션 초기화 및 이벤트 리스너 설정
 * 3. 토큰 발급 및 세션 연결
 * 4. 시청자 입장 처리
 * 5. 주기적으로 시청자 수 업데이트
 */
const joinSession = async () => {
  try {
    OV.value = new OpenVidu();
    session.value = OV.value.initSession();

    session.value.on('streamCreated', handleStreamCreated);
    session.value.on('streamDestroyed', handleStreamDestroyed);
    session.value.on('sessionDisconnected', handleSessionDisconnected);
    session.value.on('participantEvicted', handleParticipantEvicted);

    const sessionId = route.params.sessionId;
    const token = await getToken(sessionId);
    await session.value.connect(token, {
      clientData: {
        type: 'consumer',
        userId: getUserId(),
      },
    });

    await addViewerJoin();

    // 시청자 수 주기적 업데이트
    updateViewerCount();
    viewerCountInterval = setInterval(updateViewerCount, 10000); // 10초마다

    // 방송 경과 시간 업데이트 (호스트의 방송 시작 시간 사용)
    if (!startTime.value) {
      startTime.value = Date.now(); // 호스트 정보가 아직 없는 경우 현재 시간으로 설정
    }
    timerId = setInterval(() => {
      now.value = Date.now();
    }, 1000);

  } catch (error) {
    console.error('세션 연결 실패:', error);
    loadingMessage.value = error.message;
    cleanupSession();
  }
};

/**
 * 세션 및 관련 리소스 정리
 */
const cleanupSession = () => {
  if (isSessionCleaned) return; // 중복 방지
  isSessionCleaned = true;
  if (session.value) {
    session.value.disconnect();
  }
  OV.value = undefined;
  session.value = undefined;
  mainStreamManager.value = undefined;
  clearInterval(timerId);
  clearInterval(viewerCountInterval);
};

// 컴포넌트 마운트 시 플래그 초기화
onMounted(() => {
  isSessionCleaned = false;
  joinSession();
});

// 컴포넌트 언마운트 시 세션 정리
onBeforeUnmount(async () => {
  await saveViewerLeave();
  cleanupSession();
});

// 방송 경과 시간 계산
const displayElapsed = computed(() => {
  if (!startTime.value) return '--:--:--';
  const elapsed = Math.floor((now.value - startTime.value) / 1000);
  if (elapsed < 0) return '--:--:--'; // 방송 시작 전
  const hours = Math.floor(elapsed / 3600).toString().padStart(2, '0');
  const minutes = Math.floor((elapsed % 3600) / 60).toString().padStart(2, '0');
  const seconds = (elapsed % 60).toString().padStart(2, '0');
  return `${hours}:${minutes}:${seconds}`;
});

// 상품 상세 페이지로 이동 (새 탭)
const openProductDetails = (productId) => {
  const url = router.resolve({ name: 'ProductDetails', params: { id: productId } }).href;
  window.open(url, '_blank');
};

// 이미지 에러 핸들러
const handleImageError = (event) => {
  event.target.src = '/no-image.png'; // 기본 이미지 경로
};

function getProductImageSrc(item) {
  if (!item.image) return '/no-image.png';
  if (item.image.startsWith('http')) return item.image;
  return `http://localhost:8080/uploads/images/${item.image}`;
}
</script>

<style scoped>
.live-streaming-page {
  background-color: #fff;
  min-height: 100vh;
  height: auto;
  overflow: visible;
}

.main-wrapper {
  max-width: 1500px;
  margin: 0 auto;
  padding: 0 1rem 2.5rem 1rem;
  background: #fff;
  border-radius: 1.5rem;
  border: 1.5px solid #e5e7eb;
  box-shadow: 0 6px 32px rgba(0, 0, 0, 0.08);
}

.header-bar {
  margin-top: 2.5rem;
  background: #fff;
  border-radius: 1.2rem;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
  padding: 1.5rem 2.5rem 1.5rem 2.5rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.stream-info .title {
  font-size: 1.3rem;
  font-weight: 700;
  color: #18181b;
}

.stream-info .vendor {
  font-size: 0.95rem;
  color: #71717a;
  margin-top: 0.25rem;
}

.live-badge {
  display: flex;
  align-items: center;
  gap: 1.2rem;
}

.live-badge .status {
  background-color: #ef4444;
  color: white;
  padding: 0.25rem 0.9rem;
  border-radius: 9999px;
  font-size: 1rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.live-badge .status .red-dot {
  width: 0.5rem;
  height: 0.5rem;
  background-color: white;
  border-radius: 9999px;
  animation: pulse 1.5s infinite;
}

.live-badge .timer {
  font-size: 1rem;
  font-weight: 500;
  color: #52525b;
}

@keyframes pulse {

  0%,
  100% {
    opacity: 1;
  }

  50% {
    opacity: 0.5;
  }
}

.main-container {
  display: flex;
  gap: 1.5rem;
  margin-top: 2rem;
}

.content-area {
  flex: 2 1 0%;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.video-wrapper.home-shopping {
  width: 100%;
  max-width: 1100px;
  aspect-ratio: 16/9;
  background: #000;
  border-radius: 1.2rem;
  overflow: hidden;
  margin: 0 auto;
  position: relative;
  box-shadow: 0 6px 24px rgba(0, 0, 0, 0.10);
}

.products-row {
  display: flex;
  gap: 2rem;
  margin-top: 1.2rem;
  justify-content: center;
}

.product-card-row {
  flex: 1 1 0;
  max-width: 250px;
  background: #fff;
  border-radius: 1rem;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
  padding: 1.2rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  cursor: pointer;
  transition: box-shadow 0.2s, transform 0.2s;
}

.product-card-row:hover {
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.14);
  transform: translateY(-3px) scale(1.04);
}

.product-image-row {
  width: 100px;
  height: 100px;
  margin-bottom: 1rem;
}

.product-image-row img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 0.7rem;
}

.product-info-row .name-container {
  margin-bottom: 0.7rem;
  text-align: center;
}

.product-info-row .name {
  font-weight: 700;
  font-size: 1.1rem;
  margin-bottom: 0.5rem;
  text-align: center;
}

.product-info-row .discount-badge {
  background-color: #dc2626;
  color: white;
  padding: 0.3rem 0.7rem;
  border-radius: 9999px;
  font-size: 0.85rem;
  font-weight: 700;
  margin-left: 0.5rem;
}

.product-info-row .price-container {
  margin-bottom: 0.7rem;
  text-align: center;
}

.discount-price {
  color: #dc2626;
  font-weight: 700;
  font-size: 1.15rem;
}

.original-price {
  color: #a1a1aa;
  text-decoration: line-through;
  margin-left: 0.5rem;
  font-size: 1rem;
}

.buy-button {
  width: 100%;
  background: #2563eb;
  color: #fff;
  border: none;
  border-radius: 0.7rem;
  padding: 0.6rem 0;
  font-weight: 700;
  font-size: 1.05rem;
  margin-top: 0.7rem;
  cursor: pointer;
  transition: background 0.2s;
}

.buy-button:hover {
  background: #1d4ed8;
}

.chat-column {
  width: 370px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  background-color: white;
  border-radius: 1rem;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  min-height: 540px;
  max-height: 800px;
}

@media (max-width: 1200px) {
  .main-wrapper {
    max-width: 100vw;
    padding: 0 0.5rem;
  }

  .main-container {
    gap: 1.2rem;
  }

  .video-wrapper.home-shopping {
    max-width: 100vw;
  }
}

@media (max-width: 900px) {
  .main-container {
    flex-direction: column;
  }

  .chat-column {
    width: 100%;
    max-width: 100vw;
    min-height: 350px;
    margin-top: 1.5rem;
  }
}
</style>