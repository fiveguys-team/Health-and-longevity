<!--
  비디오 세션 참가 및 관리
  실시간 스트리밍 비디오 처리
-->
<template>
  <navbar-one/>
  <div class="live-stream-list">
    <div class="live-header">
      <h2>진행중인 방송</h2>
      <div class="live-header-buttons">
        <div class="live-search">
          <input type="text" v-model="searchQuery" placeholder="입점업체명 검색" class="live-search-input"/>
        </div>
        <div class="live-category-dropdown">
          <select v-model="selectedCategory" class="live-category-select">
            <option value="">전체 카테고리</option>
            <option v-for="category in categories" :key="category" :value="category">
              {{ category }}
            </option>
          </select>
        </div>
      </div>
    </div>

    <div class="live-stream-grid">
      <div v-for="stream in filteredStreams" :key="stream.id" class="live-stream-card"
           @click="goToStream(stream)">
        <div class="live-badge">Live</div>
        <div class="live-stream-content">
          <div class="live-stream-thumbnail">
            <img :src="stream.thumbnail" :alt="stream.thumbnail" />
          </div>

          <div class="live-stream-footer">
            <div class="live-stream-info">
              <p class="live-vendor-name">{{ stream.vendorName }}</p>
              <p class="live-broadcast-title">{{ stream.broadcastTitle }}</p>
            </div>
            <div>{{ stream.category }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import {ref, onMounted, computed} from 'vue';
import {useRouter} from 'vue-router';
import axios from 'axios';
import NavbarOne from "@/components/navbar/navbar-one.vue";

const router = useRouter();
const searchQuery = ref('');
const selectedCategory = ref('');

const categories = [
  '혈압',
  '눈',
  '뼈,관절,연골',
  '장건강',
  '영양보충'
];

const streams = ref([
  // 테스트용 더미 데이터에 카테고리 추가
  {id: 1, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체1', broadcastTitle: '방송 제목1', category: '혈압'},
  {id: 2, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체2', broadcastTitle: '방송 제목2', category: '눈'},
  {id: 3, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체3', broadcastTitle: '방송 제목3', category: '뼈,관절,연골'},
  {id: 4, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체4', broadcastTitle: '방송 제목4', category: '장건강'},
  {id: 5, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체5', broadcastTitle: '방송 제목5', category: '영양보충'},
  {id: 6, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체6', broadcastTitle: '방송 제목6', category: '혈압'},
]);

// 검색어와 카테고리로 필터링하는 computed 속성
const filteredStreams = computed(() => {
  return streams.value.filter(stream => {
    const matchesSearch = !searchQuery.value ||
        stream.vendorName.toLowerCase().includes(searchQuery.value.toLowerCase());
    const matchesCategory = !selectedCategory.value ||
        stream.category === selectedCategory.value;
    return matchesSearch && matchesCategory;
  });
});

const fetchLiveStreams = async () => {
  try {
    const response = await axios.get('/api/sessions', {
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
        {id: 1, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체1', broadcastTitle: '방송 제목1', category: '혈압'},
        {id: 2, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체2', broadcastTitle: '방송 제목2', category: '눈'},
        {id: 3, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체3', broadcastTitle: '방송 제목3', category: '뼈,관절,연골'},
        {id: 4, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체4', broadcastTitle: '방송 제목4', category: '장건강'},
        {id: 5, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체5', broadcastTitle: '방송 제목5', category: '영양보충'},
        {id: 6, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체6', broadcastTitle: '방송 제목6', category: '혈압'}
      ];
    }
  } catch (error) {
    console.error('라이브 스트림 목록 조회 실패:', error);
    // 에러 시 테스트용 더미 데이터로 초기화
    streams.value = [
      {id: 1, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체1', broadcastTitle: '방송 제목1', category: '혈압'},
      {id: 2, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체2', broadcastTitle: '방송 제목2', category: '눈'},
      {
        id: 3,
        thumbnail: 'https://via.placeholder.com/400x300',
        vendorName: '입점업체3',
        broadcastTitle: '방송 제목3',
        category: '뼈,관절,연골'
      },
      {id: 4, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체4', broadcastTitle: '방송 제목4', category: '장건강'},
      {id: 5, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체5', broadcastTitle: '방송 제목5', category: '영양보충'},
      {id: 6, thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체6', broadcastTitle: '방송 제목6', category: '혈압'}
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
  margin-bottom: 120px;
  padding-bottom: 20px;
  border-bottom: 1px solid #ddd;
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
  gap: 30px;
}

.live-stream-card {
  border: 1px solid #ddd;
  border-radius: 12px;
  position: relative;
  background: white;
  height: 200px;
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

.live-stream-thumbnail {
  width: 100%;
  height: 200px;
  overflow: hidden;
  border-radius: 8px;
  margin-bottom: 12px;
}

.live-stream-thumbnail img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.live-stream-card:hover .live-stream-thumbnail img {
  transform: scale(1.05);
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

.live-search {
  display: flex;
  align-items: center;
}

.live-search-input {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 14px;
  width: 200px;
  outline: none;
}

.live-search-input:focus {
  border-color: #666;
}

.live-category-dropdown {
  margin-left: 10px;
}

.live-category-select {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 14px;
  background-color: white;
  cursor: pointer;
  outline: none;
}

.live-category-select:focus {
  border-color: #666;
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
