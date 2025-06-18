<template>
  <div>
    <NavbarOne />

    <!-- 🟦 배경 -->
    <div
        class="flex flex-col items-center justify-center gap-3 py-16 bg-overlay before:bg-title before:bg-opacity-70"
        :style="{ backgroundImage: 'url(' + bg + ')' }"
    >
      <h1 v-if="vendorName" class="text-white font-light">
        {{ vendorName }}
      </h1>
    </div>

    <!-- 🔍 검색창 (상품 리스트 위) -->
    <div class="container-fluid max-w-[1720px] mx-auto mt-8 flex justify-end items-center gap-2">
      <input
          v-model="searchInput"
          type="text"
          placeholder="상품명을 입력하세요"
          class="px-4 py-2 border rounded focus:outline-none focus:ring w-[240px]"
      />
      <button
          @click="applySearch"
          class="px-4 py-2 bg-primary text-white rounded hover:bg-opacity-80 transition"
      >
        검색
      </button>
    </div>

    <!-- 🟩 상품 리스트 -->
    <div class="py-20 bg-white">
      <div class="container-fluid max-w-[1720px] mx-auto">
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-10" data-aos="fade-up">
          <div
              v-for="product in filteredProducts"
              :key="product.productId"
              class="border p-6 rounded shadow hover:shadow-lg transition group"
          >
            <router-link :to="`/product-details/${product.productId}`">
              <!-- ✅ 이미지 -->
              <div class="relative w-full h-[220px] mb-4 rounded overflow-hidden">
                <!-- ✅ 할인 뱃지 -->
                <div
                    v-if="product.discountRate > 0"
                    class="absolute top-4 right-4 bg-green-600 text-white text-sm font-bold px-3 py-1 rounded z-40 shadow"
                >
                  할인중
                </div>

                <img
                    class="w-full h-full object-cover transform group-hover:scale-105 duration-300"
                    :src="getImageUrl(product.productImage)"
                    @error="onImageError"
                    alt="shop"
                />

                <!-- ✅ 품절 오버레이 -->
                <div
                    v-if="Number(product.stockCount) === 0"
                    class="absolute inset-0 bg-black bg-opacity-60 flex items-center justify-center z-30"
                >
        <span class="text-white text-3xl font-extrabold animate-pulse tracking-widest">
          품절
        </span>
                </div>
              </div>

              <!-- ✅ 상품명 -->
              <h5 class="text-xl font-semibold mt-2 text-primary hover:underline">
                {{ product.name }}
              </h5>

              <!-- ✅ 업체명 -->
              <p class="text-sm text-gray-500 mt-1">
                {{ product.vendor }}
              </p>

              <!-- ✅ 가격 -->
              <div class="mt-3">
                <h4
                    v-if="product.discountRate > 0"
                    class="text-lg font-bold text-red-600"
                >
                  {{ product.discountedPrice.toLocaleString() }}원
                  <span class="ml-2 text-sm text-gray-400 line-through">
      {{ product.price.toLocaleString() }}원
    </span>
                  <span class="ml-2 text-sm text-green-500">({{ product.discountRate }}% ↓)</span>
                </h4>
                <h4
                    v-else
                    class="text-lg font-medium text-gray-900"
                >
                  {{ product.price.toLocaleString() }}원
                </h4>
              </div>

              <!-- ✅ 별점 -->
              <div class="flex items-center gap-1 mt-2">
                <div v-for="n in 5" :key="n" class="relative w-5 h-5">
                  <i class="fa fa-star text-gray-300 absolute left-0 top-0 w-full h-full"></i>
                  <i
                      class="fa fa-star text-yellow-400 absolute left-0 top-0 h-full overflow-hidden"
                      :style="{ width: getStarFill(n, product.averageRating) + '%' }"
                  ></i>
                </div>
                <span class="ml-2 text-sm text-gray-400">({{ product.reviewCount || 0 }})</span>
              </div>
            </router-link>
          </div>
        </div>

        <div v-if="filteredProducts.length === 0" class="text-center text-gray-500 mt-10">
          등록된 상품이 없습니다.
        </div>
      </div>
    </div>

    <FooterOne />
    <ScrollToTop />
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import axios from '@/utils/axios'

import NavbarOne from '@/components/navbar/navbar-one.vue'
import FooterOne from '@/components/footer/footer-one.vue'
import ScrollToTop from '@/components/scroll-to-top.vue'
import bg from '@/assets/img/shortcode/breadcumb.jpg'

const productList = ref([])
const vendorName = ref('')
const route = useRoute()
const vendorId = route.params.vendorId

onMounted(() => {
  fetchVendorProducts()
})

async function fetchVendorProducts() {
  try {
    const res = await axios.get(`/product/company/${vendorId}/products`)
    productList.value = res.data.map(product => ({
      ...product,
      reviewCount: product.reviewCount || 0,
      averageRating: product.averageRating || 0.0,
      discountedPrice: product.discountedPrice ?? product.price,
      discountRate: product.discountRate ?? 0
    }))

    // ✅ 첫 상품에서 업체명 추출
    if (productList.value.length > 0) {
      vendorName.value = productList.value[0].vendor || '알 수 없는 업체'
    }
  } catch (err) {
    console.error('❌ 업체 상품 불러오기 실패', err)
  }
}

function getImageUrl(imageName) {
  return imageName ? `/uploads/images/${imageName}` : '/no-image.png'
}

function onImageError(event) {
  event.target.src = '/no-image.png'
}

function getStarFill(starIndex, rating) {
  const full = Math.floor(rating)
  const partial = Math.round((rating - full) * 100)
  if (starIndex <= full) return 100
  if (starIndex === full + 1) return partial
  return 0
}


const searchInput = ref('')
const searchText = ref('')

const applySearch = () => {
  searchText.value = searchInput.value
}

const filteredProducts = computed(() => {
  const keyword = searchText.value.trim().toLowerCase()
  if (!keyword) return productList.value
  return productList.value.filter(product =>
      product.name?.toLowerCase().includes(keyword)
  )
})
</script>

