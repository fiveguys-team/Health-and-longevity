<script setup>

import axios from "axios";
import {onMounted, ref} from "vue";

const APPLICATION_SERVER_URL = process.env.NODE_ENV === 'production' ? ''
    : 'http://localhost:8080/';

const vendors = ref('');

const vendorCount = async () => {
  try {
    const response = await axios.get(`${APPLICATION_SERVER_URL}api/admin/vendors/count`);
    vendors.value = response.data;
  } catch (error) {
    console.error('이번달 주문 로드 실패:', error);
  }
};

onMounted( ()=> {
  vendorCount();
});
</script>

<template>
  <div class="flex items-center justify-between">
    <div>
      <p class="text-sm font-medium text-gray-600">활성 입점업체</p>
      <p class="text-2xl font-bold text-gray-900">{{ vendors }} 개</p>
    </div>
    <div class="p-3 bg-purple-100 rounded-full">
      <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path>
      </svg>
    </div>
  </div>
</template>

<style scoped>

</style>