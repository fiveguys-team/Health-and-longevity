<template>
  <div class="p-8 max-w-6xl mx-auto">
    <h2 class="text-2xl font-bold mb-6">상품 등록 현황</h2>

    <!-- 상품 목록 -->
    <div v-if="products.length > 0" class="space-y-4 mb-10">
      <div
          v-for="(product, index) in products"
          :key="index"
          class="border rounded shadow"
      >
        <!-- 요약 정보 -->
        <div
            class="flex justify-between items-center p-4 cursor-pointer hover:bg-gray-100"
            @click="selectProduct(product.productId)"
        >
          <div>
            <p><strong>상품명:</strong> {{ product.name }}</p>
            <p><strong>수량:</strong> {{ product.stockCount }}</p>
            <p><strong>가격:</strong> {{ product.price }}원</p>
            <p><strong>승인상태:</strong> {{ statusKorean(product.status) }}</p>
          </div>
        </div>

        <!-- 상세 정보 (조건부 렌더링) -->
        <div
            v-if="selectedProductId === product.productId && selectedDetail"
            class="p-6 bg-gray-50 border-t"
        >
          <h3 class="text-xl font-bold mb-4">상품 상세 정보</h3>
          <p><strong>인증번호:</strong> {{ selectedDetail.certNo }}</p>
          <p><strong>상품명:</strong> {{ selectedDetail.productName }}</p>
          <p><strong>유통기한:</strong> {{ selectedDetail.expiryDate }}</p>
          <p><strong>허가일자:</strong> {{ selectedDetail.approvalDate }}</p>
          <p><strong>섭취방법:</strong> {{ selectedDetail.howToTake }}</p>
          <p><strong>기능성:</strong> {{ selectedDetail.mainFunction }}</p>
          <p><strong>주의사항:</strong> {{ selectedDetail.precautions }}</p>
          <p><strong>보관방법:</strong> {{ selectedDetail.storageMethod }}</p>
          <p><strong>기준규격:</strong> {{ selectedDetail.standard }}</p>
          <p><strong>원재료:</strong> {{ selectedDetail.ingredients }}</p>
        </div>
      </div>
    </div>

    <div v-else class="text-center text-gray-500 mt-20">
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

const selectProduct = async (productId) => {
  // 같은 상품을 다시 누르면 상세 닫기
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
