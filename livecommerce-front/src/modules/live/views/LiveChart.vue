<!--
  비디오 세션 참가 및 관리
  실시간 스트리밍 비디오 처리
-->
<template>
  <div class="home-container">
    <header class="header">
      <h1>라이브 커머스</h1>
    </header>

    <div class="streams-container">
      <h2>진행 중인 방송</h2>
      <div class="stream-grid">
        <div v-for="session in sessions" :key="session.sessionId" class="stream-card">
          <div class="stream-thumbnail">
            <!-- 실제로는 방송 썸네일 이미지가 들어갈 자리 -->
            <div class="placeholder-thumbnail"></div>
            <span class="live-badge">LIVE</span>
          </div>
          <div class="stream-info">
            <h3>{{ session.title }}</h3>
            <router-link :to="{ name: 'viewer', params: { sessionId: session.sessionId }}" class="btn btn-secondary">
              시청하기
            </router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';

const APPLICATION_SERVER_URL = process.env.NODE_ENV === 'production' ? '' : 'http://localhost:8080/';
const sessions = ref([]);
/**
 * 현재 라이브 방송 중인 session 배열 가져오는 함수
 * @returns {Promise<void>}
 * @constructor
 */
const ActiveSessions = async () => {
  try {
    const response = await axios.get(APPLICATION_SERVER_URL + 'api/sessions');
    sessions.value = response.data;
    console.log(sessions.value);
  } catch (error) {
    console.error('방송 목록 조회 중 오류 발생:', error);
  }
};

onMounted(() => {
  ActiveSessions();
});
</script>

<style scoped>
.home-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.btn {
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  text-decoration: none;
}

.btn-primary {
  background-color: #007bff;
  color: white;
}

.btn-secondary {
  background-color: #6c757d;
  color: white;
}

.streams-container {
  margin-top: 20px;
}

.stream-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

.stream-card {
  border: 1px solid #ddd;
  border-radius: 8px;
  overflow: hidden;
  transition: transform 0.2s;
}

.stream-card:hover {
  transform: translateY(-5px);
}

.stream-thumbnail {
  position: relative;
  width: 100%;
  padding-top: 56.25%; /* 16:9 비율 */
  background-color: #000;
}

.placeholder-thumbnail {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: #343a40;
}

.live-badge {
  position: absolute;
  top: 10px;
  left: 10px;
  background-color: #dc3545;
  color: white;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.8em;
  font-weight: bold;
}

.stream-info {
  padding: 15px;
}

.stream-info h3 {
  margin: 0 0 10px 0;
  font-size: 1.1em;
}
</style>
