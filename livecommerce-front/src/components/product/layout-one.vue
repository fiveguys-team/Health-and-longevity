<template>
  <div :class="classList">
    <div
        v-for="(item, index) in filteredList"
        :key="index"
        class="group bg-white border rounded-xl shadow-md hover:shadow-xl hover:scale-105 transform transition duration-300 p-6"
    >
      <!-- ✅ 상품 이미지 + 링크 -->
      <div class="relative overflow-hidden">
        <router-link :to="`/product-details/${item.id}`">
          <img
              class="w-full transform group-hover:scale-110 duration-300"
              :src="getImageUrl(item.image)"
              @error="onImageError"
              alt="shop"
          />
        </router-link>

        <!-- ✅ 품절 배지 -->
        <span
            v-if="item.stockCount === 0"
            class="absolute top-2 left-2 bg-red-500 text-white text-xs px-2 py-1 rounded z-10"
        >
          품절
        </span>

        <!-- ✅ 할인 뱃지 -->
        <span
            v-if="item.discountRate && item.discountRate > 0"
            class="absolute top-2 right-2 bg-yellow-400 text-black text-xs px-2 py-1 rounded z-10"
        >
          -{{ item.discountRate }}%
        </span>

        <!-- ✅ 상품 태그 -->
        <div
            v-if="item.tag"
            class="absolute z-10 top-7 left-7 pt-[10px] pb-2 px-3 rounded-[30px] font-primary text-[14px] text-white font-semibold leading-none"
            :class="{
            'bg-[#1CB28E]': item.tag === 'Hot Sale',
            'bg-[#9739E1]': item.tag === 'NEW',
            'bg-[#E13939]': item.tag === '10% OFF'
          }"
        >
          {{ item.tag }}
        </div>
      </div>

      <!-- ✅ 상품 정보 -->
      <div class="md:px-2 lg:px-4 xl:px-6 lg:pt-6 pt-5 flex gap-4 md:gap-5 flex-col">
        <h2 class="text-2xl font-semibold dark:text-white leading-snug">
          <router-link :to="`/product-details/${item.id}`" class="text-underline">
            {{ item.name }}
          </router-link>
        </h2>

        <p class="text-sm text-gray-500 dark:text-gray-300">
          {{ item.vendor }}
        </p>

        <!-- ✅ 가격 표시 영역 -->
        <div class="flex gap-2 items-baseline mt-2">
          <span
              v-if="item.discountRate && item.discountedPrice"
              class="text-sm text-gray-400 line-through"
          >
            {{ item.price.toLocaleString() }}원
          </span>
          <span class="font-medium text-lg text-black">
            {{
              item.discountRate && item.discountedPrice
                  ? item.discountedPrice.toLocaleString()
                  : item.price.toLocaleString()
            }}원
          </span>
        </div>

        <!-- ✅ 리뷰 별점 (미구현 상태) -->
        <div class="flex items-center gap-1 mt-1">
          <div
              v-for="n in 5"
              :key="n"
              class="relative w-5 h-5"
          >
            <i class="fa fa-star text-gray-300 absolute left-0 top-0 w-full h-full"></i>
            <i
                class="fa fa-star text-yellow-400 absolute left-0 top-0 h-full overflow-hidden"
                style="width: 0%"
            ></i>
          </div>
          <span class="ml-2 text-sm text-gray-400">(0)</span>
        </div>
      </div>
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
    props.productList.filter(item => item.id)
)

function getImageUrl(imageName) {
  if (!imageName) return '/no-image.png' // 이미지 없으면 대체 이미지
  return `/uploads/images/${imageName}`
}

function onImageError(event) {
  event.target.src = '/no-image.png'
}
</script>
