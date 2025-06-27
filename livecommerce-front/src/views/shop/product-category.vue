<template>
  <div>
    <NavbarOne />

    <!-- 배경 이미지 + 타이틀 -->
    <div
        class="flex items-center gap-4 flex-wrap bg-overlay py-16 sm:py-20 before:bg-title before:bg-opacity-70"
        :style="{ backgroundImage: 'url(' + bg + ')' }"
    >
      <div class="text-center w-full">
        <h2 class="text-white text-4xl md:text-5xl font-semibold leading-none">
          {{ decodeURIComponent(categoryTitle) }}
        </h2>
        <ul class="flex justify-center gap-2 text-base md:text-lg text-white mt-4">
          <li><router-link to="/">고민별</router-link></li>
          <li>/</li>
          <li class="text-primary">{{ decodeURIComponent(categoryTitle) }}</li>
        </ul>
      </div>
    </div>

    <!-- 상품 리스트 -->
    <div class="pt-20 pb-24 bg-white">
      <div class="container-fluid">
        <div class="max-w-[1720px] mx-auto" data-aos="fade-up" data-aos-delay="200">
          <!-- 정렬 옵션 -->
          <div class="flex justify-end mb-6">
            <select v-model="sortOption" class="border px-4 py-2 rounded focus:outline-none focus:ring">
              <option value="default">기본 정렬</option>
              <option value="price-asc">가격 낮은순</option>
              <option value="price-desc">가격 높은순</option>
            </select>
          </div>

          <!-- 상품 카드 -->
          <LayoutOne
              v-if="productList.length > 0"
              :classList="'grid grid-cols-1 sm:grid-cols-2 md:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8'"
              :productList="paginatedProductList"
          />

          <div v-else class="text-center text-gray-400 text-lg mt-20">
            해당 카테고리의 상품이 없습니다 😥
          </div>

          <!-- 페이지네이션 -->
          <div class="mt-14 flex items-center justify-center gap-2" v-if="totalPages > 1">
            <button
                :disabled="currentPage === 1"
                @click="changePage(currentPage - 1)"
                class="w-10 h-10 flex items-center justify-center border rounded text-gray-500 hover:text-black"
            >
              &lt;
            </button>

            <button
                v-for="n in visiblePages"
                :key="n"
                @click="changePage(n)"
                :class="[
                'w-10 h-10 flex items-center justify-center border rounded',
                currentPage === n ? 'bg-black text-white' : 'text-gray-700 hover:bg-gray-200'
              ]"
            >
              {{ String(n).padStart(2, '0') }}
            </button>

            <button
                :disabled="currentPage === totalPages"
                @click="changePage(currentPage + 1)"
                class="w-10 h-10 flex items-center justify-center border rounded text-gray-500 hover:text-black"
            >
              &gt;
            </button>
          </div>
        </div>
      </div>
    </div>

    <FooterOne />
    <ScrollToTop />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import axiosInstance from '@/api/axios'
import Aos from 'aos'

import NavbarOne from '@/components/navbar/navbar-one.vue'
import LayoutOne from '@/components/product/layout-one.vue'
import FooterOne from '@/components/footer/footer-one.vue'
import ScrollToTop from '@/components/scroll-to-top.vue'
import bg from '@/assets/img/shortcode/breadcumb.jpg'

const route = useRoute()
const categoryTitle = computed(() => route.params.category || '전체')

const productList = ref([])
const totalCount = ref(0)  // ✅ 누락되었던 totalCount 추가
const currentPage = ref(1)
const pageSize = 9
const sortOption = ref('default')

const totalPages = computed(() => Math.ceil(totalCount.value / pageSize))

// ✅ 중앙 정렬 + 말단 보정 페이지 그룹 계산
const visiblePages = computed(() => {
  const total = totalPages.value
  const current = currentPage.value
  const groupSize = 5

  const groupStart = Math.floor((current - 1) / groupSize) * groupSize + 1
  const groupEnd = Math.min(groupStart + groupSize - 1, total)

  return Array.from({ length: groupEnd - groupStart + 1 }, (_, i) => groupStart + i)
})

const changePage = (page) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
    fetchProductList()  // ✅ 페이지 클릭 시 새로 불러오기
  }
}

const paginatedProductList = computed(() => {
  const start = (currentPage.value - 1) * pageSize
  const end = start + pageSize
  return sortedProductList.value.slice(start, end).map(product => ({
    ...product,
    stockCount: Number(product.stockCount)
  }))
})

const sortedProductList = computed(() => {
  switch (sortOption.value) {
    case 'price-asc':
      return [...productList.value].sort((a, b) => a.price - b.price)
    case 'price-desc':
      return [...productList.value].sort((a, b) => b.price - a.price)
    case 'rating':
      return [...productList.value].sort((a, b) => b.averageRating - a.averageRating)
    default:
      return productList.value
  }
})

const categoryMap = {
  'blood-pressure': '혈압',
  'eye': '눈',
  'eye-health': '눈',
  'joint': '뼈/관절/연결성분',
  'joint-health': '뼈/관절/연결성분',
  'digestion': '장건강',
  'gut-health': '장건강',
  'memory': '기억력',
  'immune': '면역력',
  'fatigue': '피로개선',
  'supplement': '영양보충'
}

async function fetchProductList() {
  try {
    const category = route.params.category
    const korCategory = categoryMap[category]

    if (!korCategory) {
      productList.value = []
      totalCount.value = 0
      return
    }

    // 👇 전체 데이터를 받아오자 (page, size 제거)
    const res = await axiosInstance.get('/api/products', {
      params: {
        status: 'APPROVED',
        category: korCategory
      }
    })

    productList.value = res.data.map(product => ({
      ...product,
      stockCount: Number(product.stockCount), // ✅ 이거 추가!
      reviewCount: product.reviewCount || 0,
      averageRating: product.averageRating || 0,
      discountedPrice: Number(product.discountedPrice ?? product.price),
      discountRate: Number(product.discountRate ?? 0)
    }))
    totalCount.value = productList.value.length // 전체 상품 수

  } catch (err) {
    console.error('❌ 상품 목록 불러오기 실패', err)
  }
  console.log('📦 최종 상품 리스트', productList.value)
}


onMounted(() => {
  Aos.init()
  fetchProductList()
})

watch(() => route.params.category, () => {
  currentPage.value = 1
  fetchProductList()
})
</script>

