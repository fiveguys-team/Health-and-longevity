<template>
  <div class="statistics">
    <!-- 헤더: 제목 + 날짜 검색 -->
    <div class="statistics-header">
      <h1>통계 자료</h1>
      <input v-model="searchDate" type="text" placeholder="날짜 검색 (YYYY-MM-DD)"/>
    </div>

    <!-- 카드들을 감싸는 컨테이너 -->
    <div class="cards-container">
      <div v-for="item in filteredItems" :key="item.id" class="card" >
        <div class="card-title">{{ item.title }}</div>
        <div class="card-date">{{ item.date }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import {ref, computed} from 'vue'


// 검색할 날짜 (YYYY-MM-DD 포맷)
const searchDate = ref('')

// 예시용 방송 데이터 (원하는 순서로 배치)
const items = ref([
  {id: 'A', title: '방송 제목 A', date: '2025-06-10'},
  {id: 'B', title: '방송 제목 B', date: '2025-06-11'},
  {id: 'F', title: '방송 제목 F', date: '2025-06-12'},
  {id: 'C', title: '방송 제목 C', date: '2025-06-13'},
  {id: 'E', title: '방송 제목 E', date: '2025-06-14'},
  {id: 'D', title: '방송 제목 D', date: '2025-06-15'},
])

// searchDate 값이 있을 때만 필터 적용
const filteredItems = computed(() => {
  if (!searchDate.value) {
    return items.value
  }
  return items.value.filter(item =>
      item.date.includes(searchDate.value)
  )
})
</script>

<style scoped>
.statistics {
  padding: 20px;
  font-family: sans-serif;
}

.statistics-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.statistics-header h1 {
  margin: 0;
  font-size: 1.5rem;
}

.statistics-header input {
  width: 200px;
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
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}

.card {
  background: #fff;
  padding: 16px;
  border: 1px solid #ddd;
  border-radius: 4px;
  box-shadow: 2px 2px 6px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.card-title {
  font-size: 1.25rem;
  font-weight: bold;
}

.card-date {
  text-align: right;
  color: #777;
}
</style>
