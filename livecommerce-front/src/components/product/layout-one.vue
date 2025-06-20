<template>
  <div :class="classList">
    <div
        v-for="item in filteredList"
        :key="item.id"
        class="relative border p-6 rounded shadow hover:shadow-lg transition group"
    >


      <router-link :to="`/product-details/${item.id}`" class="block">
        <!-- ✅ 이미지 + 오버레이 -->
        <div class="relative w-full h-[220px] mb-4 rounded overflow-hidden">

          <!-- ✅ 할인 뱃지 -->
          <div
              v-if="item.discountRate > 0"
              class="absolute top-4 right-4 bg-green-600 text-white text-sm font-bold px-3 py-1 rounded z-40 shadow"
          >
            할인중
          </div>

          <img
              class="w-full h-full object-cover transform group-hover:scale-105 duration-300"
              :src="getImageUrl(item.image)"
              @error="onImageError"
              alt="shop"
          />

          <!-- ✅ 품절 오버레이 -->
          <div
              v-if="Number(item.stockCount) === 0"
              class="absolute inset-0 bg-black bg-opacity-60 flex items-center justify-center z-30"
          >
            <span class="text-white text-3xl font-extrabold animate-pulse tracking-widest">
              품절
            </span>
          </div>
        </div>

        <!-- ✅ 상품명 -->
        <h5 class="text-xl font-semibold mt-2 text-primary hover:underline">
          {{ item.name }}
        </h5>

        <!-- ✅ 업체명 -->
        <p class="text-sm text-gray-500 mt-1">
          {{ item.vendor }}
        </p>

        <!-- ✅ 가격 -->
        <div class="mt-3">
          <h4
              v-if="item.discountRate > 0"
              class="text-lg font-bold text-red-600"
          >
            {{ item.discountedPrice.toLocaleString() }}원
            <span class="ml-2 text-sm text-gray-400 line-through">
              {{ item.price.toLocaleString() }}원
            </span>
            <span class="ml-2 text-sm text-green-500">
              ({{ item.discountRate }}% ↓)
            </span>
          </h4>
          <h4
              v-else
              class="text-lg font-medium text-gray-900"
          >
            {{ item.price.toLocaleString() }}원
          </h4>
        </div>

      </router-link>
    </div>
  </div>
</template>

<script setup>
import { defineProps, computed } from 'vue'

const props = defineProps({
  productList: Array,
  classList: String
})

const filteredList = computed(() =>
    props.productList
    .filter(item => item.id)
    .map(item => ({
      ...item,
      stockCount: Number(item.stockCount)
    }))
)

function getImageUrl(imageUrl) {
  if (!imageUrl || imageUrl === '') {
    return '/no-image.png'
  }

  return imageUrl // 전체 URL이면 그대로 사용
}

function onImageError(event) {
  event.target.src = '/no-image.png'
}

</script>
