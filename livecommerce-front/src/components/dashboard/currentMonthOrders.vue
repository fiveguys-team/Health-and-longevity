<script setup>
import axios from "axios";
import {onMounted, ref, computed} from "vue";

const APPLICATION_SERVER_URL = process.env.NODE_ENV === 'production' ? ''
    : 'http://localhost:8080/';

const revenue = ref({});

// 주문 변화율에 따른 화살표와 색상 계산
const changeIndicator = computed(() => {
  const rate = revenue.value.orderCountChangeRate;
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
    const response = await axios.get(`${APPLICATION_SERVER_URL}api/admin/monthOrders`);
    revenue.value = response.data;
  } catch (error) {
    console.error('이번달 주문 로드 실패:', error);
  }
};

onMounted( ()=> {
  monthOrders();
});
</script>

<template>
  <div class="flex items-center justify-between">
    <div>
      <p class="text-sm font-medium text-gray-600">이번 달 주문</p>
      <p class="text-2xl font-bold text-gray-900">{{ revenue.orderCount }}건</p>
      <p class="text-sm mt-1" :class="changeIndicator.color">
        {{changeIndicator.arrow}} {{revenue.orderCountChangeRate}}% 지난달 대비
      </p>
    </div>
    <div class="p-3 bg-orange-100 rounded-full">
      <svg class="w-6 h-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path>
      </svg>
    </div>
  </div>
</template>

<style scoped>

</style>