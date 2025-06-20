<template>
  <div>
    <NavbarOne />

    <!-- 헤더 영역 -->
    <div class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70" :style="{backgroundImage:'url(' + bg + ')'}">
      <div class="text-center w-full">
        <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">주문 내역</h2>
        <ul class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4">
          <li><router-link to="/">홈</router-link></li>
          <li>/</li>
          <li class="text-primary">주문내역</li>
        </ul>
      </div>
    </div>

    <!-- 본문 -->
    <div class="s-py-100" data-aos="fade-up">
      <div class="container-fluid">
        <div class="max-w-[1720px] mx-auto flex items-start gap-8 md:gap-12 2xl:gap-24 flex-col md:flex-row my-profile-navtab">
          <div class="w-full md:w-[200px] lg:w-[300px] flex-none">
            <ProfileTab />
          </div>

          <div class="w-full md:w-auto md:flex-1 overflow-auto">
            <div class="bg-[#F8F8F9] dark:bg-dark-secondary p-5 sm:p-8 lg:p-[50px] order-history-table">
              <ul class="order-history space-y-10">
                <li v-for="order in paginatedOrders" :key="order.orderId" class="bg-white rounded-xl border border-bdr-clr dark:border-bdr-clr-drk p-5 shadow-sm">

                  <!-- 항목 헤더 -->
                  <div class="flex items-center justify-between gap-5 border-t border-b border-bdr-clr py-2 font-semibold text-title dark:text-white">
                    <span class="w-[270px] sm:w-[310px] xl:w-[330px]">상품명</span>
                    <span class="w-[60px] text-center">수량</span>
                    <span class="w-[100px] text-center">상태</span>
                  </div>

                  <!-- 상품 리스트 -->
                  <div v-for="item in order.items" :key="item.orderItemId" class="flex items-center justify-between gap-5 py-4 border-b border-dashed border-gray-200">
                    <div class="flex items-center gap-4 w-[270px] sm:w-[310px] xl:w-[330px]">
                      <img :src="item.productImage" class="w-16 h-16 object-cover rounded border" />
                      <div class="text-sm font-medium text-title dark:text-white">{{ item.productName }}</div>
                    </div>
                    <div class="text-sm font-semibold w-[60px] text-center">{{ item.quantity }}개</div>
                    <div class="w-[100px] text-center">
                      <span v-if="!item.serviceCode" class="text-green-600 font-semibold">구매 완료</span>
                      <span v-else class="text-orange-600 font-semibold">{{ formatStatus(item.serviceCode, item.serviceStatus) }}</span>
                    </div>
                  </div>

                  <!-- 주문 요약 -->
                  <div class="flex justify-between items-center mt-3 text-base font-semibold text-title dark:text-white">
                    <span>주문일시: {{ formatDate(order.orderDate) }}</span>
                    <span>총 결제금액: <span class="text-primary ml-2">{{ order.totalAmount.toLocaleString() }}원</span></span>
                  </div>

                </li>
              </ul>

              <!-- 페이지네이션 -->
              <div class="flex justify-center mt-10 gap-2 text-title dark:text-white">
                <button
                    class="px-3 py-1 border rounded disabled:opacity-50"
                    :disabled="currentPage === 1"
                    @click="currentPage--"
                >
                  이전
                </button>

                <button
                    v-for="page in totalPages"
                    :key="page"
                    class="px-3 py-1 border rounded"
                    :class="{
                    'bg-primary text-white font-bold': page === currentPage,
                    'bg-white': page !== currentPage
                  }"
                    @click="currentPage = page"
                >
                  {{ page }}
                </button>

                <button
                    class="px-3 py-1 border rounded disabled:opacity-50"
                    :disabled="currentPage === totalPages"
                    @click="currentPage++"
                >
                  다음
                </button>
              </div>

            </div>
          </div>
        </div>
      </div>
    </div>

    <FooterThree />
    <ScrollToTop />
  </div>
</template>

<script setup>
import { onMounted, ref, computed } from 'vue'
import NavbarOne from '@/components/navbar/navbar-one.vue'
import ProfileTab from '@/components/profile-tab.vue'
import FooterThree from '@/components/footer/footer-three.vue'
import ScrollToTop from '@/components/scroll-to-top.vue'
import { useAuthStore } from "@/modules/auth/stores/auth"
import Aos from 'aos'
import { getOrderHistoryByUserId } from "@/modules/order/services/orderApi"

const authStore = useAuthStore()
const userId = authStore.id
const orderList = ref([])

// 페이지네이션 상태
const currentPage = ref(1)
const itemsPerPage = 5

const paginatedOrders = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  return orderList.value.slice(start, start + itemsPerPage)
})

const totalPages = computed(() => {
  return Math.ceil(orderList.value.length / itemsPerPage)
})

function formatStatus(serviceCode, serviceStatus) {
  if (!serviceCode) return '정상구매'
  const label = {
    'REFD': '환불',
    'EXCH': '교환'
  }[serviceCode] || '요청'

  return `${label} ${serviceStatus}`
}

function formatDate(yyyymmddhhmmss) {
  if (!yyyymmddhhmmss) return ''
  return `${yyyymmddhhmmss.slice(0, 4)}-${yyyymmddhhmmss.slice(4, 6)}-${yyyymmddhhmmss.slice(6, 8)} ` +
      `${yyyymmddhhmmss.slice(8, 10)}:${yyyymmddhhmmss.slice(10, 12)}:${yyyymmddhhmmss.slice(12, 14)}`
}

onMounted(async () => {
  Aos.init()
  const response = await getOrderHistoryByUserId(userId)
  orderList.value = response.data
})

</script>
