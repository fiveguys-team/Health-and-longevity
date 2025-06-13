<template>
  <div class="statistics">
    <!-- 헤더: 제목 + 날짜 검색 -->
    <div class="statistics-header">
      <h1>통계 자료</h1>
      <input v-model="searchDate" type="text" placeholder="날짜 검색 (YYYY-MM-DD)" />
    </div>

    <!-- 카드들을 감싸는 컨테이너 -->
    <div class="cards-container">
      <div
          v-for="item in filteredItems"
          :key="item.id"
          class="card"
          @click="selectItem(item)"
          :class="{ 'card--active': selectedItem && selectedItem.id === item.id }"
      >
        <div class="card-title">{{ item.title }}</div>
        <div class="card-date">{{ item.date }}</div>
      </div>
    </div>

    <!-- 선택된 방송 통계 정보 표시 영역 -->
    <div class="details" v-if="selectedItem">
      <h2>{{ selectedItem.title }} 통계 자료</h2>
      <div class="detail-content">
        <!-- 왼쪽 통계 카드 그룹 -->
        <div class="stats-cards">
          <div class="stats-card-small">
            <div class="small-title">총 시청자 수</div>
            <div class="small-value">{{ selectedItem.stats.viewers }}</div>
          </div>
          <div class="stats-card-small">
            <div class="small-title">방송 시간</div>
            <div class="small-value">{{ selectedItem.stats.duration }}</div>
          </div>
          <div class="stats-card-small">
            <div class="small-title">채팅 수</div>
            <div class="small-value">{{ selectedItem.stats.chats }}</div>
          </div>
          <div class="stats-card-small">
            <div class="small-title">주문 건수</div>
            <div class="small-value">{{ selectedItem.stats.orders }}</div>
          </div>
          <div class="stats-card-small">
            <div class="small-title">총 매출액</div>
            <div class="small-value">{{ selectedItem.stats.sales }}</div>
          </div>
          <div class="stats-card-small">
            <div class="small-title">시청자 대비 구매자 비율</div>
            <div class="small-value">{{ selectedItem.stats.conversionRate }}</div>
          </div>
        </div>
        <!-- 오른쪽 AI 분석 영역 -->
        <div class="ai-analysis">
          <div class="ai-box">AI 분석 자료</div>
          <button class="ai-button">AI 분석</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const searchDate = ref('')
const items = ref([
  {
    id: 'A', title: '방송 제목 A', date: '2025-06-10',
    stats: {
      viewers: '100명', duration: '30분', chats: '350건',
      orders: '20건', sales: '3,000,000원', conversionRate: '35%'
    }
  },
  {
    id: 'B', title: '방송 제목 B', date: '2025-06-10',
    stats: {
      viewers: '100명', duration: '30분', chats: '350건',
      orders: '20건', sales: '3,000,000원', conversionRate: '35%'
    }
  },
  {
    id: 'C', title: '방송 제목 C', date: '2025-06-10',
    stats: {
      viewers: '100명', duration: '30분', chats: '350건',
      orders: '20건', sales: '3,000,000원', conversionRate: '35%'
    }
  },
  {
    id: 'D', title: '방송 제목 D', date: '2025-06-10',
    stats: {
      viewers: '100명', duration: '30분', chats: '350건',
      orders: '20건', sales: '3,000,000원', conversionRate: '35%'
    }
  },
  {
    id: 'E', title: '방송 제목 E', date: '2025-06-10',
    stats: {
      viewers: '100명', duration: '30분', chats: '350건',
      orders: '20건', sales: '3,000,000원', conversionRate: '35%'
    }
  },
  {
    id: 'F', title: '방송 제목 F', date: '2025-06-10',
    stats: {
      viewers: '100명', duration: '30분', chats: '350건',
      orders: '20건', sales: '3,000,000원', conversionRate: '35%'
    }
  },
  // ... 다른 항목
])
const selectedItem = ref(null)

function selectItem(item) {
  selectedItem.value = item
}

const filteredItems = computed(() =>
    searchDate.value
        ? items.value.filter(i => i.date.includes(searchDate.value))
        : items.value
)
</script>

<style scoped>
.statistics {
  padding: 20px;
  font-family: sans-serif;
  margin: 70px 200px;
}

.statistics-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.statistics-header input {
  width: 100%;
  max-width: 300px;
  padding: 8px 12px;
  border: 1px solid #ccc;
  border-radius: 10px;
  font-size: 1rem;
}

.cards-container {
  border: 1px solid #ccc;
  padding: 32px;
  border-radius: 10px;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 32px;
  margin-bottom: 24px;
  min-height: 240px;
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

.card:hover {
  transform: translateY(-2px);
}

.card--active {
  border-color: #4f46e5;
  background: #eef2ff;
}

.card-title {
  font-size: 1.25rem;
  font-weight: bold;
}

.card-date {
  text-align: right;
  color: #777;
}

.details {
  background: #fff;
  padding: 16px;
  border: 1px solid #ddd;
  border-radius: 10px;
  box-shadow: 2px 2px 6px rgba(0,0,0,0.05);
  margin-top: 16px;
}

.detail-content {
  display: flex;
  gap: 24px;
}

.stats-cards {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-template-rows: repeat(3, auto);
  gap: 16px;
  width: 60%;
}

.stats-card-small {
  background: #f9f9f9;
  border: 1px solid #ddd;
  border-radius: 6px;
  padding: 12px;
  text-align: center;
}

.small-title {
  font-size: 0.9rem;
  margin-bottom: 8px;
  color: #333;
}

.small-value {
  font-size: 1.1rem;
  font-weight: bold;
  color: #111;
}

.ai-analysis {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-between;
  width: 40%;
}

.ai-box {
  flex: 1;
  background: #f5f5f5;
  border: 1px dashed #ccc;
  border-radius: 6px;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.2rem;
  color: #666;
}

.ai-button {
  margin-top: 16px;
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  background: #4f46e5;
  color: white;
  cursor: pointer;
  font-size: 1rem;
}

.ai-button:hover {
  background: #4338ca;
}
</style>
