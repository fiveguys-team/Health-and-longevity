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
      <ul>
        <li>방송 날짜: {{ selectedItem.date }}</li>
        <li>조회수: {{ selectedItem.stats.viewers }}</li>
        <li>좋아요: {{ selectedItem.stats.likes }}</li>
        <li>댓글 수: {{ selectedItem.stats.comments }}</li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

// 검색할 날짜 (YYYY-MM-DD 포맷)
const searchDate = ref('')

// 예시용 방송 데이터 (통계 필드를 포함)
const items = ref([
  { id: 'A', title: '방송 제목 A', date: '2025-06-10', stats: { viewers: 120, likes: 30, comments: 5 } },
  { id: 'B', title: '방송 제목 B', date: '2025-06-11', stats: { viewers: 80, likes: 12, comments: 2 } },
  { id: 'F', title: '방송 제목 F', date: '2025-06-12', stats: { viewers: 200, likes: 45, comments: 10 } },
  { id: 'C', title: '방송 제목 C', date: '2025-06-13', stats: { viewers: 150, likes: 25, comments: 8 } },
  { id: 'E', title: '방송 제목 E', date: '2025-06-14', stats: { viewers: 90, likes: 15, comments: 3 } },
  { id: 'D', title: '방송 제목 D', date: '2025-06-15', stats: { viewers: 60, likes: 8, comments: 1 } },
])

// 현재 선택된 방송 아이템
const selectedItem = ref(null)

// 카드 클릭 시 해당 아이템을 선택
function selectItem(item) {
  selectedItem.value = item
}

// 날짜 검색 필터링
const filteredItems = computed(() => {
  const list = items.value
  if (!searchDate.value) return list
  return list.filter(item => item.date.includes(searchDate.value))
})
</script>

<style scoped>
.statistics {
  padding: 20px;
  font-family: sans-serif;
}

.statistics-header {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  gap: 12px;
}

.statistics-header input {
  width: 100%;
  max-width: 300px;
  padding: 8px 12px;
  font-size: 1rem;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.cards-container {
  border: 1px solid #ccc;
  padding: 16px;
  border-radius: 4px;
  display: grid;
  /* 고정 3열 레이아웃: 항상 한 줄에 3개 표시 */
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-bottom: 24px;
  /* 높이 늘리기: 최소 400px 유지 */
  min-height: 400px;
}

.card {
  background: #fff;
  padding: 16px;
  border: 1px solid #ddd;
  border-radius: 4px;
  box-shadow: 2px 2px 6px rgba(0,0,0,0.1);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  cursor: pointer;
  transition: transform 0.1s;
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
  border-radius: 4px;
  box-shadow: 2px 2px 6px rgba(0,0,0,0.05);
  margin-top: 16px;
  min-height: 300px;
}

.details h2 {
  margin-bottom: 12px;
}

.details ul {
  list-style: none;
  padding: 0;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 8px;
}

.details li {
  margin: 0;
}
</style>
