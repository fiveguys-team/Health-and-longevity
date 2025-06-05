<template>
  <div>
    <NavbarOne />

    <!-- 상단 배경 및 업체명 타이틀 -->
    <div
        class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70"
        :style="{ backgroundImage: 'url(' + bg + ')' }"
    >
      <div class="text-center w-full">
        <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">
          {{ decodedVendorName }}
        </h2>
        <ul
            class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4"
        >
          <li><router-link to="/">Home</router-link></li>
          <li>/</li>
          <li class="text-primary">{{ decodedVendorName }}</li>
        </ul>
      </div>
    </div>

    <!-- 상품 목록 -->
    <div class="s-py-100">
      <div class="container-fluid">
        <div data-aos="fade-up" data-aos-delay="200">
          <LayoutOne
              :classList="'max-w-[1720px] mx-auto grid grid-cols-1 sm:grid-cols-2 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5 sm:gap-8'"
              :productList="filteredProducts"
          />
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

import NavbarOne from '@/components/navbar/navbar-one.vue'
import LayoutOne from '@/components/product/layout-one.vue'
import FooterOne from '@/components/footer/footer-one.vue'
import ScrollToTop from '@/components/scroll-to-top.vue'
import bg from '@/assets/img/shortcode/breadcumb.jpg'

import { productList as allProducts, detailReview } from '@/data/data'

const route = useRoute()
const vendorSlug = ref(route.params.vendorSlug)

// 라우트 변경 시 vendorSlug 갱신
watch(() => route.params.vendorSlug, (newVal) => {
  vendorSlug.value = newVal
})

// 업체명 복호화 (slug → 원래 이름)
const decodedVendorName = computed(() => {
  const match = allProducts.find(p => p.vendorSlug === vendorSlug.value)
  return match ? match.vendor : '업체명'
})

// 해당 업체의 상품을 리뷰 포함하여 필터링
const filteredProducts = computed(() => {
  const products = allProducts.filter(p => p.vendorSlug === vendorSlug.value)

  return products.map(product => {
    const reviews = detailReview.filter(r => r.product === product.name)
    const total = reviews.reduce((sum, r) => sum + r.rating, 0)
    const avg = reviews.length ? (total / reviews.length).toFixed(1) : '0.0'

    return {
      ...product,
      reviewCount: reviews.length,
      averageRating: avg,
    }
  })
})

// AOS 초기화
onMounted(() => {
  Aos.init()
})
</script>
