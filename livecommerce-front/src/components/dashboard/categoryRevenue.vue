<script setup>

import {onMounted, ref, computed} from "vue";
import axiosInstance from "@/api/axios";


const categoryData = ref([]);
const loading = ref(true);

// 카테고리별 색상 매핑
const categoryColors = {
  '혈압': { bg: 'bg-red-500', text: 'text-red-600' },
  '눈': { bg: 'bg-blue-500', text: 'text-blue-600' },
  '뼈/관절/연결성분': { bg: 'bg-purple-500', text: 'text-purple-600' },
  '장건강': { bg: 'bg-orange-500', text: 'text-orange-600' },
  '영양보충': { bg: 'bg-green-500', text: 'text-green-600' }
};

// 카테고리별 아이콘 매핑
const categoryIcons = {
  '혈압': '❤️',
  '눈': '👁️',
  '뼈/관절/연결성분': '🦴',
  '장건강': '🫀',
  '영양보충': '💊'
};

// 더미 데이터
const dummyData = [
  { categoryName: '혈압', revenue: 45200000, orderCount: 1250 },
  { categoryName: '눈', revenue: 36150000, orderCount: 980 },
  { categoryName: '뼈/관절/연결성분', revenue: 28400000, orderCount: 750 },
  { categoryName: '장건강', revenue: 17700000, orderCount: 520 },
  { categoryName: '영양보충', revenue: 15800000, orderCount: 420 }
];

// 총 매출 계산
const totalRevenue = computed(() => {
  return categoryData.value.reduce((sum, category) => sum + (category.revenue || 0), 0);
});

// 퍼센트 계산
const getPercentage = (revenue) => {
  if (totalRevenue.value === 0) return 0;
  return Math.round((revenue / totalRevenue.value) * 100);
};

// 금액 포맷팅
const formatCurrency = (amount) => {
  return new Intl.NumberFormat('ko-KR').format(amount);
};

const fetchCategoryRevenue = async () => {
  try {
    loading.value = true;
    const response = await axiosInstance.get(`/api/admin/revenues/category`);
    
    // 데이터가 없거나 빈 배열인 경우 더미 데이터 사용
    if (!response.data || response.data.length === 0) {
      console.log('실제 데이터가 없어서 더미 데이터를 사용합니다.');
      categoryData.value = dummyData;
    } else {
      categoryData.value = response.data;
    }
  } catch (error) {
    console.error('카테고리별 매출 로드 실패:', error);
    console.log('에러로 인해 더미 데이터를 사용합니다.');
    // 에러 시 더미 데이터 사용
    categoryData.value = dummyData;
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  fetchCategoryRevenue();
});
</script>

<template>
  <div class="space-y-4">
    <!-- 로딩 상태 -->
    <div v-if="loading" class="flex justify-center items-center py-8">
      <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
    </div>

    <!-- 카테고리별 매출 목록 -->
    <div v-else class="space-y-4">
      <!-- 더미 데이터 표시 알림 -->
      <div v-if="categoryData.length > 0 && categoryData[0].categoryName === '혈압' && categoryData[0].revenue === 45200000" 
           class="bg-yellow-50 border border-yellow-200 rounded-lg p-3 mb-4">
        <div class="flex items-center">
          <div class="text-yellow-600 mr-2">⚠️</div>
          <div class="text-sm text-yellow-800">
            <strong>더미 데이터 표시 중</strong> - 실제 매출 데이터가 없어서 샘플 데이터를 보여드립니다.
          </div>
        </div>
      </div>

      <div 
        v-for="(category, index) in categoryData" 
        :key="category.categoryName"
        class="relative group hover:bg-gray-50 rounded-lg p-3 transition-all duration-200"
      >
        <div class="flex items-center justify-between">
          <!-- 카테고리 정보 -->
          <div class="flex items-center space-x-3">
            <!-- 순위 배지 -->
            <div class="flex-shrink-0">
              <div 
                v-if="index < 3" 
                class="w-8 h-8 rounded-full flex items-center justify-center text-white text-sm font-bold"
                :class="{
                  'bg-yellow-500': index === 0,
                  'bg-gray-400': index === 1,
                  'bg-orange-500': index === 2
                }"
              >
                {{ index + 1 }}
              </div>
              <div v-else class="w-8 h-8 rounded-full flex items-center justify-center text-gray-500 text-sm font-bold border-2 border-gray-300">
                {{ index + 1 }}
              </div>
            </div>

            <!-- 카테고리 아이콘 -->
            <div class="text-2xl">
              {{ categoryIcons[category.categoryName] || '📦' }}
            </div>

            <!-- 카테고리명 -->
            <div>
              <span class="text-sm font-semibold text-gray-800">{{ category.categoryName }}</span>
              <div class="text-xs text-gray-500">{{ category.orderCount }}건 주문</div>
            </div>
          </div>

          <!-- 매출 정보 -->
          <div class="text-right">
            <div class="text-sm font-bold text-gray-900">
              ₩{{ formatCurrency(category.revenue) }}
            </div>
            <div class="text-xs text-gray-500">
              {{ getPercentage(category.revenue) }}%
            </div>
          </div>
        </div>

        <!-- 진행률 바 -->
        <div class="mt-3">
          <div class="w-full bg-gray-200 rounded-full h-2">
            <div 
              class="h-2 rounded-full transition-all duration-500 ease-out"
              :class="categoryColors[category.categoryName]?.bg || 'bg-gray-500'"
              :style="{ width: getPercentage(category.revenue) + '%' }"
            ></div>
          </div>
        </div>

        <!-- 호버 시 추가 정보 -->
        <div class="absolute inset-0 bg-blue-50 rounded-lg opacity-0 group-hover:opacity-100 transition-opacity duration-200 pointer-events-none">
          <div class="p-3">
            <div class="text-xs text-blue-600 font-medium">
              평균 주문 금액: ₩{{ formatCurrency(Math.round(category.revenue / category.orderCount)) }}
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 총 매출 요약 -->
    <div class="mt-6 pt-4 border-t border-gray-200">
      <div class="flex justify-between items-center">
        <span class="text-sm font-medium text-gray-600">총 매출</span>
        <span class="text-lg font-bold text-gray-900">₩{{ formatCurrency(totalRevenue) }}</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* 추가 스타일 */
.group:hover .group-hover\:opacity-100 {
  opacity: 1;
}
</style>