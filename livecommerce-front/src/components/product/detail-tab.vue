<template>
  <div class="mt-10 border-t border-gray-300 pt-6">
    <div class="container-fluid max-w-[985px] mx-auto">

      <!-- 탭 메뉴 -->
      <div class="product-dtls-navtab border-b border-bdr-clr dark:border-bdr-clr-drk mb-6">
        <ul class="flex gap-6">
          <li
              @click="activeTab = 1"
              class="cursor-pointer pb-2 border-b-2"
              :class="activeTab === 1 ? 'text-primary font-semibold border-primary' : 'text-gray-500 border-transparent'"
          >
            상품 정보
          </li>
        </ul>
      </div>

      <!-- 상품 정보 -->
      <div v-if="activeTab === 1 && productDetail" class="bg-white shadow rounded-xl p-6">
        <ul class="space-y-4 text-base leading-relaxed text-gray-800">
          <li><strong>유통기한:</strong> {{ productDetail.expiryDate }}</li>
          <li><strong>승인일:</strong> {{ productDetail.approvalDate }}</li>
          <li><strong>섭취방법:</strong> {{ productDetail.howToTake }}</li>
          <li><strong>기능성:</strong> {{ productDetail.mainFunction }}</li>
          <li><strong>주의사항:</strong> {{ productDetail.precautions }}</li>
          <li><strong>보관방법:</strong> {{ productDetail.storageMethod }}</li>
          <li><strong>기준:</strong> {{ productDetail.standard }}</li>
          <li><strong>원재료:</strong> {{ productDetail.ingredients }}</li>
          <li><strong>제품명(식약처):</strong> {{ productDetail.productName }}</li>
        </ul>
      </div>

    </div>
  </div>
</template>

<script>
export default {
  props: {
    productDetail: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      activeTab: 1
    }
  }
}
</script>
