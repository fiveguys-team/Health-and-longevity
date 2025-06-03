<script setup>
import { onMounted } from 'vue';


import NavbarOne from '@/components/navbar/navbar-one.vue';
// import FooterOne from '@/components/footer/footer-one.vue';
// import FooterThree from '@/components/footer/footer-three.vue';
import ScrollToTop from '@/components/scroll-to-top.vue';

import 'swiper/swiper-bundle.css';

import LiveScreen from '@/modules/live/components/LiveScreen.vue';

import Aos from 'aos';
import 'aos/dist/aos.css';

onMounted(() => {
  Aos.init()
});
</script>

<template>
  <div>
    <NavbarOne />

    <div class="live-container">
      <!-- 상단: 방송 제목 & 메타정보 -->
      <div class="header-bar">
        <div class="title-cell">방송 제목</div>
        <div class="meta-cell">참여자 수</div>
        <div class="meta-cell">방송 경과 시간</div>
        <div class="meta-cell">방송 종료 시간</div>
      </div>

      <!-- 본문 영역: 왼쪽(영상 + 상품) / 오른쪽(공지 및 채팅) -->
      <div class="main-content">
        <!-- 왼쪽 영역 -->
        <div class="left-area">
          <!-- 라이브 영상 화면 -->
          <div class="video-wrapper">
            <LiveScreen />
            <!-- <div class="video-header">📺 [라이브 영상 화면 (OpenVidu)]</div> -->
          </div>
          <!-- 상품 목록 -->
          <div class="product-list">
            <div class="product-card">
              <div class="product-title">상품 A</div>
              <div class="product-thumb">사진</div>
              <div class="product-info">제품명, 가격</div>
            </div>
            <div class="product-card">
              <div class="product-title">상품 B</div>
              <div class="product-thumb">사진</div>
              <div class="product-info">제품명, 가격</div>
            </div>
            <div class="product-card">
              <div class="product-title">상품 C</div>
              <div class="product-thumb">사진</div>
              <div class="product-info">제품명, 가격</div>
            </div>
          </div>
        </div>

        <!-- 오른쪽 영역 채팅 -->
        <div class="right-area">
          <!-- 공지 & FAQ -->
          <div class="notice-box">
            <div class="notice-header">
              📢 오늘 방송 중 루테인 10% 할인 + 선착순 50명 무료배송!
            </div>
            <ul class="faq-list">
              <li>[유저1] 루테인 복용 방법은 어떻게 되나요?</li>
              <li>[유저2] 무료배송 이벤트는 언제까지인가요?</li>
              <li>[유저3] 무료배송 이벤트는 언제까지인가요?</li>
              <li>…</li>
            </ul>
          </div>

          <!-- 채팅 입력창 -->
          <div class="chat-input-area">
            <input type="text" class="chat-input" placeholder="[채팅 입력창]" />
            <button class="send-button">SEND</button>
          </div>
        </div>
      </div>
    </div>

    <!-- <FooterThree /> -->

    <ScrollToTop />

  </div>
</template>

<style scoped>
/* ─────────────────────────────────────────────────────────────────────────
   전체 컨테이너
───────────────────────────────────────────────────────────────────────── */
.live-container {
  display: flex;
  flex-direction: column;
  border: 2px solid #444;    /* 전체 테두리 색상 */
  background-color: #f2f2f2; /* 전체 배경 */
  font-family: "Noto Sans KR", sans-serif;
  margin: 16px;
  /* 필요한 경우 max-width: 1200px; margin: 0 auto; 등으로 중앙 정렬 추가 가능 */
}

/* ─────────────────────────────────────────────────────────────────────────
   1. 상단: 방송 제목 & 메타정보
───────────────────────────────────────────────────────────────────────── */
.header-bar {
  display: grid;
  grid-template-columns: 3fr 1fr 1fr 1fr; /* 첫 칸(제목)을 넓게, 나머지는 동일 폭 */
  background-color: #fff;
  border-bottom: 2px solid #444;
  align-items: center;
  height: 50px;      /* 상단 바 높이 */
}

.header-bar .title-cell {
  padding-left: 12px;
  font-size: 1.2rem;
  font-weight: bold;
  border-right: 2px solid #444;
}

.header-bar .meta-cell {
  text-align: center;
  font-weight: 500;
  border-right: 2px solid #444;
}

.header-bar .meta-cell:last-child {
  border-right: none; /* 마지막 칸 테두리 제거 */
}

/* ─────────────────────────────────────────────────────────────────────────
   2. 본문: 왼쪽(영상+상품) / 오른쪽(공지+채팅)
───────────────────────────────────────────────────────────────────────── */
.main-content {
  display: flex;
  flex-direction: row;
  height: 800px;
  /* 높이를 지정하지 않으면 콘텐츠에 따라 늘어남 */
}

/* ─ Left Area */
.left-area {
  flex: 3;
  display: flex;
  flex-direction: column;
  padding: 12px;
}

/* 2-1. 라이브 영상 화면 */
.video-wrapper {
  flex: 1;
  border: 2px solid #888;
  background-color: #ddd;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 12px;
}

.video-header {
  font-size: 1.1rem;
  font-weight: 600;
}

/* 2-2. 상품 목록 */
.product-list {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
}

.product-card {
  flex: 1;
  border: 2px solid #555;
  background-color: #fafafa;
  margin-right: 12px;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 8px;
}

.product-card:last-child {
  margin-right: 0;
}

.product-title {
  font-size: 1.1rem;
  font-weight: bold;
  margin-bottom: 8px;
}

.product-thumb {
  width: 100%;
  height: 80px; /* 썸네일 영역 높이 예시 */
  background-color: #e0e0e0;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 8px;
}

.product-info {
  font-size: 0.95rem;
  color: #333;
}

/* ─ Right Area */
.right-area {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 12px;
}

/* 2-3. 공지 & FAQ 박스 */
.notice-box {
  flex: 1;
  border: 2px solid #444;
  border-radius: 8px;
  background-color: #fff;
  padding: 12px;
  margin-bottom: 12px;
  display: flex;
  flex-direction: column;
}

.notice-header {
  font-size: 1rem;
  font-weight: bold;
  margin-bottom: 8px;
}

.faq-list {
  list-style: none;
  padding-left: 0;
  margin: 0;
  font-size: 0.95rem;
}

.faq-list li {
  margin-bottom: 6px;
}

/* 2-4. 채팅 입력창 부분 */
.chat-input-area {
  display: flex;
  flex-direction: row;
  align-items: center;
}

.chat-input {
  flex: 1;
  height: 40px;
  border: 2px solid #888;
  border-radius: 4px;
  padding: 0 8px;
  font-size: 0.95rem;
}

.chat-input::placeholder {
  color: #999;
}

.send-button {
  width: 80px;
  height: 40px;
  margin-left: 8px;
  background-color: #6dc066;
  border: none;
  border-radius: 4px;
  color: #fff;
  font-weight: bold;
  cursor: pointer;
}

/* send 버튼 호버 효과 */
.send-button:hover {
  background-color: #5bb354;
}
</style>