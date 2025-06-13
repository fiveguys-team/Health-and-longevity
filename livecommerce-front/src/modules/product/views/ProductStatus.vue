<template>
  <div class="p-8 max-w-6xl mx-auto">
    <h2 class="text-3xl font-bold mb-8 flex items-center gap-2">
      상품 등록 현황
    </h2>

    <!-- 상품 목록 -->
    <div v-if="products.length > 0" class="space-y-6 mb-10">
      <div
          v-for="(product, index) in products"
          :key="index"
          class="border rounded-lg shadow hover:shadow-md transition duration-300"
      >
        <!-- 요약 정보 -->
        <div
            class="flex justify-between items-center p-5 cursor-pointer hover:bg-gray-50"
            @click="selectProduct(product.productId)"
        >
          <div class="space-y-1">
            <p><strong>상품명:</strong> {{ product.name }}</p>
            <p><strong>수량:</strong> {{ product.stockCount }} 개</p>
            <p><strong>가격:</strong> {{ product.price.toLocaleString() }}원</p>
            <p>
              <strong>승인상태:</strong>
              <span :class="getStatusClass(product.status)">
                {{ statusKorean(product.status) }}
              </span>
            </p>
          </div>
          <!-- 아이콘 토글 -->
          <span class="text-gray-400 text-xl">
            {{ selectedProductId === product.productId ? '▼' : '▶' }}
          </span>
        </div>

        <!-- 상세 정보 -->
        <div
            v-if="selectedProductId === product.productId && selectedDetail"
            class="p-6 bg-gray-50 border-t text-sm leading-relaxed"
        >
          <h3 class="text-lg font-semibold mb-4 text-gray-800">📄 상세 정보</h3>
          <div class="grid grid-cols-2 gap-x-8 gap-y-3">
            <p><strong>인증번호:</strong> {{ selectedDetail.certNo }}</p>
            <p><strong>상품명:</strong> {{ selectedDetail.productName }}</p>
            <p><strong>유통기한:</strong> {{ selectedDetail.expiryDate }}</p>
            <p><strong>허가일자:</strong> {{ selectedDetail.approvalDate }}</p>
            <p class="col-span-2"><strong>섭취방법:</strong> {{ selectedDetail.howToTake }}</p>
            <p class="col-span-2"><strong>기능성:</strong> {{ selectedDetail.mainFunction }}</p>
            <p class="col-span-2"><strong>주의사항:</strong> {{ selectedDetail.precautions }}</p>
            <p class="col-span-2"><strong>보관방법:</strong> {{ selectedDetail.storageMethod }}</p>
            <p class="col-span-2"><strong>기준규격:</strong> {{ selectedDetail.standard }}</p>
            <p class="col-span-2"><strong>원재료:</strong> {{ selectedDetail.ingredients }}</p>
          </div>
        </div>
      </div>
    </div>

    <div v-else class="text-center text-gray-400 mt-20 text-lg">
      등록된 상품이 없습니다.
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const products = ref([])
const selectedDetail = ref(null)
const selectedProductId = ref(null)

const statusKorean = (status) => {
  switch (status) {
    case 'PENDING': return '대기'
    case 'APPROVED': return '완료'
    case 'REJECTED': return '반려'
    case 'RESUBMITTED': return '재등록'
    default: return status
  }
}

const getStatusClass = (status) => {
  switch (status) {
    case 'PENDING': return 'text-yellow-800 bg-yellow-100 px-2 py-1 rounded'
    case 'APPROVED': return 'text-green-800 bg-green-100 px-2 py-1 rounded'
    case 'REJECTED': return 'text-red-800 bg-red-100 px-2 py-1 rounded'
    case 'RESUBMITTED': return 'text-purple-800 bg-purple-100 px-2 py-1 rounded'
    default: return 'text-gray-600'
  }
}

const selectProduct = async (productId) => {
  if (selectedProductId.value === productId) {
    selectedProductId.value = null
    selectedDetail.value = null
    return
  }

  selectedProductId.value = productId
  try {
    const res = await axios.get(`http://localhost:8080/api/product/product/detail/${productId}`)
    selectedDetail.value = res.data
  } catch (error) {
    console.error('상세 정보 조회 실패:', error)
    selectedDetail.value = null
  }
}

onMounted(async () => {
  try {
    const res = await axios.get(`http://localhost:8080/api/product/vendor/1/products`)
    products.value = res.data
  } catch (error) {
    console.error('상품 목록 조회 실패:', error)
  }
})
</script>
