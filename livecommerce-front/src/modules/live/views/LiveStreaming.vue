<!--<script setup>-->
<!--import { onMounted } from 'vue';-->


<!--import NavbarOne from '@/components/navbar/navbar-one.vue';-->
<!--// import FooterOne from '@/components/footer/footer-one.vue';-->
<!--// import FooterThree from '@/components/footer/footer-three.vue';-->
<!--import ScrollToTop from '@/components/scroll-to-top.vue';-->

<!--import 'swiper/swiper-bundle.css';-->

<!--import LiveScreen from '@/modules/live/components/LiveScreen.vue';-->

<!--import Aos from 'aos';-->
<!--import 'aos/dist/aos.css';-->

<!--onMounted(() => {-->
<!--  Aos.init()-->
<!--});-->
<!--</script>-->

<!--<template>-->
<!--  <div>-->
<!--    <NavbarOne />-->

<!--    <div class="live-container">-->
<!--      &lt;!&ndash; 상단: 방송 제목 & 메타정보 &ndash;&gt;-->
<!--      <div class="header-bar">-->
<!--        <div class="title-cell">방송 제목</div>-->
<!--        <div class="meta-cell">참여자 수</div>-->
<!--        <div class="meta-cell">방송 경과 시간</div>-->
<!--        <div class="meta-cell">방송 종료 시간</div>-->
<!--      </div>-->

<!--      &lt;!&ndash; 본문 영역: 왼쪽(영상 + 상품) / 오른쪽(공지 및 채팅) &ndash;&gt;-->
<!--      <div class="main-content">-->
<!--        &lt;!&ndash; 왼쪽 영역 &ndash;&gt;-->
<!--        <div class="left-area">-->
<!--          &lt;!&ndash; 라이브 영상 화면 &ndash;&gt;-->
<!--          <div class="video-wrapper">-->
<!--            <LiveScreen />-->
<!--            &lt;!&ndash; <div class="video-header">📺 [라이브 영상 화면 (OpenVidu)]</div> &ndash;&gt;-->
<!--          </div>-->
<!--          &lt;!&ndash; 상품 목록 &ndash;&gt;-->
<!--          <div class="product-list">-->
<!--            <div class="product-card">-->
<!--              <div class="product-title">상품 A</div>-->
<!--              <div class="product-thumb">사진</div>-->
<!--              <div class="product-info">제품명, 가격</div>-->
<!--            </div>-->
<!--            <div class="product-card">-->
<!--              <div class="product-title">상품 B</div>-->
<!--              <div class="product-thumb">사진</div>-->
<!--              <div class="product-info">제품명, 가격</div>-->
<!--            </div>-->
<!--            <div class="product-card">-->
<!--              <div class="product-title">상품 C</div>-->
<!--              <div class="product-thumb">사진</div>-->
<!--              <div class="product-info">제품명, 가격</div>-->
<!--            </div>-->
<!--          </div>-->
<!--        </div>-->

<!--        &lt;!&ndash; 오른쪽 영역 채팅 &ndash;&gt;-->
<!--        <div class="right-area">-->
<!--          &lt;!&ndash; 공지 & FAQ &ndash;&gt;-->
<!--          <div class="notice-box">-->
<!--            <div class="notice-header">-->
<!--              📢 오늘 방송 중 루테인 10% 할인 + 선착순 50명 무료배송!-->
<!--            </div>-->
<!--            <ul class="faq-list">-->
<!--              <li>[유저1] 루테인 복용 방법은 어떻게 되나요?</li>-->
<!--              <li>[유저2] 무료배송 이벤트는 언제까지인가요?</li>-->
<!--              <li>[유저3] 무료배송 이벤트는 언제까지인가요?</li>-->
<!--              <li>…</li>-->
<!--            </ul>-->
<!--          </div>-->

<!--          &lt;!&ndash; 채팅 입력창 &ndash;&gt;-->
<!--          <div class="chat-input-area">-->
<!--            <input type="text" class="chat-input" placeholder="[채팅 입력창]" />-->
<!--            <button class="send-button">SEND</button>-->
<!--          </div>-->
<!--        </div>-->
<!--      </div>-->
<!--    </div>-->

<!--    &lt;!&ndash; <FooterThree /> &ndash;&gt;-->

<!--    <ScrollToTop />-->

<!--  </div>-->
<!--</template>-->

<!--<style scoped>-->
<!--/* ─────────────────────────────────────────────────────────────────────────-->
<!--   전체 컨테이너-->
<!--───────────────────────────────────────────────────────────────────────── */-->
<!--.live-container {-->
<!--  display: flex;-->
<!--  flex-direction: column;-->
<!--  border: 2px solid #444;    /* 전체 테두리 색상 */-->
<!--  background-color: #f2f2f2; /* 전체 배경 */-->
<!--  font-family: "Noto Sans KR", sans-serif;-->
<!--  margin: 16px;-->
<!--  /* 필요한 경우 max-width: 1200px; margin: 0 auto; 등으로 중앙 정렬 추가 가능 */-->
<!--}-->

<!--/* ─────────────────────────────────────────────────────────────────────────-->
<!--   1. 상단: 방송 제목 & 메타정보-->
<!--───────────────────────────────────────────────────────────────────────── */-->
<!--.header-bar {-->
<!--  display: grid;-->
<!--  grid-template-columns: 3fr 1fr 1fr 1fr; /* 첫 칸(제목)을 넓게, 나머지는 동일 폭 */-->
<!--  background-color: #fff;-->
<!--  border-bottom: 2px solid #444;-->
<!--  align-items: center;-->
<!--  height: 50px;      /* 상단 바 높이 */-->
<!--}-->

<!--.header-bar .title-cell {-->
<!--  padding-left: 12px;-->
<!--  font-size: 1.2rem;-->
<!--  font-weight: bold;-->
<!--  border-right: 2px solid #444;-->
<!--}-->

<!--.header-bar .meta-cell {-->
<!--  text-align: center;-->
<!--  font-weight: 500;-->
<!--  border-right: 2px solid #444;-->
<!--}-->

<!--.header-bar .meta-cell:last-child {-->
<!--  border-right: none; /* 마지막 칸 테두리 제거 */-->
<!--}-->

<!--/* ─────────────────────────────────────────────────────────────────────────-->
<!--   2. 본문: 왼쪽(영상+상품) / 오른쪽(공지+채팅)-->
<!--───────────────────────────────────────────────────────────────────────── */-->
<!--.main-content {-->
<!--  display: flex;-->
<!--  flex-direction: row;-->
<!--  height: 800px;-->
<!--  /* 높이를 지정하지 않으면 콘텐츠에 따라 늘어남 */-->
<!--}-->

<!--/* ─ Left Area */-->
<!--.left-area {-->
<!--  flex: 3;-->
<!--  display: flex;-->
<!--  flex-direction: column;-->
<!--  padding: 12px;-->
<!--}-->

<!--/* 2-1. 라이브 영상 화면 */-->
<!--.video-wrapper {-->
<!--  flex: 1;-->
<!--  border: 2px solid #888;-->
<!--  background-color: #ddd;-->
<!--  display: flex;-->
<!--  align-items: center;-->
<!--  justify-content: center;-->
<!--  margin-bottom: 12px;-->
<!--}-->

<!--.video-header {-->
<!--  font-size: 1.1rem;-->
<!--  font-weight: 600;-->
<!--}-->

<!--/* 2-2. 상품 목록 */-->
<!--.product-list {-->
<!--  display: flex;-->
<!--  flex-direction: row;-->
<!--  justify-content: space-between;-->
<!--}-->

<!--.product-card {-->
<!--  flex: 1;-->
<!--  border: 2px solid #555;-->
<!--  background-color: #fafafa;-->
<!--  margin-right: 12px;-->
<!--  display: flex;-->
<!--  flex-direction: column;-->
<!--  align-items: center;-->
<!--  padding: 8px;-->
<!--}-->

<!--.product-card:last-child {-->
<!--  margin-right: 0;-->
<!--}-->

<!--.product-title {-->
<!--  font-size: 1.1rem;-->
<!--  font-weight: bold;-->
<!--  margin-bottom: 8px;-->
<!--}-->

<!--.product-thumb {-->
<!--  width: 100%;-->
<!--  height: 80px; /* 썸네일 영역 높이 예시 */-->
<!--  background-color: #e0e0e0;-->
<!--  display: flex;-->
<!--  align-items: center;-->
<!--  justify-content: center;-->
<!--  margin-bottom: 8px;-->
<!--}-->

<!--.product-info {-->
<!--  font-size: 0.95rem;-->
<!--  color: #333;-->
<!--}-->

<!--/* ─ Right Area */-->
<!--.right-area {-->
<!--  flex: 1;-->
<!--  display: flex;-->
<!--  flex-direction: column;-->
<!--  padding: 12px;-->
<!--}-->

<!--/* 2-3. 공지 & FAQ 박스 */-->
<!--.notice-box {-->
<!--  flex: 1;-->
<!--  border: 2px solid #444;-->
<!--  border-radius: 8px;-->
<!--  background-color: #fff;-->
<!--  padding: 12px;-->
<!--  margin-bottom: 12px;-->
<!--  display: flex;-->
<!--  flex-direction: column;-->
<!--}-->

<!--.notice-header {-->
<!--  font-size: 1rem;-->
<!--  font-weight: bold;-->
<!--  margin-bottom: 8px;-->
<!--}-->

<!--.faq-list {-->
<!--  list-style: none;-->
<!--  padding-left: 0;-->
<!--  margin: 0;-->
<!--  font-size: 0.95rem;-->
<!--}-->

<!--.faq-list li {-->
<!--  margin-bottom: 6px;-->
<!--}-->

<!--/* 2-4. 채팅 입력창 부분 */-->
<!--.chat-input-area {-->
<!--  display: flex;-->
<!--  flex-direction: row;-->
<!--  align-items: center;-->
<!--}-->

<!--.chat-input {-->
<!--  flex: 1;-->
<!--  height: 40px;-->
<!--  border: 2px solid #888;-->
<!--  border-radius: 4px;-->
<!--  padding: 0 8px;-->
<!--  font-size: 0.95rem;-->
<!--}-->

<!--.chat-input::placeholder {-->
<!--  color: #999;-->
<!--}-->

<!--.send-button {-->
<!--  width: 80px;-->
<!--  height: 40px;-->
<!--  margin-left: 8px;-->
<!--  background-color: #6dc066;-->
<!--  border: none;-->
<!--  border-radius: 4px;-->
<!--  color: #fff;-->
<!--  font-weight: bold;-->
<!--  cursor: pointer;-->
<!--}-->

<!--/* send 버튼 호버 효과 */-->
<!--.send-button:hover {-->
<!--  background-color: #5bb354;-->
<!--}-->
<!--</style>-->

<!--
  LiveStreaming.vue
  소비자용 라이브 스트리밍 시청 컴포넌트

  OpenVidu 세션에 참여하여 호스트의 스트림을 구독하고 표시
  방송 정보, 상품 정보 등을 함께 표시

  스트림 구독 및 표시
   - OpenVidu 세션 참여
   - 입점업체 스트림 구독
   - UserVideo 컴포넌트를 통한 비디오 표시

 방송 정보 표시
    - 방송 제목
    - 상품 정보 (이름, 가격, 설명)
    - 구매 버튼

 [상태 관리]
 - OV: OpenVidu 인스턴스
 - session: 현재 연결된 세션
 - mainStreamManager: 메인 스트림 관리자 -> subscriber
 - streamData: 방송/상품 정보
 - loadingMessage: 로딩/에러 메시지

 [이벤트 핸들링]
 - streamCreated: 새 스트림 생성 시
 - streamDestroyed: 스트림 종료 시
 - sessionDisconnected: 세션 연결 해제 시
 - participantEvicted: 참가자 퇴장 시

-->
<template>
  <div class="viewer-container">
    <!-- 스트림 시청 영역: 세션과 스트림이 있을 때만 표시 -->
    <div class="stream-info" v-if="session && mainStreamManager">
      <!-- 방송 정보 헤더 -->
      <div class="stream-header">
        <h2>{{ streamData.title }}</h2>
        <!-- 상품 정보 표시 영역 -->
        <div class="products-container">
          <div v-for="item in streamData.products" :key="item.id" class="product-card">
            <h3>{{ item.name }}</h3>
            <strong>{{ item.discountedPrice.toLocaleString() }}원</strong>
            <small class="text-muted">(정가 {{ item.price.toLocaleString() }}원)</small>
            <button class="btn btn-primary">구매하기</button>
          </div>
        </div>
      </div>
      <!-- 비디오 스트림 표시 영역 -->
      <div class="video-container">
        <div class="main-video">
          <user-video :stream-manager="mainStreamManager"/>


        </div>
      </div>
    </div>
    <!-- 로딩/에러 메시지 표시 영역 -->
<!--    <div class="loading" v-else>-->
<!--      <p>{{ loadingMessage }}</p>-->
<!--    </div>-->
  </div>
</template>

<script setup>
import {onBeforeUnmount, onMounted, ref} from 'vue';
import {useRoute, useRouter} from 'vue-router';
import axios from 'axios';
import {OpenVidu} from 'openvidu-browser';
import UserVideo from '@/modules/live/components/UserVideo.vue';

// 라우터 설정
const route = useRoute();
const router = useRouter();
const APPLICATION_SERVER_URL = process.env.NODE_ENV === 'production' ? '' : 'http://localhost:8080/';

// OpenVidu 관련 상태 관리
const OV = ref(undefined);                 // OpenVidu 인스턴스
const session = ref(undefined);            // 현재 세션
const mainStreamManager = ref(undefined);  // 메인 스트림 관리자
const streamData = ref({});                // 방송/상품 정보
const loadingMessage = ref('방송에 연결 중입니다...'); // 상태 메시지

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
    //const sessionId = session.value.sessionId;
    console.log("sessionId: " + sessionId);
    await joinSession(sessionId);
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
});
</script>

<style scoped>
/* 컨테이너 스타일 */
.viewer-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

/* 방송 헤더 스타일 */
.stream-header {
  .stream-header {
    margin-bottom: 20px;
  }

  /* 상품 정보 스타일 */

  .products-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
    margin: 20px 0;
  }

  /* 상품 카드 스타일 */

  .product-card {
    background-color: #f8f9fa;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    transition: transform 0.2s;
  }

  .product-card:hover {
    transform: translateY(-5px);
  }

  .product-card h3 {
    margin: 0 0 10px 0;
    color: #333;
    font-size: 1.2em;
  }

  .product-card .price {
    font-size: 1.3em;
    color: #dc3545;
    font-weight: bold;
    margin: 10px 0;
  }

  .product-card .description {
    color: #666;
    margin: 10px 0;
    font-size: 0.9em;
  }

  .product-card .btn {
    width: 100%;
    margin-top: 10px;
  }

  /* 비디오 컨테이너 스타일 */

  .video-container {
    width: 100%;
    height: 0;
    padding-bottom: 56.25%; /* 16:9 비율 */
    position: relative;
    background-color: #000;
    margin: 20px auto;
    overflow: hidden;
  }

  /* 비디오 컴포넌트 스타일 */

  .video-container :deep(.stream-component) {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
  }

  /* 메인 비디오 스타일 */

  .main-video {
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
  }

  /* 버튼 스타일 */

  .btn {
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }

  .btn-primary {
    background-color: #007bff;
    color: white;
  }

  /* 로딩 메시지 스타일 */

  .loading {
    text-align: center;
    padding: 50px;
    font-size: 1.2em;
    color: #666;
  }
}
</style>