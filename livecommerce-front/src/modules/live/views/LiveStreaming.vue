<template>
  <div class="live-consumer">
    <!-- Live Info Bar -->
    <div class="live-info-bar" v-if="session && mainStreamManager">
      <div class="live-title">{{ streamData.title }}</div>
      <div class="vendor-name">{{ streamData.vendorName }}</div>
      <div class="viewer-count">
        <span class="viewer-number">{{ viewerCount }}</span>명
      </div>
      <div class="timer">⏱ {{ displayElapsed }} 방송중</div>
    </div>

    <!-- Body: Video + Products and Chat Side by Side -->
    <div class="live-body" v-if="session && mainStreamManager">
      <!-- Left: Video and Products -->
      <div class="main-content">
        <!-- Video Area -->
        <div class="live-video-container">
          <user-video :stream-manager="mainStreamManager"/>
        </div>

        <!-- Products Display -->
        <div class="products">
          <div class="product-card" v-for="item in streamData.products" :key="item.id">
            <div class="product-image">
              <img :src="item.imageUrl" alt="상품 이미지"/>
            </div>
            <div class="product-name">{{ item.name }}</div>
            <div class="price">
              <span class="discount-price">{{ item.discountedPrice.toLocaleString() }}원</span>
              <span class="original-price">{{ item.price.toLocaleString() }}원</span>
            </div>
            <button class="btn btn-primary">구매하기</button>
          </div>
        </div>
      </div>

      <!-- Right: Chat Area -->
      <div class="chat-area">
        <chat-container/>
      </div>
    </div>

    <!-- Loading/Error Message -->
    <div class="loading" v-else>
      <p>{{ loadingMessage }}</p>
    </div>
  </div>
</template>

<script setup>
import {ref, onMounted, onBeforeUnmount, computed} from 'vue';
import {useRoute, useRouter} from 'vue-router';
import {useAuthStore} from "@/modules/auth/stores/auth";
import axios from 'axios';
import {OpenVidu} from 'openvidu-browser';
import UserVideo from '@/modules/live/components/UserVideo.vue';
import ChatContainer from '@/modules/chat/components/ChatContainer.vue';
import { v4 as uuidv4 } from 'uuid';

// 라우터 설정
const route = useRoute();
const router = useRouter();
const auth = useAuthStore();
const APPLICATION_SERVER_URL = process.env.NODE_ENV === 'production' ? ''
    : 'http://localhost:8080/';

// OpenVidu 관련 상태 관리
const OV = ref(undefined);
const session = ref(undefined);
const mainStreamManager = ref(undefined);
const streamData = ref({});
const loadingMessage = ref('방송에 연결 중입니다...');

// 시청자 통계 관련 상태
const viewerCount = ref(0);
const startTime = ref(Date.now());
const now = ref(Date.now());
let timerId;
let viewerCountInterval;

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
    const userId = getUserId();
    await axios.post(`${APPLICATION_SERVER_URL}api/sessions/${sessionId}/users/${userId}/join`, {
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
    const sessionId = route.params.sessionId;
    const userId = getUserId();
    await axios.post(`${APPLICATION_SERVER_URL}api/sessions/${sessionId}/users/${userId}/leave`, {
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
const handleStreamCreated = async ({stream}) => {
  try {
    // 스트림 구독 설정
    mainStreamManager.value = await session.value.subscribeAsync(stream, {
      insertMode: 'APPEND',
    });

    // 호스트 정보 파싱 및 저장
    const connectionData = JSON.parse(stream.connection.data || '{}');
    if (connectionData.clientData?.type === 'host') {
      streamData.value = connectionData.clientData;
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
  loadingMessage.value = '세션이 종료되었습니다.';
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
    const response = await axios.post(
        `${APPLICATION_SERVER_URL}api/sessions/${sessionId}/connections`,
        {},
        {
          headers: {'Content-Type': 'application/json'},
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
    const response = await axios.get(`${APPLICATION_SERVER_URL}api/sessions/${sessionId}/viewers/count`);
    viewerCount.value = response.data;
  } catch (error) {
    console.error('시청자 수 업데이트 실패:', error);
  }
};

/**
 * 세션 참가 함수
 * 1. OpenVidu 세션 초기화
 * 2. 이벤트 핸들러 등록
 * 3. 토큰 발급 및 세션 연결
 */
const joinSession = async (sessionId) => {
  try {
    // 이전 세션 정리
    if (session.value) {
      cleanupSession();
    }

    // OpenVidu 초기화
    OV.value = new OpenVidu();
    session.value = OV.value.initSession();

    // 이벤트 핸들러 등록
    session.value.on('streamCreated', handleStreamCreated);
    session.value.on('streamDestroyed', handleStreamDestroyed);
    session.value.on('sessionDisconnected', handleSessionDisconnected);
    session.value.on('participantEvicted', handleParticipantEvicted);

    // 에러 이벤트 핸들러
    session.value.on('error', (error) => {
      console.error('Session error:', error);
      loadingMessage.value = getErrorMessage(error);
      if (error.name === 'NETWORK_ERROR' || error.name === 'DISCONNECTED') {
        cleanupSession();
        router.push('/');
      }
    });

    // 세션 연결
    const token = await getToken(sessionId);
    if (!token) {
      throw new Error('토큰을 받아올 수 없습니다.');
    }

    await session.value.connect(token, {clientData: {type: 'viewer'}});
    
    // 시청자 입장 처리 및 시청자 수 업데이트 시작
    await addViewerJoin();
    viewerCountInterval = setInterval(updateViewerCount, 5000); // 5초마다 시청자 수 업데이트

  } catch (error) {
    console.error('세션 참가 중 오류 발생:', error);
    loadingMessage.value = error.message || '방송 참여 중 오류가 발생했습니다.';
    setTimeout(() => {
      router.push('/');
    }, 3000);
  }
};

/**
 * 에러 메시지 생성 함수
 * - OpenVidu 에러 타입별 사용자 친화적 메시지 반환
 */
const getErrorMessage = (error) => {
  switch (error.name) {
    case 'GENERIC_ERROR':
      return '연결 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
    case 'NETWORK_ERROR':
      return '네트워크 연결을 확인해주세요.';
    case 'MEDIA_ACCESS_DENIED':
      return '카메라/마이크 접근이 거부되었습니다.';
    case 'DISCONNECTED':
      return '연결이 종료되었습니다.';
    case 'USER_NOT_FOUND':
      return '사용자를 찾을 수 없습니다.';
    default:
      return '알 수 없는 오류가 발생했습니다.';
  }
};

/**
 * 세션 정리 함수
 * - 이벤트 리스너 제거
 * - 스트림 구독 해제
 * - 세션 연결 해제
 * - 상태 초기화
 */
const cleanupSession = () => {
  try {
    if (session.value) {
      // 이벤트 리스너 제거
      session.value.off('streamCreated');
      session.value.off('streamDestroyed');
      session.value.off('sessionDisconnected');
      session.value.off('participantEvicted');
      session.value.off('error');

      // 스트림 구독 해제
      if (mainStreamManager.value) {
        session.value.unsubscribe(mainStreamManager.value);
        mainStreamManager.value = undefined;
      }

      // 시청자 퇴장 처리
      saveViewerLeave();
      
      // 시청자 수 업데이트 중지
      if (viewerCountInterval) {
        clearInterval(viewerCountInterval);
      }

      // 세션 연결 해제
      session.value.disconnect();
    }
  } catch (error) {
    console.error('세션 정리 중 오류 발생:', error);
  } finally {
    // 상태 초기화
    session.value = undefined;
    OV.value = undefined;
    streamData.value = {};
    viewerCount.value = 0;
  }
};

// 페이지 새로고침/종료 시 정리
window.addEventListener('beforeunload', () => {
  cleanupSession();
});

// 컴포넌트 마운트 시 세션 참가
onMounted(async () => {
  try {
    const sessionId = route.params.sessionId;
    await joinSession(sessionId);
    
    // 타이머 시작
    timerId = setInterval(() => {
      now.value = Date.now();
    }, 1000);
  } catch (error) {
    console.error('방송 참여 중 오류 발생:', error);
    loadingMessage.value = '방송 참여 중 오류가 발생했습니다.';
    setTimeout(() => {
      router.push('/');
    }, 2000);
  }
});

// 컴포넌트 언마운트 시 정리
onBeforeUnmount(() => {
  cleanupSession();
  if (timerId) {
    clearInterval(timerId);
  }
});

const displayElapsed = computed(() => {
  const diff = Math.floor((now.value - startTime.value) / 1000);
  const h = String(Math.floor(diff / 3600)).padStart(2, '0');
  const m = String(Math.floor((diff % 3600) / 60)).padStart(2, '0');
  const s = String(diff % 60).padStart(2, '0');
  return `${h}:${m}:${s}`;
});
</script>

<style scoped>
.live-consumer {
  width: 100%;
  max-width: 1400px;
  margin: 0 auto;
  padding: 24px;
  box-sizing: border-box;
  font-family: 'Noto Sans KR', sans-serif;
  color: #333;
  height: 100vh;
  display: flex;
  flex-direction: column;
}

.live-info-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #fafafa;
  padding: 12px 16px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  margin-bottom: 16px;
  font-size: 14px;
}

.live-title {
  font-size: 18px;
  font-weight: 600;
  color: #2c3e50;
}

.vendor-name {
  color: #7f8c8d;
}

.viewer-count {
  display: flex;
  align-items: center;
}

.viewer-number {
  margin-right: 4px;
  color: #e74c3c;
  font-weight: 600;
}

.timer {
  font-weight: 500;
  color: #2980b9;
}

.live-body {
  display: flex;
  gap: 24px;
  flex: 1;
  min-height: 0;
}

.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-height: 0;
}

.live-video-container {
  position: relative;
  width: 100%;
  aspect-ratio: 16 / 9;
  background-color: #000;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  margin-bottom: 16px;
}

.products {
  display: flex;
  gap: 16px;
  flex: 1;
  margin-top: 30px;
}

.product-card {
  flex: 1;
  background: #fff;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  border-radius: 8px;
  padding: 12px;
  text-align: center;
  height: fit-content;
}

.product-image img {
  width: 100%;
  height: auto;
  border-radius: 6px;
  margin-bottom: 8px;
}

.product-name {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 6px;
}

.price {
  display: flex;
  justify-content: center;
  align-items: baseline;
  margin-bottom: 12px;
}

.discount-price {
  font-size: 16px;
  color: #e74c3c;
  font-weight: 600;
  margin-right: 6px;
}

.original-price {
  font-size: 14px;
  color: #bdc3c7;
  text-decoration: line-through;
}

.chat-area {
  width: 350px;
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 0;
}

.chat-area :deep(chat-container) {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.btn {
  width: 100%;
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 500;
  transition: background-color 0.2s;
}

.btn-primary {
  background-color: #007bff;
  color: white;
}

.btn-primary:hover {
  background-color: #0056b3;
}

.loading {
  text-align: center;
  padding: 50px;
  font-size: 1.2em;
  color: #666;
}

@media (max-width: 1024px) {
  .live-body {
    flex-direction: column;
  }

  .chat-area {
    width: 100%;
    height: 400px;
    margin-top: 24px;
  }

  .products {
    flex-wrap: wrap;
  }

  .product-card {
    flex: 1 1 calc(50% - 16px);
    margin-bottom: 16px;
  }
}

@media (max-width: 600px) {
  .live-info-bar {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }

  .live-info-bar > * {
    width: 100%;
  }

  .product-card {
    flex: 1 1 100%;
  }

  .chat-area {
    height: 300px;
  }
}
</style>