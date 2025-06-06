<template>
  <div>
    <NavbarOne />

    <!-- 배경 이미지 + 타이틀 -->
    <div
        class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70"
        :style="{ backgroundImage: 'url(' + bg + ')' }"
    >
      <div class="text-center w-full">
        <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">
          {{ decodeURIComponent(categoryTitle) }}
        </h2>
        <ul class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4">
          <li><router-link to="/">고민별</router-link></li>
          <li>/</li>
          <li class="text-primary">{{ decodeURIComponent(categoryTitle) }}</li>
        </ul>
      </div>
    </div>

    <!-- 상품 리스트 -->
    <div class="s-py-100">
      <div class="container-fluid">
        <div data-aos="fade-up" data-aos-delay="200">
          <LayoutOne
              :classList="'max-w-[1720px] mx-auto grid grid-cols-1 sm:grid-cols-2 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5 sm:gap-8'"
              :productList="productList"
          />

          <!-- 페이징 (더미) -->
          <div class="mt-10 md:mt-12 flex items-center justify-center gap-[10px]">
            <router-link to="#" class="text-title dark:text-white text-xl">
              <span class="lnr lnr-arrow-left"></span>
            </router-link>
            <router-link
                v-for="n in 10"
                :key="n"
                to="#"
                class="w-8 sm:w-10 h-8 sm:h-10 bg-title bg-opacity-5 flex items-center justify-center leading-none text-base sm:text-lg font-medium text-title hover:bg-opacity-100 hover:text-white dark:bg-white dark:bg-opacity-5 dark:text-white dark:hover:bg-opacity-100 dark:hover:text-title"
            >
              {{ String(n).padStart(2, '0') }}
            </router-link>
            <router-link to="#" class="text-title dark:text-white text-xl">
              <span class="lnr lnr-arrow-right"></span>
            </router-link>
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
import Aos from 'aos'

// ✅ 컴포넌트
import NavbarOne from '@/components/navbar/navbar-one.vue'
import LayoutOne from '@/components/product/layout-one.vue'
import FooterOne from '@/components/footer/footer-one.vue'
import ScrollToTop from '@/components/scroll-to-top.vue'

// ✅ 배경 이미지
import bg from '@/assets/img/shortcode/breadcumb.jpg'

// ✅ 데이터 import
import { productList as allProducts, detailReview } from '@/data/data'

const route = useRoute()
const categoryTitle = computed(() => route.params.category || '전체')
const productList = ref([])

onMounted(() => {
  Aos.init()
  fetchProductList()
})

watch(() => route.params.category, fetchProductList)

function fetchProductList() {
  const category = route.params.category
  const filtered = category
      ? allProducts.filter(p => p.category === category)
      : allProducts

  productList.value = filtered.map(product => {
    const reviews = detailReview.filter(r => r.product === product.name)
    const total = reviews.reduce((sum, r) => sum + r.rating, 0)
    const avg = reviews.length ? (total / reviews.length).toFixed(1) : '0.0'

    return {
      ...product,
      reviewCount: reviews.length,
      averageRating: avg,
    }
  })
}
</script>
