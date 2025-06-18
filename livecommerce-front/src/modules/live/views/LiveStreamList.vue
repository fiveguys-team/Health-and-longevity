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
      <div v-for="stream in displayedStreams" :key="stream.sessionId" class="live-stream-card"
           @click="goToStream(stream)">
        <div class="live-badge">Live</div>
        <div class="live-stream-content">
          <div class="live-stream-thumbnail">
            <img :src="stream.thumbnail" :alt="stream.thumbnail" />
          </div>

          <div class="live-stream-footer">
            <div class="live-stream-info">
              <h2 class="live-vendor-name">{{ stream.vendorName }}</h2>
              <p class="live-broadcast-title">{{ stream.title }}</p>
            </div>
            <div class="live-vendor-category">{{ stream.category }}</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 무한 스크롤 로딩 인디케이터 -->
    <div v-if="loading" class="loading-indicator">
      <div class="loading-spinner"></div>
      <span>더 많은 방송을 불러오는 중...</span>
    </div>

    <!-- 무한 스크롤 트리거 요소 -->
    <div ref="scrollTrigger" class="scroll-trigger"></div>
  </div>
</template>

<script setup>
import {ref, onMounted, computed, watch, nextTick, onBeforeUnmount} from 'vue';
import {useRouter} from 'vue-router';
import axios from 'axios';
import NavbarOne from "@/components/navbar/navbar-one.vue";

const APPLICATION_SERVER_URL = process.env.NODE_ENV === 'production' ? ''
    : 'http://localhost:8080/';

const router = useRouter();
const searchQuery = ref('');
const selectedCategory = ref('');

const categories = [
  '혈압',
  '눈',
  '뼈/관절/연골',
  '장건강',
  '영양보충'
];

const streams = ref([]);
const loading = ref(false);
const hasMore = ref(true);
const page = ref(1);
const pageSize = 9; // 한 번에 로드할 아이템 수
const scrollTrigger = ref(null);

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

// 현재 페이지까지의 스트림만 표시
const displayedStreams = computed(() => {
  return filteredStreams.value.slice(0, page.value * pageSize);
});

// 더 많은 데이터가 있는지 확인
const checkHasMore = () => {
  hasMore.value = filteredStreams.value.length > page.value * pageSize;
};

// 무한 스크롤 관찰자 설정
const setupIntersectionObserver = () => {
  if (!scrollTrigger.value) return;

  const observer = new IntersectionObserver(
    (entries) => {
      const entry = entries[0];
      if (entry.isIntersecting && hasMore.value && !loading.value) {
        loadMore();
      }
    },
    {
      rootMargin: '100px', // 100px 전에 로드 시작
      threshold: 0.1
    }
  );

  observer.observe(scrollTrigger.value);
  return observer;
};

// 더 많은 데이터 로드
const loadMore = async () => {
  if (loading.value || !hasMore.value) return;

  loading.value = true;
  
  // 실제 API에서는 여기서 페이지네이션 요청을 보냄
  // 현재는 더미 데이터를 사용하므로 시뮬레이션
  await new Promise(resolve => setTimeout(resolve, 1000));
  
  page.value++;
  checkHasMore();
  loading.value = false;
};

const fetchLiveStreams = async () => {
  try {
    const response = await axios.get(`${APPLICATION_SERVER_URL}api/sessions`, {
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json; charset=utf-8'
      }
    });

    if (response.data && Array.isArray(response.data)) {
      streams.value = response.data;
      console.log(streams.value);
    } else {
      // 테스트용 더미 데이터로 초기화 (더 많은 데이터 추가)
      streams.value = [
        {sessionId: '1', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체1', title: '방송 제목1', category: '혈압'},
        {sessionId: '2', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체2', title: '방송 제목2', category: '눈'},
        {sessionId: '3', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체3', title: '방송 제목3', category: '뼈/관절/연골'},
        {sessionId: '4', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체4', title: '방송 제목4', category: '장건강'},
        {sessionId: '5', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체5', title: '방송 제목5', category: '영양보충'},
        {sessionId: '6', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체6', title: '방송 제목6', category: '혈압'},
        {sessionId: '7', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체7', title: '방송 제목7', category: '눈'},
        {sessionId: '8', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체8', title: '방송 제목8', category: '뼈/관절/연골'},
        {sessionId: '9', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체9', title: '방송 제목9', category: '장건강'},
        {sessionId: '10', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체10', title: '방송 제목10', category: '영양보충'},
        {sessionId: '11', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체11', title: '방송 제목11', category: '혈압'},
        {sessionId: '12', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체12', title: '방송 제목12', category: '눈'},
        {sessionId: '13', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체13', title: '방송 제목13', category: '뼈/관절/연골'},
        {sessionId: '14', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체14', title: '방송 제목14', category: '장건강'},
        {sessionId: '15', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체15', title: '방송 제목15', category: '영양보충'},
        {sessionId: '16', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체16', title: '방송 제목16', category: '혈압'},
        {sessionId: '17', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체17', title: '방송 제목17', category: '눈'},
        {sessionId: '18', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체18', title: '방송 제목18', category: '뼈/관절/연골'},
        {sessionId: '19', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체19', title: '방송 제목19', category: '장건강'},
        {sessionId: '20', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체20', title: '방송 제목20', category: '영양보충'}
      ];
    }
  } catch (error) {
    console.error('라이브 스트림 목록 조회 실패:', error);
    // 에러 시 테스트용 더미 데이터로 초기화
    streams.value = [
      {sessionId: '1', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체1', title: '방송 제목1', category: '혈압'},
      {sessionId: '2', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체2', title: '방송 제목2', category: '눈'},
      {sessionId: '3', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체3', title: '방송 제목3', category: '뼈/관절/연골'},
      {sessionId: '4', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체4', title: '방송 제목4', category: '장건강'},
      {sessionId: '5', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체5', title: '방송 제목5', category: '영양보충'},
      {sessionId: '6', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체6', title: '방송 제목6', category: '혈압'},
      {sessionId: '7', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체7', title: '방송 제목7', category: '눈'},
      {sessionId: '8', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체8', title: '방송 제목8', category: '뼈/관절/연골'},
      {sessionId: '9', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체9', title: '방송 제목9', category: '장건강'},
      {sessionId: '10', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체10', title: '방송 제목10', category: '영양보충'},
      {sessionId: '11', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체11', title: '방송 제목11', category: '혈압'},
      {sessionId: '12', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체12', title: '방송 제목12', category: '눈'},
      {sessionId: '13', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체13', title: '방송 제목13', category: '뼈/관절/연골'},
      {sessionId: '14', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체14', title: '방송 제목14', category: '장건강'},
      {sessionId: '15', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체15', title: '방송 제목15', category: '영양보충'},
      {sessionId: '16', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체16', title: '방송 제목16', category: '혈압'},
      {sessionId: '17', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체17', title: '방송 제목17', category: '눈'},
      {sessionId: '18', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체18', title: '방송 제목18', category: '뼈/관절/연골'},
      {sessionId: '19', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체19', title: '방송 제목19', category: '장건강'},
      {sessionId: '20', thumbnail: 'https://via.placeholder.com/400x300', vendorName: '입점업체20', title: '방송 제목20', category: '영양보충'}
    ];
  } finally {
    checkHasMore();
  }
};

const goToStream = (stream) => {
  router.push(`/view/${stream.sessionId}`);
};

// 검색어나 카테고리가 변경될 때 페이지 초기화
watch([searchQuery, selectedCategory], () => {
  page.value = 1;
  checkHasMore();
});

let observer = null;

onMounted(async () => {
  await fetchLiveStreams();
  
  // DOM이 렌더링된 후 intersection observer 설정
  await nextTick();
  observer = setupIntersectionObserver();
});

// 컴포넌트 언마운트 시 observer 정리
onBeforeUnmount(() => {
  if (observer) {
    observer.disconnect();
  }
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
  margin-bottom: 40px;
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
  font-size: 1.5em;
  color: black;
  margin: 5px 0;
}

.live-broadcast-title {
  font-size: 0.9em;
  color: #333;
  margin: 5px 0;
}

.live-vendor-category {
  display: flex;
  justify-content: center;
  align-items: center;
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

/* 무한 스크롤 관련 스타일 */
.loading-indicator {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px;
  color: #666;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 16px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.scroll-trigger {
  height: 20px;
  width: 100%;
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
