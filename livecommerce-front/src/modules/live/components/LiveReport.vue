<template>
  <div class="statistics">
    <!-- 헤더: 제목 + 날짜 검색 -->
    <div class="statistics-header">
      <h1>통계 자료</h1>
      <div class="search-container">
        <input
            v-model="searchDate"
            type="text"
            placeholder="날짜 검색 (YYYY-MM-DD)"
            class="search-input"
            @input="validateDate"
        />
        <span v-if="dateError" class="error-message">{{ dateError }}</span>
      </div>
    </div>

    <!-- 로딩 상태 표시 -->
    <div v-if="loading" class="loading-overlay">
      <div class="loading-spinner"></div>
      <span>데이터를 불러오는 중...</span>
    </div>

    <!-- 에러 메시지 -->
    <div v-if="error" class="error-banner">
      {{ error }}
      <button @click="getReportList" class="retry-button">다시 시도</button>
    </div>

    <!-- 카드들을 감싸는 컨테이너 -->
    <div v-else class="cards-container">
      <div
          v-for="item in paginatedreports"
          :key="item.liveDashboardId"
          class="card"
          @click="selectItem(item)"
          :class="{ 
            'card--active': selectedItem && selectedItem.liveDashboardId === item.liveDashboardId,
            'card--hover': !selectedItem || selectedItem.liveDashboardId !== item.liveDashboardId
          }"
      >
        <div class="card-title">{{ item.title }}</div>
        <div class="card-date">{{ formatDate(item.streamDate) }}</div>
      </div>
    </div>

    <!-- 페이지네이션 -->
    <div v-if="totalPages > 1" class="pagination">
      <button @click="prevPage" :disabled="currentPage === 1" class="page-button">이전</button>
      <span class="page-info">페이지 {{ currentPage }} / {{ totalPages }}</span>
      <button @click="nextPage" :disabled="currentPage === totalPages" class="page-button">다음</button>
    </div>

    <!-- 선택된 방송 통계 정보 표시 영역 -->
    <div class="details" v-if="selectedItem">
      <h2>{{ selectedItem.title }} 통계 자료</h2>
      <div class="detail-content">
        <!-- 왼쪽 통계 카드 그룹 -->
        <div class="stats-cards">
          <div class="stats-card-small">
            <div class="small-title">총 시청자 수</div>
            <div class="small-value">{{ formatNumber(selectedItem.totalViewers) }}명</div>
          </div>
          <div class="stats-card-small">
            <div class="small-title">최고 동시 시청자 수</div>
            <div class="small-value">{{ formatNumber(selectedItem.maxConcurrentViewers) }}명</div>
          </div>
          <div class="stats-card-small">
            <div class="small-title">평균 시청 시간</div>
            <div class="small-value">{{ formatDuration(selectedItem.averageWatchDuration) }}</div>
          </div>
          <div class="stats-card-small">
            <div class="small-title">총 채팅 수</div>
            <div class="small-value">{{ formatNumber(selectedItem.purchaseRatio) }}개</div>
          </div>
          <div class="stats-card-small">
            <div class="small-title">주문 건 수</div>
            <div class="small-value">{{ formatNumber(selectedItem.totalOrders) }}건</div>
          </div>
          <div class="stats-card-small">
            <div class="small-title">총 매출액</div>
            <div class="small-value">{{ formatCurrency(selectedItem.totalReve) }}원</div>
          </div>
        </div>
        <!-- 오른쪽 AI 분석 영역 -->
        <div class="ai-analysis">
          <div class="ai-box">
            <h3>AI 분석 자료</h3>
            <p>방송 데이터를 AI로 분석하여 인사이트를 제공합니다.</p>
          </div>
          <button 
            class="ai-button" 
            @click="analyzeData"
            :disabled="analyzing"
          >
            {{ analyzing ? '분석 중...' : 'AI 분석 시작' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import {ref, computed, onBeforeMount} from 'vue'
import {useRoute} from "vue-router";
import axios from "axios";

const route = useRoute();
const APPLICATION_SERVER_URL = process.env.NODE_ENV === 'production' ? '' : 'http://localhost:8080/';
const vendorId = route.params.vendorId;

// 상태 관리
const searchDate = ref('')
const dateError = ref('')
const reports = ref([])
const selectedItem = ref(null)
const loading = ref(false)
const error = ref('')
const analyzing = ref(false)

// 날짜 검증
const validateDate = () => {
  const dateRegex = /^\d{4}-\d{2}-\d{2}$/
  if (searchDate.value && !dateRegex.test(searchDate.value)) {
    dateError.value = 'YYYY-MM-DD 형식으로 입력해주세요'
  } else {
    dateError.value = ''
  }
}

// 데이터 포맷팅 함수들
const formatNumber = (num) => {
  return new Intl.NumberFormat('ko-KR').format(num)
}

const formatCurrency = (amount) => {
  return new Intl.NumberFormat('ko-KR').format(amount)
}

const formatDuration = (seconds) => {
  const hours = Math.floor(seconds / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  const remainingSeconds = seconds % 60
  return `${hours}시간 ${minutes}분 ${remainingSeconds}초`
}

const formatDate = (dateStr) => {
  const date = new Date(dateStr)
  return date.toLocaleDateString('ko-KR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// 레포트 가져오기
const getReportList = async () => {
  loading.value = true
  error.value = ''
  try {
    const response = await axios.get(
      `${APPLICATION_SERVER_URL}api/sessions/${vendorId}/report`,
      {headers: {'Content-Type': 'application/json'}}
    )
    reports.value = response.data
  } catch (err) {
    error.value = '데이터를 불러오는데 실패했습니다. 다시 시도해주세요.'
    console.error('Report fetch failed:', err)
  } finally {
    loading.value = false
  }
}

// AI 분석
const analyzeData = async () => {
  if (!selectedItem.value) return
  
  analyzing.value = true
  try {
    // TODO: AI 분석 API 연동
    await new Promise(resolve => setTimeout(resolve, 2000)) // 임시 딜레이
    alert('AI 분석이 완료되었습니다.')
  } catch (err) {
    alert('AI 분석 중 오류가 발생했습니다.')
    console.error('AI analysis failed:', err)
  } finally {
    analyzing.value = false
  }
}

function selectItem(item) {
  selectedItem.value = item
}

const filteredreports = computed(() => {
  if (!searchDate.value) return reports.value
  
  return reports.value.filter(item => {
    const itemDate = new Date(item.streamDate).toISOString().split('T')[0]
    return itemDate.includes(searchDate.value)
  })
})

// 페이징
const currentPage = ref(1)
const pageSize = 9
const totalPages = computed(() => Math.ceil(filteredreports.value.length / pageSize))

const paginatedreports = computed(() => {
  const start = (currentPage.value - 1) * pageSize
  return filteredreports.value.slice(start, start + pageSize)
})

function nextPage() {
  if (currentPage.value < totalPages.value) currentPage.value++
}
function prevPage() {
  if (currentPage.value > 1) currentPage.value--
}

onBeforeMount(() => {
  getReportList();
})

</script>

<style scoped>
.statistics {
  padding: 50px;
  font-family: 'Noto Sans KR', sans-serif;
  margin: 70px 200px;
  background-color: #fefefe;
  border-radius: 10px;
}

.statistics-header {
  display: flex;
  justify-content: space-between;
  align-reports: center;
  margin-bottom: 16px;
}

.statistics-header h1 {
  font-size: 2.8rem;
  color: #2c3e50;
  font-weight: 700;
  margin: 0;
  text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
}

.search-container {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.search-input {
  width: 100%;
  max-width: 300px;
  padding: 8px 12px;
  border: 1px solid #ccc;
  border-radius: 10px;
  font-size: 1rem;
}

.error-message {
  color: #dc3545;
  font-size: 0.875rem;
}

.cards-container {
  border: 1px solid #ccc;
  padding: 32px;
  border-radius: 10px;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 32px;
  margin-bottom: 16px;
  min-height: 240px;
  background: #fafafa;
}

.card {
  background: #fff;
  padding: 16px;
  border: 1px solid #ddd;
  border-radius: 10px;
  box-shadow: 2px 2px 6px rgba(0,0,0,0.1);
  cursor: pointer;
  transition: transform 0.1s;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.card--active { background: #eef2ff; border-color: #4f46e5; }
.card:hover { transform: translateY(-2px); }
.card-title { font-size: 1.25rem; font-weight: 600; }
.card-date { text-align: right; color: #777; }

.pagination {
  display: flex;
  justify-content: center;
  align-reports: center;
  gap: 12px;
  margin-bottom: 24px;
}

.pagination button {
  padding: 6px 12px;
  border: 1px solid #ccc;
  background: white;
  border-radius: 4px;
  cursor: pointer;
}

.pagination button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.details {
  background: #fff;
  padding: 16px;
  border: 1px solid #ddd;
  border-radius: 10px;
  box-shadow: 2px 2px 6px rgba(0,0,0,0.05);
  margin-top: 16px;
}

.details h2 {
  font-size: 2rem;
  color: #34495e;
  font-weight: 600;
  margin-bottom: 24px;
  border-bottom: 2px solid #ecf0f1;
  padding-bottom: 8px;
}

.detail-content { display: flex; gap: 24px; }
.stats-cards {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-template-rows: repeat(3, auto);
  gap: 16px;
  width: 60%;
}
.stats-card-small { background: #f9f9f9; border: 1px solid #ddd; border-radius: 6px; padding: 12px; text-align: center; }
.small-title { font-size: 0.9rem; margin-bottom: 8px; color: #333; }
.small-value { font-size: 1.1rem; font-weight: 700; color: #111; }
.ai-analysis { display: flex; flex-direction: column; align-reports: center; justify-content: space-between; width: 40%; }
.ai-box { flex: 1; background: #f5f5f5; border: 1px dashed #ccc; border-radius: 6px; width: 100%; display: flex; align-reports: center; justify-content: center; font-size: 1.2rem; color: #666; }
.ai-button { margin-top: 16px; padding: 8px 16px; border: none; border-radius: 4px; background: #4f46e5; color: white; cursor: pointer; font-size: 1rem; }
.ai-button:hover { background: #4338ca; }

.loading-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 255, 255, 0.9);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;
  z-index: 1000;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error-banner {
  background: #fee2e2;
  color: #dc2626;
  padding: 12px 16px;
  border-radius: 8px;
  margin-bottom: 16px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.retry-button {
  background: #dc2626;
  color: white;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  cursor: pointer;
}

.retry-button:hover {
  background: #b91c1c;
}

.card--hover:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

.page-button {
  background: #4f46e5;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.2s;
}

.page-button:hover:not(:disabled) {
  background: #4338ca;
}

.page-button:disabled {
  background: #9ca3af;
  cursor: not-allowed;
}

.page-info {
  font-weight: 500;
  color: #4b5563;
}

.ai-box {
  background: #f8fafc;
  padding: 20px;
  border-radius: 8px;
  border: 1px solid #e2e8f0;
}

.ai-box h3 {
  color: #1e293b;
  margin-bottom: 8px;
}

.ai-box p {
  color: #64748b;
  font-size: 0.875rem;
}

.ai-button {
  width: 100%;
  padding: 12px;
  background: #4f46e5;
  color: white;
  border: none;
  border-radius: 6px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  margin-top: 16px;
}

.ai-button:hover:not(:disabled) {
  background: #4338ca;
  transform: translateY(-1px);
}

.ai-button:disabled {
  background: #9ca3af;
  cursor: not-allowed;
}
</style>
