<template>
  <div class="p-8 max-w-5xl mx-auto">
    <h2 class="text-3xl font-bold mb-6 text-gray-800">📋 상품 상세 정보</h2>

    <div v-if="product" class="bg-white border p-6 rounded-xl shadow space-y-6 text-base leading-relaxed">
      <div class="grid sm:grid-cols-2 gap-x-10 gap-y-4">
        <p><strong>상품명:</strong> {{ product.name }}</p>
        <p><strong>업체명:</strong> {{ product.company }}</p>
        <p><strong>인증번호:</strong> {{ product.certNo }}</p>
        <p><strong>품목명:</strong> {{ product.productName }}</p>
        <p><strong>가격:</strong> {{ product.price.toLocaleString() }}원</p>
        <p><strong>수량:</strong> {{ product.stockCount }} 개</p>
        <p><strong>카테고리 ID:</strong> {{ product.categoryId }}</p>
        <p><strong>허가일자:</strong> {{ product.approvalDate }}</p>
        <p><strong>유통기한:</strong> {{ product.expiryDate }}</p>
        <p>
          <strong>현재 상태:</strong>
          <span :class="getStatusClass(product.status)">
            {{ getStatusText(product.status) }}
          </span>
        </p>
      </div>

      <div class="grid gap-y-3 text-sm text-gray-700">
        <p><strong>섭취 방법:</strong> {{ product.howToTake }}</p>
        <p><strong>기능성:</strong> {{ product.mainFunction }}</p>
        <p><strong>주의사항:</strong> {{ product.precautions }}</p>
        <p><strong>보관 방법:</strong> {{ product.storageMethod }}</p>
        <p><strong>기준 규격:</strong> {{ product.standard }}</p>
        <p><strong>원재료:</strong> {{ product.ingredients }}</p>
      </div>

      <div v-if="product.productImage">
        <p class="mb-2"><strong>상품 이미지:</strong></p>
        <img
            :src="`/uploads/images/${product.productImage}`"
            alt="상품 이미지"
            class="w-64 rounded-lg border shadow hover:scale-105 transition-transform duration-200"
        />
      </div>
    </div>

    <div v-else class="text-gray-500 text-center mt-16">
      <span class="animate-pulse">⏳ 상품 정보를 불러오는 중입니다...</span>
    </div>

    <!-- 승인/반려 버튼 -->
    <div class="flex justify-center mt-8 gap-4" v-if="['PENDING', 'RESUBMITTED'].includes(product?.status)">
      <button
          @click="handleApprove"
          class="bg-green-600 hover:bg-green-700 text-white px-6 py-2 rounded shadow transition-all"
      >
        ✅ 승인
      </button>
      <button
          @click="handleReject"
          class="bg-red-600 hover:bg-red-700 text-white px-6 py-2 rounded shadow transition-all"
      >
        ❌ 반려
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from '@/utils/axios'

const route = useRoute()
const router = useRouter()
const productId = route.params.id

const product = ref(null)

const fetchProduct = async () => {
  try {
    const res = await axios.get(`/admin/products/detail/${productId}`)
    product.value = res.data
  } catch (err) {
    console.error(err)
    alert('상품 정보를 불러오지 못했습니다.')
  }
}

const handleApprove = async () => {
  try {
    await axios.post(`/admin/products/approve/${productId}`)
    alert('상품이 승인되었습니다.')
    router.push('/admin/products')
  } catch (err) {
    alert('승인 실패')
  }
}

const handleReject = async () => {
  try {
    await axios.post(`/admin/products/reject/${productId}`)
    alert('상품이 반려되었습니다.')
    router.push('/admin/products')
  } catch (err) {
    alert('반려 실패')
  }
}

const getStatusText = (status) => {
  switch (status) {
    case 'PENDING': return '승인 대기'
    case 'APPROVED': return '승인 완료'
    case 'REJECTED': return '반려됨'
    case 'RESUBMITTED': return '재등록 요청'
    default: return status
  }
}

const getStatusClass = (status) => {
  const base = 'px-3 py-1 text-sm font-medium rounded-full'
  switch (status) {
    case 'PENDING': return `${base} bg-yellow-100 text-yellow-800`
    case 'APPROVED': return `${base} bg-blue-100 text-blue-800`
    case 'REJECTED': return `${base} bg-red-100 text-red-700`
    case 'RESUBMITTED': return `${base} bg-purple-100 text-purple-800`
    default: return `${base} bg-gray-200 text-gray-700`
  }
}

onMounted(() => {
  fetchProduct()
})
</script>
