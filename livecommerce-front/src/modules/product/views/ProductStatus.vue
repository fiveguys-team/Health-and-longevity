<template>
  <div class="p-8 max-w-6xl mx-auto">
    <h2 class="text-3xl font-bold mb-6 text-gray-800">상품 등록 현황</h2>

    <!-- 상태 필터 버튼 -->
    <div class="flex gap-3 mb-8 flex-wrap">
      <button
          v-for="s in statusList"
          :key="s.value"
          @click="() => { currentStatus = s.value; fetchProducts(); }"
          :class="[
          'px-5 py-2 rounded-full border font-medium transition-all duration-200',
          currentStatus === s.value
            ? 'bg-blue-600 text-white shadow'
            : 'bg-gray-100 text-gray-800 hover:bg-blue-100'
        ]"
      >
        {{ s.label }}
      </button>
    </div>

    <!-- 상품 목록 카드 -->
    <div v-if="products.length > 0" class="space-y-6">
      <div
          v-for="product in products"
          :key="product.productId"
          class="bg-white border border-gray-200 p-6 rounded-xl shadow-sm hover:shadow-md transition-shadow duration-300"
      >
        <div class="flex justify-between items-center">
          <div>
            <p class="text-lg font-semibold text-gray-800 mb-1">
              상품명: {{ product.name }}
            </p>
            <p class="text-sm text-gray-600 mb-1">
              수량: {{ product.stockCount ?? '알 수 없음' }} 개
            </p>
            <p class="text-sm">
              <span class="font-semibold text-gray-700">승인상태:</span>
              <span :class="getStatusClass(product.status)">
                {{ getStatusText(product.status) }}
              </span>
            </p>
          </div>

          <button
              @click="toggleProductDetail(product.productId)"
              class="bg-blue-500 hover:bg-blue-600 text-white px-5 py-2 rounded-lg transition-all duration-200"
          >
            {{ selectedProductId === product.productId ? '접기' : '상세보기' }}
          </button>
        </div>

        <!-- 상세 정보 드롭다운 -->
        <div
            v-show="selectedProductId === product.productId"
            class="mt-5 p-4 bg-gray-50 border-t rounded text-sm text-gray-700"
        >
          <template v-if="selectedDetail">
            <h3 class="font-semibold mb-2">📄 상세 정보</h3>
            <p><strong>인증번호:</strong> {{ selectedDetail.certNo }}</p>
            <p><strong>제품명:</strong> {{ selectedDetail.productName }}</p>
            <p><strong>유통기한:</strong> {{ selectedDetail.expiryDate }}</p>
            <p><strong>허가일자:</strong> {{ selectedDetail.approvalDate }}</p>
            <p class="mt-2"><strong>섭취방법:</strong> {{ selectedDetail.howToTake }}</p>
            <p><strong>기능성:</strong> {{ selectedDetail.mainFunction }}</p>
            <p><strong>주의사항:</strong> {{ selectedDetail.precautions }}</p>
            <p><strong>보관방법:</strong> {{ selectedDetail.storageMethod }}</p>
            <p><strong>기준 및 규격:</strong> {{ selectedDetail.standard }}</p>
            <p><strong>원재료:</strong> {{ selectedDetail.ingredients }}</p>
          </template>
          <template v-else>
            <p class="text-red-600">상세 정보를 불러올 수 없습니다.</p>
          </template>
        </div>
      </div>
    </div>

    <!-- 상품 없음 안내 -->
    <div v-else class="text-gray-500 mt-16 text-center text-lg">
      해당 상태의 상품이 없습니다 😥
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import axios from '@/utils/axios'

const products = ref([])
const currentStatus = ref('')
const selectedProductId = ref(null)
const selectedDetail = ref(null)
const route = useRoute()

const statusList = [
  { label: '전체', value: '' },
  { label: '대기', value: 'PENDING' },
  { label: '승인 완료', value: 'APPROVED' },
  { label: '반려', value: 'REJECTED' },
  { label: '재등록', value: 'RESUBMITTED' }
]

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

const fetchProducts = async () => {
  try {
    const vendorId = 1 // TODO: 로그인된 사용자 ID로 교체
    const url = currentStatus.value
        ? `/product/vendor/${vendorId}/products?status=${currentStatus.value}`
        : `/product/vendor/${vendorId}/products`

    const res = await axios.get(url)
    products.value = res.data
  } catch (err) {
    console.error('상품 목록 조회 실패', err)
    alert('상품 목록을 불러오는 데 실패했습니다.')
  }
}

const toggleProductDetail = async (productId) => {
  if (selectedProductId.value === productId) {
    selectedProductId.value = null
    selectedDetail.value = null
    return
  }

  try {
    console.log('상세조회 요청:', `/product/detail/${productId}`)
    const res = await axios.get(`/product/detail/${productId}`)
    selectedProductId.value = productId
    selectedDetail.value = res.data
  } catch (err) {
    console.error('상세 정보 조회 실패', err)
    selectedProductId.value = null
    selectedDetail.value = null
  }
}

onMounted(async () => {
  await fetchProducts()
  if (route.params.id) {
    await toggleProductDetail(route.params.id)
  }
})
</script>
