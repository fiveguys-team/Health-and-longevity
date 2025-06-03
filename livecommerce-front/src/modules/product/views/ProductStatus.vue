<!-- src/modules/product/views/ProductStatus.vue -->
<template>
  <div class="p-8 max-w-6xl mx-auto">
    <h2 class="text-2xl font-bold mb-6">상품 등록 현황</h2>

    <div v-if="products.length > 0" class="space-y-4">
      <div
          v-for="(product, index) in products"
          :key="index"
          class="flex justify-between items-center border p-4 rounded shadow"
      >
        <div>
          <p><strong>상품명:</strong> {{ product.name }}</p>
          <p><strong>수량:</strong> {{ product.quantity }}</p>
          <p><strong>가격:</strong> {{ product.price }}원</p>
          <p><strong>승인상태:</strong> {{ product.status }}</p>
        </div>
        <button class="bg-blue-500 text-white px-4 py-1 rounded">수정</button>
      </div>
    </div>

    <div v-else class="text-center text-gray-500 mt-20">
      등록된 상품이 없습니다.
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

// 임시 상품 목록 (후에 API로 대체 가능)
const products = ref([
  { name: '홍삼 농축액', quantity: 100, price: 30000, status: '승인 대기' },
  { name: '루테인 비타민', quantity: 50, price: 15000, status: '승인 완료' }
])
</script>
