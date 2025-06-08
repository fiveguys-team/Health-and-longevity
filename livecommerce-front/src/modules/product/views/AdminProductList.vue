<template>
  <div class="flex min-h-screen">
    <!-- 왼쪽: 입점업체 메뉴 -->
    <aside class="w-64 bg-[#f9f9f9] border-r shadow px-6 py-8">
      <h1 class="text-3xl font-bold text-green-900 mb-6">무병<br />장수</h1>
      <p class="text-sm font-semibold text-gray-600 mb-4">입점업체</p>

      <ul class="space-y-4 text-base font-medium text-gray-700">
        <li><router-link to="/vendor/live">라이브</router-link></li>
        <li><router-link to="/vendor/product">상품/리뷰</router-link></li>
        <li><router-link to="/vendor/order">주문/결제</router-link></li>
      </ul>
    </aside>

    <!-- 오른쪽: 상품 등록 목록 -->
    <main class="flex-1 p-8 max-w-6xl">
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
          <router-link
              :to="`/admin/product/detail/${product.id}`"
              class="bg-blue-500 text-white px-4 py-2 rounded"
          >
            상세보기
          </router-link>
        </div>
      </div>

      <div v-else class="text-center text-gray-500 mt-20">
        등록된 상품이 없습니다.
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const products = ref([
  { id: 1, name: '홍삼농축액', company: '한국인삼공사', status: '승인 대기' },
  { id: 2, name: '루테인 비타민', company: '헬스업', status: '승인 완료' }
])
</script>
