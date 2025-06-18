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

const monthOrders = async () => {
  try {
    const response = await axios.get(`${APPLICATION_SERVER_URL}api/admin/revenues/annual`);
    revenue.value = response.data;
  } catch (error) {
    console.error('금년 매출액 로드 실패:', error);
  }
};

onMounted( ()=> {
  monthOrders();
});
</script>

<template>
  <div class="flex items-center justify-between">
    <div>
      <p class="text-sm font-medium text-gray-600">연간 누적 매출</p>
      <p class="text-2xl font-bold text-gray-900">{{ revenue.totalRevenue }}</p>
      <p class="text-sm mt-1" :class="changeIndicator.color">
        {{changeIndicator.arrow}} {{revenue.revenueChangeRate}}% 작년 대비
      </p>
    </div>
    <div class="p-3 bg-green-100 rounded-full">
      <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"></path>
      </svg>
    </div>
  </div>
</template>

<style scoped>

</style>