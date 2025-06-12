<!--
  비디오 세션 참가 및 관리
  실시간 스트리밍 비디오 처리
-->
<template>
  <navbar-one />
  <div class="live-stream-list">
    <div class="live-header">
      <h2>진행중인 방송</h2>
      <div class="live-header-buttons">
        <button class="live-btn">검색</button>
        <button class="live-btn">카테고리</button>
      </div>
    </div>

    <div class="live-stream-grid">
      <div v-for="stream in streams" :key="stream.id" class="live-stream-card" @click="goToStream(stream)">
        <div class="live-badge">Live</div>
        <div class="live-stream-content">
          <h3 class="live-stream-title">{{ stream.title }}</h3>
          <div class="live-stream-info">
            <p class="live-vendor-name">{{ stream.vendorName }}</p>
            <p class="live-broadcast-title">{{ stream.broadcastTitle }}</p>
          </div>
          <div class="live-stream-footer">
            <button class="live-category-btn">카테고리</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';
import NavbarOne from "@/components/navbar/navbar-one.vue";

const router = useRouter();
const streams = ref([
  // 테스트용 더미 데이터
  { id: 1, title: '썸네일1', vendorName: '입점업체1', broadcastTitle: '방송 제목1' },
  { id: 2, title: '썸네일2', vendorName: '입점업체2', broadcastTitle: '방송 제목2' },
  { id: 3, title: '썸네일3', vendorName: '입점업체3', broadcastTitle: '방송 제목3' },
  { id: 4, title: '썸네일4', vendorName: '입점업체4', broadcastTitle: '방송 제목4' },
  { id: 5, title: '썸네일5', vendorName: '입점업체5', broadcastTitle: '방송 제목5' },
  { id: 6, title: '썸네일6', vendorName: '입점업체6', broadcastTitle: '방송 제목6' },
]);

const fetchLiveStreams = async () => {
  try {
    const response = await axios.get('/api/live-streams', {
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json; charset=utf-8'
      }
    });
    
    if (response.data && Array.isArray(response.data)) {
      streams.value = response.data;
    } else {
      // 테스트용 더미 데이터로 초기화
      streams.value = [
        { id: 1, title: '썸네일1', vendorName: '입점업체1', broadcastTitle: '방송 제목1' },
        { id: 2, title: '썸네일2', vendorName: '입점업체2', broadcastTitle: '방송 제목2' },
        { id: 3, title: '썸네일3', vendorName: '입점업체3', broadcastTitle: '방송 제목3' },
        { id: 4, title: '썸네일4', vendorName: '입점업체4', broadcastTitle: '방송 제목4' },
        { id: 5, title: '썸네일5', vendorName: '입점업체5', broadcastTitle: '방송 제목5' },
        { id: 6, title: '썸네일6', vendorName: '입점업체6', broadcastTitle: '방송 제목6' }
      ];
    }
  } catch (error) {
    console.error('라이브 스트림 목록 조회 실패:', error);
    // 에러 시 테스트용 더미 데이터로 초기화
    streams.value = [
      { id: 1, title: '썸네일1', vendorName: '입점업체1', broadcastTitle: '방송 제목1' },
      { id: 2, title: '썸네일2', vendorName: '입점업체2', broadcastTitle: '방송 제목2' },
      { id: 3, title: '썸네일3', vendorName: '입점업체3', broadcastTitle: '방송 제목3' },
      { id: 4, title: '썸네일4', vendorName: '입점업체4', broadcastTitle: '방송 제목4' },
      { id: 5, title: '썸네일5', vendorName: '입점업체5', broadcastTitle: '방송 제목5' },
      { id: 6, title: '썸네일6', vendorName: '입점업체6', broadcastTitle: '방송 제목6' }
    ];
  }
};

const goToStream = (stream) => {
  router.push(`/view/${stream.id}`);
};

onMounted(() => {
   fetchLiveStreams(); // API 연동 시 주석 해제
});
</script>

<style scoped>
.live-stream-list {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.live-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.live-header h2 {
  margin: 0;
  font-weight: bold;
}

.live-header-buttons {
  display: flex;
  gap: 10px;
}

.live-btn {
  padding: 8px 16px;
  border: 1px solid #ddd;
  background: white;
  border-radius: 4px;
  cursor: pointer;
}

.live-btn:hover {
  background: #f8f9fa;
}

.live-stream-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.live-stream-card {
  border: 1px solid #ddd;
  border-radius: 12px;
  position: relative;
  background: white;
  height: 180px;
  cursor: pointer;
}

.live-badge {
  position: absolute;
  top: 10px;
  left: 10px;
  background-color: #ff0000;
  color: white;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 0.8em;
}

.live-stream-content {
  padding: 15px;
  display: flex;
  flex-direction: column;
  height: 100%;
}

.live-stream-title {
  font-size: 1.2em;
  margin-bottom: 10px;
  font-weight: bold;
}

.live-stream-info {
  flex-grow: 1;
}

.live-vendor-name {
  font-size: 0.9em;
  color: #666;
  margin: 5px 0;
}

.live-broadcast-title {
  font-size: 0.9em;
  color: #333;
  margin: 5px 0;
}

.live-stream-footer {
  display: flex;
  justify-content: flex-end;
}

.live-category-btn {
  padding: 8px 16px;
  background: #1a1a1a;
  border: none;
  color: white;
  border-radius: 4px;
  cursor: pointer;
}

.live-category-btn:hover {
  background: #333;
}

@media (max-width: 1024px) {
  .live-stream-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .live-stream-grid {
    grid-template-columns: 1fr;
  }
}
</style>
