<template>
  <div>
    <NavbarOne />

    <!-- 헤더 영역 -->
    <div class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70" :style="{ backgroundImage: 'url(' + bg + ')' }">
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

          <div class="w-full md:flex-1 overflow-auto">
            <div class="bg-[#F8F8F9] dark:bg-dark-secondary p-5 sm:p-8 lg:p-[50px] order-history-table">
              <ul class="order-history space-y-10">
                <li v-for="order in paginatedOrders" :key="order.orderId" class="bg-white rounded-xl border border-bdr-clr dark:border-bdr-clr-drk p-5 shadow-sm">
                  <div class="flex items-center justify-between gap-5 border-t border-b border-bdr-clr py-2 font-semibold text-title dark:text-white">
                    <span class="w-[270px] sm:w-[310px] xl:w-[330px]">상품명</span>
                    <span class="w-[60px] text-center">수량</span>
                    <span class="w-[100px] text-center">상태</span>
                  </div>

                  <div v-for="item in order.items" :key="item.orderItemId" class="flex items-center justify-between gap-5 py-4 border-b border-dashed border-gray-200">
                    <div class="flex items-start gap-4 w-[270px] sm:w-[310px] xl:w-[330px]">
                      <img :src="item.productImage" class="w-16 h-16 object-cover rounded border" />
                      <div class="text-sm font-medium text-title dark:text-white">
                        {{ item.productName }}
                        <div class="mt-1 text-xs text-gray-500">
                          결제금액: {{ item.paidAmount.toLocaleString() }}원
                        </div>
                      </div>
                    </div>
                    <div class="text-sm font-semibold w-[60px] text-center">{{ item.quantity }}개</div>
                    <div class="w-[100px] text-center">
                      <div v-if="!item.serviceCode" class="text-green-600 font-semibold">
                        <div>구매 완료</div>
                        <div class="mt-2 flex flex-col items-center space-y-1">
                          <button @click="openModal('교환', item)" class="text-xs text-black border border-gray-300 px-2 py-1 rounded hover:bg-gray-100 w-fit">교환요청</button>
                          <button @click="openModal('환불', item)" class="text-xs text-black border border-gray-300 px-2 py-1 rounded hover:bg-gray-100 w-fit">환불요청</button>
                        </div>
                      </div>
                      <div v-else class="text-orange-600 font-semibold">
                        {{ formatStatus(item.serviceCode, item.serviceStatus) }}
                      </div>
                    </div>
                  </div>

                  <div class="flex justify-between items-center mt-3 text-base font-semibold text-title dark:text-white">
                    <span>주문일시: {{ formatDate(order.orderDate) }}</span>
                    <span>총 결제금액: <span class="text-primary ml-2">{{ order.totalAmount.toLocaleString() }}원</span></span>
                  </div>
                </li>
              </ul>

              <!-- 페이지네이션 -->
              <div class="flex justify-center mt-10 gap-2 text-title dark:text-white">
                <button class="px-3 py-1 border rounded disabled:opacity-50" :disabled="currentPage === 1" @click="currentPage--">이전</button>
                <button
                    v-for="page in totalPages"
                    :key="page"
                    class="px-3 py-1 border rounded"
                    :class="{ 'bg-primary text-white font-bold': page === currentPage, 'bg-white': page !== currentPage }"
                    @click="currentPage = page">
                  {{ page }}
                </button>
                <button class="px-3 py-1 border rounded disabled:opacity-50" :disabled="currentPage === totalPages" @click="currentPage++">다음</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <FooterThree />
    <ScrollToTop />
    <RequestModal :visible="showModal" :type="requestType" @close="closeModal" @submit="submitRequest" />
  </div>
</template>

<script setup>
import { onMounted, ref, computed, watch } from 'vue'
import NavbarOne from '@/components/navbar/navbar-one.vue'
import ProfileTab from '@/components/profile-tab.vue'
import FooterThree from '@/components/footer/footer-three.vue'
import ScrollToTop from '@/components/scroll-to-top.vue'
import { useAuthStore } from '@/modules/auth/stores/auth'
import Aos from 'aos'
import { getOrderHistoryByUserId, requestService } from '@/modules/order/services/orderApi'
import RequestModal from '@/modules/order/components/RequestModal.vue'
import {uploadFileToNcp} from "@/data/uploadApi";

const showModal = ref(false)
const requestType = ref('')
const selectedItem = ref(null)

const authStore = useAuthStore()
const userId = authStore.id
const orderList = ref([])

const currentPage = ref(1)
const itemsPerPage = 5
const paginatedOrders = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  return orderList.value.slice(start, start + itemsPerPage)
})
const totalPages = computed(() => Math.ceil(orderList.value.length / itemsPerPage))

function formatStatus(serviceCode, serviceStatus) {
  if (!serviceCode) return '정상구매'

  const codeLabelMap = {
    'REFD': '환불',
    'EXCH': '교환'
  }

  const statusLabelMap = {
    'REQ': '요청',
    'COMP': '완료'
  }

  const label = codeLabelMap[serviceCode] || '요청'
  const status = statusLabelMap[serviceStatus] || serviceStatus

  return `${label} ${status}`
}

function formatDate(yyyymmddhhmmss) {
  if (!yyyymmddhhmmss) return ''
  return `${yyyymmddhhmmss.slice(0, 4)}-${yyyymmddhhmmss.slice(4, 6)}-${yyyymmddhhmmss.slice(6, 8)} ${yyyymmddhhmmss.slice(8, 10)}:${yyyymmddhhmmss.slice(10, 12)}:${yyyymmddhhmmss.slice(12, 14)}`
}

function openModal(type, item) {
  requestType.value = type
  selectedItem.value = item
  showModal.value = true
}

function closeModal() {
  showModal.value = false
  selectedItem.value = null
}

async function submitRequest({ reason, file, type }) {
  if (!selectedItem.value) return

  if (!reason || reason.trim() === '') {
    alert('요청 사유를 입력해주세요.')
    return
  }

  let imgUrl = ''
  if (file) {
    try {
      const uploadResult = await uploadFileToNcp(file, userId)
      imgUrl = uploadResult.url || uploadResult // 응답 형식에 맞게 수정
    } catch (e) {
      console.error('❌ 이미지 업로드 실패:', e)
      alert('이미지 업로드에 실패했습니다.')
      return
    }
  }

  const payload = {
    orderItemId: selectedItem.value.orderItemId,
    userId: userId,
    serviceCode: type === '환불' ? 'REFD' : 'EXCH',
    reason: reason.trim(),
    img: imgUrl
  }

  console.log('🔥 payload 보내기 직전:', payload)

  try {
    await requestService(payload)
    alert(`${type} 요청이 정상적으로 등록되었습니다.`)
    await fetchOrderList()
    closeModal()
  } catch (e) {
    console.error('❌ 요청 실패:', e)
    alert(`${type} 요청 중 오류가 발생했습니다.`)
  }
}


async function fetchOrderList() {
  try {
    const response = await getOrderHistoryByUserId(userId)
    orderList.value = [...response.data]
  } catch (e) {
    console.error('❌ 주문내역 요청 실패:', e)
  }
}

onMounted(async () => {
  Aos.init()
  try {
    const response = await getOrderHistoryByUserId(userId)
    orderList.value = [...response.data]
  } catch (e) {
    console.error('❌ 주문내역 요청 실패:', e)
  }
})

watch(currentPage, () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
})
</script>
