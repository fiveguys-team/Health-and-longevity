<template>
  <div class="p-8 max-w-6xl mx-auto">
    <h2 class="text-2xl font-bold mb-4">상품 등록 목록</h2>

    <div v-if="products.length > 0" class="space-y-4">
      <div
          v-for="(product, index) in products"
          :key="index"
          class="flex justify-between items-center border p-4 rounded shadow"
      >
        <div>
          <p><strong>상품명:</strong> {{ product.name }}</p>
          <p><strong>업체명:</strong> {{ product.company }}</p>
          <p><strong>승인상태:</strong> {{ product.status }}</p>
        </div>
        <router-link :to="`/admin/product/detail/${product.id}`" class="bg-blue-500 text-white px-4 py-2 rounded">상세보기</router-link>
      </div>
    </div>

    <div v-else class="text-center text-gray-500 mt-20">
      등록된 상품이 없습니다.
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

// 더미 데이터로 예시
const products = ref([
  { id: 1, name: '홍삼농축액', company: '한국인삼공사', status: '승인 대기' },
  { id: 2, name: '루테인 비타민', company: '헬스업', status: '승인 완료' }
])
</script>