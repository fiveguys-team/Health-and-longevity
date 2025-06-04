<template>
  <div class="p-8 max-w-6xl mx-auto">
    <h2 class="text-2xl font-bold mb-4">리뷰</h2>

    <!-- 필터/정렬 영역 -->
    <div class="flex justify-between mb-6">
      <div>
        <p class="font-semibold mb-2">리뷰 총점 ⭐ 5.0</p>
        <div v-for="star in 5" :key="star" class="flex items-center gap-2">
          <div>
            <span v-for="s in star" :key="s">⭐</span>
          </div>
          <span>20%</span>
        </div>
      </div>
      <div class="text-right">
        <label class="font-semibold">정렬:</label>
        <select v-model="sortOrder" class="border px-2 py-1 rounded ml-2">
          <option value="desc">별점 높은순</option>
          <option value="asc">별점 낮은순</option>
        </select>
      </div>
    </div>

    <!-- 리뷰 목록 -->
    <div v-if="filteredReviews.length > 0" class="space-y-6">
      <div v-for="(review, index) in filteredReviews" :key="index" class="border p-4 rounded">
        <div class="flex justify-between">
          <div class="font-semibold">사용자 ⭐⭐⭐⭐⭐</div>
          <button class="text-sm bg-red-500 text-white px-3 py-1 rounded">삭제</button>
        </div>

        <p class="my-2">{{ review.content }}</p>
        <p class="text-sm text-gray-500">{{ review.productName }}</p>

        <div class="mt-2">
          <label class="block mb-1 font-medium">답변내용</label>
          <textarea v-model="review.reply" class="w-full border px-2 py-1 rounded" rows="3" placeholder="답변을 입력하세요"></textarea>
          <button class="mt-2 bg-blue-500 hover:bg-blue-600 text-white px-4 py-1 rounded">답변</button>
        </div>
      </div>
    </div>

    <div v-else class="text-center text-gray-500 mt-20">
      등록된 리뷰가 없습니다.
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

// 샘플 데이터
const reviews = ref([
  {
    productName: '홍삼정 골드',
    content: '정말 좋아요! 효과도 좋고 포장도 예뻐요.',
    rating: 5,
    reply: ''
  },
  {
    productName: '건강비타민C',
    content: '약간 쌉싸름한 맛이 있지만 괜찮아요.',
    rating: 4,
    reply: ''
  }
])

const sortOrder = ref('desc')

const filteredReviews = computed(() => {
  const sorted = [...reviews.value]
  return sortOrder.value === 'desc'
      ? sorted.sort((a, b) => b.rating - a.rating)
      : sorted.sort((a, b) => a.rating - b.rating)
})
</script>

<style scoped>
select {
  min-width: 140px;
}
</style>