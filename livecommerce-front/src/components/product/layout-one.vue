<template>
  <div :class="classList">
    <div v-for="(item, index) in productList" :key="index" class="group">
      <!-- 상품 이미지 + 링크 -->
      <div class="relative overflow-hidden">
        <router-link :to="`/product-details/${item.id}`">
          <img
              class="w-full transform group-hover:scale-110 duration-300"
              :src="item.image"
              alt="shop"
          />
        </router-link>

        <!-- 상품 태그 -->
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

      <!-- 상품 정보 -->
      <div class="md:px-2 lg:px-4 xl:px-6 lg:pt-6 pt-5 flex gap-4 md:gap-5 flex-col">
        <h4 class="font-medium leading-none dark:text-white text-lg">{{ item.price }}</h4>
        <p class="text-sm text-gray-500 dark:text-gray-300">{{ item.vendor }}</p>

        <div>
          <h5 class="font-normal dark:text-white text-xl leading-[1.5]">
            <router-link :to="`/product-details/${item.id}`" class="text-underline">
              {{ item.name }}
            </router-link>
          </h5>

          <div class="flex items-center gap-1">
            <div v-for="n in 5" :key="n" class="relative w-5 h-5">
              <!-- 빈 별 -->
              <i class="fa fa-star text-gray-300 absolute left-0 top-0 w-full h-full"></i>

              <!-- 채워진 별 -->
              <i
                  class="fa fa-star text-yellow-400 absolute left-0 top-0 h-full overflow-hidden"
                  :style="{ width: getStarFill(n, item.averageRating) + '%' }"
              ></i>
            </div>

            <span v-if="item.reviewCount > 0" class="ml-2 text-sm text-gray-500">
    ({{ item.reviewCount }}개 리뷰)
  </span>
            <span v-else class="ml-2 text-sm text-gray-400">(0)</span>
          </div>

        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { defineProps } from 'vue'

defineProps({
  productList: Array,
  classList: String
})

function getStarFill(starIndex, rating) {
  const fill = Math.min(Math.max(rating - (starIndex - 1), 0), 1);
  return fill * 100; // 0 ~ 100%
}
</script>
