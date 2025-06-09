<template>
  <div class="container-fluid">
    <div class="max-w-[985px] mx-auto">
      <div class="product-dtls-navtab border-y border-bdr-clr dark:border-bdr-clr-drk">
        <ul
            id="user-nav-tabs"
            class="text-title dark:text-white text-base sm:text-lg lg:text-xl flex leading-none gap-3 sm:gap-6 md:gap-12 lg:gap-24 justify-between sm:justify-start max-w-md sm:max-w-full">
          <li
              @click="activeTab = 1"
              class="py-3 sm:py-5 relative before:absolute before:w-full before:h-[1px] before:bg-title before:top-full before:left-0 before:duration-300 dark:before:bg-white before:opacity-0"
              :class="activeTab === 1 ? 'active' : ''">
            <router-link to="#" class="duration-300 hover:text-primary">상품 정보</router-link>
          </li>
          <li
              @click="activeTab = 2"
              class="py-3 sm:py-5 relative before:absolute before:w-full before:h-[1px] before:bg-title before:top-full before:left-0 before:duration-300 dark:before:bg-white before:opacity-0"
              :class="activeTab === 2 ? 'active' : ''">
            <router-link to="#" class="duration-300 hover:text-primary">리뷰</router-link>
          </li>
        </ul>
      </div>

      <div id="content" class="mt-5 sm:mt-8 lg:mt-12 mx-0 sm:mr-5 md:mr-8 lg:mr-12">
        <!-- 상품 정보 탭 -->
        <div v-if="activeTab === 1 && data?.info">
          <ul class="space-y-2 text-base leading-relaxed">
            <li v-for="(value, key) in data.info" :key="key">
              <span class="font-semibold text-title dark:text-white">{{ key }}:</span>
              <span class="ml-2 text-gray-700 dark:text-white">{{ value }}</span>
            </li>
          </ul>
        </div>

        <!-- 리뷰 탭 -->
        <div v-if="activeTab === 2">
          <!-- 평균 별점 -->
          <div class="mb-6">
            <h4 class="text-lg font-semibold text-title dark:text-white">리뷰 총점</h4>
            <div class="flex items-center gap-2 mt-2">
              <span class="text-2xl font-bold text-yellow-500">{{ averageRating.toFixed(1) }}</span>
              <ul class="flex items-center gap-[2px]">
                <li v-for="n in 5" :key="n">
                  <div class="relative w-5 h-5">
                    <i class="fa-solid fa-star text-gray-300 absolute top-0 left-0 w-full h-full"></i>
                    <i
                        class="fa-solid fa-star text-yellow-400 absolute top-0 left-0 overflow-hidden"
                        :style="{ width: getStarWidth(averageRating, n) }"></i>
                  </div>
                </li>
              </ul>
              <span class="ml-2 text-sm text-gray-500 dark:text-gray-400">({{ reviewList.length }}개 리뷰)</span>
            </div>
          </div>

          <!-- 개별 리뷰 -->
          <div v-for="(review, index) in reviewList" :key="index" class="mb-10 border p-4 rounded-lg">
            <div class="flex justify-between items-center mb-2">
              <div class="flex gap-2 items-center">
                <span>{{ review.name }}</span>
                <ul class="flex items-center gap-[2px] text-yellow-400">
                  <li v-for="n in 5" :key="n">
                    <div class="relative w-4 h-4">
                      <i class="fa-solid fa-star text-gray-300 absolute top-0 left-0 w-full h-full"></i>
                      <i
                          class="fa-solid fa-star text-yellow-400 absolute top-0 left-0 overflow-hidden"
                          :style="{ width: getStarWidth(review.rating, n) }"></i>
                    </div>
                  </li>
                </ul>
              </div>
              <span class="text-sm text-gray-400">{{ review.date }}</span>
            </div>
            <div class="mb-1 text-sm text-gray-600">구매 상품: {{ review.product }}</div>
            <p class="mb-3">{{ review.desc }}</p>

            <!-- 입점업체만 보게 하기 위한 조건 처리 -->
            <div v-if="isVendor" class="flex flex-col">
              <textarea
                  class="w-full h-24 border p-2 mb-2"
                  placeholder="답변을 입력하세요..."
                  v-model="review.reply"
              ></textarea>
              <div class="flex gap-2">
                <button class="bg-primary text-white px-4 py-1 rounded">답변 등록</button>
                <button class="bg-red-500 text-white px-4 py-1 rounded">리뷰 삭제</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import { productList, detailReview } from '@/data/data'

const route = useRoute()
const productId = parseInt(route.params.id)
const data = ref(null)
const activeTab = ref(1)

// 입점업체 여부 설정
const isVendor = false

const reviewList = ref([]);

onMounted(() => {
  data.value = productList.find((p) => p.id === productId);

  if (data.value) {
    reviewList.value = detailReview
        .filter((r) => r.product === data.value.name)
        .map((r) => ({
          ...r,
          reply: '',
        }));
  }
});

const averageRating = computed(() => {
  if (!reviewList.value.length) return 0
  const total = reviewList.value.reduce((sum, r) => sum + r.rating, 0)
  return total / reviewList.value.length
})

function getStarWidth(rating, index) {
  const fill = Math.min(Math.max(rating - (index - 1), 0), 1)
  return `${fill * 100}%`
}
</script>
