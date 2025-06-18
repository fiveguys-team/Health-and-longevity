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
            <select
                v-model="sortOption"
                class="border px-4 py-2 rounded focus:outline-none focus:ring"
            >
              <option value="default">기본 정렬</option>
              <option value="price-asc">가격 낮은순</option>
              <option value="price-desc">가격 높은순</option>
              <option value="rating">인기순</option>
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

          <!-- ✅ 페이지네이션 UI -->
          <div class="mt-14 flex items-center justify-center gap-2" v-if="totalPages >= 1">
            <button
                :disabled="currentPage === 1"
                @click="changePage(currentPage - 1)"
                class="w-10 h-10 flex items-center justify-center border rounded text-gray-500 hover:text-black"
            >
              &lt;
            </button>

            <button
                v-for="n in totalPages"
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
import axios from '@/utils/axios'
import Aos from 'aos'

import NavbarOne from '@/components/navbar/navbar-one.vue'
import LayoutOne from '@/components/product/layout-one.vue'
import FooterOne from '@/components/footer/footer-one.vue'
import ScrollToTop from '@/components/scroll-to-top.vue'

import bg from '@/assets/img/shortcode/breadcumb.jpg'

const route = useRoute()
const categoryTitle = computed(() => route.params.category || '전체')
const productList = ref([])

const sortOption = ref('default')

const currentPage = ref(1)
const pageSize = 9
const totalPages = computed(() => Math.ceil(productList.value.length / pageSize))

const changePage = (page) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
  }
}

const paginatedProductList = computed(() => {
  const start = (currentPage.value - 1) * pageSize
  return sortedProductList.value.slice(start, start + pageSize)
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

onMounted(() => {
  Aos.init()
  fetchProductList()
})

watch(() => route.params.category, () => {
  currentPage.value = 1
  fetchProductList()
})

async function fetchProductList() {
  try {
    const category = route.params.category
    const korCategory = categoryMap[category]

    if (!korCategory) {
      productList.value = []
      return
    }

    const res = await axios.get('/products', {
      params: {
        status: 'APPROVED',
        category: korCategory
      }
    })

    productList.value = res.data.map(product => ({
      ...product,
      reviewCount: product.reviewCount || 0,
      averageRating: product.averageRating || '0.0'
    }))
  } catch (err) {
    console.error('❌ 상품 목록 불러오기 실패', err)
  }
}
</script>
