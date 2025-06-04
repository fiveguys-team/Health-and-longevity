<script setup>
import { ref } from 'vue';
import storeNavbar from '@/components/dashboard/storeNavbar.vue';

const selectedDate = ref('');

const shows = ref([
  { title: '방송 제목 A', date: '' },
  { title: '방송 제목 B', date: '' },
  { title: '방송 제목 F', date: '' },
  { title: '방송 제목 C', date: '' },
  { title: '방송 제목 E', date: '' },
  { title: '방송 제목 D', date: '' },
]);
</script>
<template>
  <store-navbar/>
<div>입점업체 레포트</div>
  <div class="p-4 max-w-3xl mx-auto">
    <label for="date" class="mr-2 font-semibold">날짜 선택</label>
    <input type="date" id="date" v-model="selectedDate" class="border px-2 py-1 mb-4" />

    <div class="border p-4 grid grid-cols-3 gap-4">
      <div v-for="(item, index) in shows" :key="index" class="bg-white shadow-md p-4 flex flex-col justify-between">
        <h3 class="text-xl font-bold mb-2">{{ item.title }}</h3>
        <div class="text-right text-sm text-gray-600">{{ item.date || '날짜' }}</div>
      </div>
    </div>
  </div>
</template>

<style scoped>
body {
  background: linear-gradient(to right, #eee, #ddd);
}
</style>