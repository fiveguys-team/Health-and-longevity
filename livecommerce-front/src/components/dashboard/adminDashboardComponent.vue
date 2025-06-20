<script setup>
// 여기에 실제 데이터 연동 로직을 추가할 수 있습니다

import SalesRevenue from "@/components/dashboard/currentMonthSales.vue";
import AnnualCumulativeSales from "@/components/dashboard/AnnualCumulativeSales.vue";
import VendorCount from "@/components/dashboard/vendorCount.vue";
import CurrentMonthOrders from "@/components/dashboard/currentMonthOrders.vue";
import CategoryRevenue from "@/components/dashboard/categoryRevenue.vue";
import VendorMaxViewers from "@/components/dashboard/vendorMaxViewers.vue";
</script>

<template>
  <div class="p-6 bg-gray-50 min-h-screen">
    <!-- 헤더 -->
    <br>
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-gray-800">관리자 대시보드</h1>
      <p class="text-gray-600 mt-2">전체 매출 및 운영 현황을 한눈에 확인하세요</p>
    </div>

    <!-- 주요 지표 카드 -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
      <sales-revenue />

      <div class="bg-white rounded-lg shadow-sm p-6 border-l-4 border-green-500">
        <AnnualCumulativeSales />
      </div>

      <div class="bg-white rounded-lg shadow-sm p-6 border-l-4 border-purple-500">
        <vendor-count />
      </div>

      <div class="bg-white rounded-lg shadow-sm p-6 border-l-4 border-orange-500">
        <current-month-orders />
      </div>
    </div>

    <!-- 데이터 섹션 -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
      <!-- 카테고리별 수익 -->
      <div class="bg-white rounded-lg shadow-sm p-6">
        <h3 class="text-lg font-semibold text-gray-800 mb-6">카테고리별 수익</h3>
        <category-revenue />
      </div>

      <!-- 입점업체별 최고 시청자 수 -->
      <div class="bg-white rounded-lg shadow-sm p-6">
        <h3 class="text-lg font-semibold text-gray-800 mb-6">이번달 입점업체별 최고 시청자 수</h3>
        <vendor-max-viewers />
      </div>
    </div>
  </div>
</template>

<style scoped>
/* 추가 스타일이 필요한 경우 여기에 작성 */
</style>