<script setup>
import axios from "axios";
import {onMounted, ref, computed} from "vue";

const APPLICATION_SERVER_URL = process.env.NODE_ENV === 'production' ? ''
    : 'http://localhost:8080/';

const revenue = ref({});

// 매출 변화율에 따른 화살표와 색상 계산
const changeIndicator = computed(() => {
  const rate = revenue.value.revenueChangeRate;
  if (rate > 0) {
    return {
      arrow: '↗',
      color: 'text-green-600'
    };
  } else if (rate < 0) {
    return {
      arrow: '↘',
      color: 'text-red-600'
    };
  } else {
    return {
      arrow: '→',
      color: 'text-gray-600'
    };
  }
});

const currentMonthRevenue = async () => {
  try {
    const response = await axios.get(`${APPLICATION_SERVER_URL}api/admin/revenues/month`);
    revenue.value = response.data;
  } catch (error) {
    console.error('이번 달 매출 로드 실패:', error);
  }
};

onMounted( ()=> {
  currentMonthRevenue();
});

</script>

<template>
  <div class="bg-white rounded-lg shadow-sm p-6 border-l-4 border-blue-500">
    <div class="flex items-center justify-between">
      <div>
        <p class="text-sm font-medium text-gray-600">이번 달 매출</p>
        <p class="text-2xl font-bold text-gray-900">{{revenue.totalRevenue}}</p>
        <p class="text-sm mt-1" :class="changeIndicator.color">
          {{changeIndicator.arrow}} {{revenue.revenueChangeRate}}% 지난달 대비
        </p>
      </div>
      <div class="p-3 bg-blue-100 rounded-full">
        <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"></path>
        </svg>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>