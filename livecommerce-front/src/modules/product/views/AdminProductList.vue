  <template>
    <div class="p-8 max-w-6xl mx-auto">
      <h2 class="text-3xl font-bold mb-6 text-gray-800">상품 등록 목록</h2>

      <!-- 상태 필터 버튼 -->
      <div class="flex gap-3 mb-8 flex-wrap">
        <button
            v-for="s in statusList"
            :key="s.value"
            @click="currentStatus = s.value; fetchProducts()"
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
            :key="product.id"
            class="flex justify-between items-center bg-white border border-gray-200 p-6 rounded-xl shadow-sm hover:shadow-md transition-shadow duration-300"
        >
          <div>
            <p class="text-lg font-semibold text-gray-800 mb-1">상품명: {{ product.name }}</p>
            <p class="text-sm text-gray-600 mb-1">업체명: {{ product.vendor }}</p>
            <p class="text-sm">
              <span class="font-semibold text-gray-700">승인상태:</span>
              <span :class="getStatusClass(product.status)">
                {{ getStatusText(product.status) }}
              </span>
            </p>
          </div>

          <router-link
              :to="`/admin/product/detail/${product.id}`"
              class="bg-blue-500 hover:bg-blue-600 text-white px-5 py-2 rounded-lg transition-all duration-200"
          >
            상세보기
          </router-link>
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
  import axiosInstance from '@/api/axios'

  const products = ref([])
  const currentStatus = ref('') // 전체 보기

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
      const url = currentStatus.value
          ? `/api/admin/products?status=${currentStatus.value}`
          : '/api/admin/products'

      console.log("요청 URL:", url)
      const res = await axiosInstance.get(url)
      console.log("응답 데이터:", res.data)

      products.value = res.data
    } catch (err) {
      console.error("🔥 Axios 에러:", err)
      alert("상품 목록 조회 실패")
    }
  }


  onMounted(() => {
    fetchProducts()
  })
  </script>
