<script setup>

</script>

<template>
  <div class="bg-white rounded-lg shadow-sm p-6">
    <div class="flex items-center justify-between mb-6">
      <h3 class="text-lg font-semibold text-gray-800">월별 매출 추이</h3>
      <select class="text-sm border border-gray-300 rounded px-3 py-1">
        <option>2024년</option>
        <option>2023년</option>
      </select>
    </div>
    <div class="h-64 bg-gray-50 rounded-lg flex items-center justify-center">
      <div class="text-center text-gray-500">
        <svg class="w-16 h-16 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
        </svg>
        <p>월별 매출 차트</p>
        <p class="text-sm">Chart.js 또는 D3.js로 구현 예정</p>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>