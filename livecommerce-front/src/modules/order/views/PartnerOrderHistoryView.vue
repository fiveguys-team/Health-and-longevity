<template>
  <div>
    <div class="w-full bg-white shadow-sm py-10 text-center border-b border-gray-200">
      <h2 class="text-2xl md:text-3xl font-bold text-title dark:text-white">입점업체 주문내역</h2>
      <p class="text-sm text-gray-500 mt-2">고객의 주문 상태를 확인하고 관리하세요.</p>
    </div>

    <div class="pt-15 pb-20" data-aos="fade-up">
      <!-- 중앙 정렬 -->
      <div class="flex justify-center">
        <!-- 최대 너비 제한 + 내부 콘텐츠 -->
        <div class="w-full max-w-[1720px] flex items-start gap-8 md:gap-12 2xl:gap-24 flex-col md:flex-row my-profile-navtab">

          <!-- 좌측: 프로필 탭 -->

          <!-- 우측: 주문 내역 리스트 -->
          <div class="flex-1 min-w-0 overflow-auto">
            <div class="bg-[#F8F8F9] dark:bg-dark-secondary p-5 sm:p-8 lg:p-[50px] order-history-table">
              <ul class="order-history space-y-10">
                <li v-for="order in paginatedOrders" :key="order.orderId" class="bg-white rounded-xl border border-bdr-clr dark:border-bdr-clr-drk p-5 shadow-sm">

                  <!-- 헤더 -->
                  <div class="flex items-center justify-between gap-5 border-t border-b border-bdr-clr py-2 font-semibold text-title dark:text-white">
                    <span class="w-[270px] sm:w-[310px] xl:w-[330px]">상품명</span>
                    <span class="w-[60px] text-center">수량</span>
                    <span class="w-[100px] text-center">상태</span>
                  </div>

                  <!-- 상품 목록 -->
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
                      <template v-if="!item.serviceCode">
                        <span class="text-green-600 font-semibold">정상구매</span>
                      </template>
                      <template v-else>
                        <div class="text-orange-600 font-semibold mb-1">
                          {{ formatStatus(item.serviceCode, item.serviceStatus) }}
                        </div>
                        <button
                            class="text-xs border border-gray-400 text-gray-700 px-2 py-1 rounded hover:bg-gray-100"
                            @click="openServiceDetailModal(item.orderItemId)">
                          상세보기
                        </button>
                      </template>
                    </div>
                  </div>

                  <!-- 하단: 날짜 & 총 결제금액 -->
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
                    :class="{ 'bg-primary text-white font-bold': page === currentPage }"
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
  </div>

  <div
      v-if="showModal"
      class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
  >


    <div class="bg-white rounded-xl shadow-lg p-6 w-[90%] max-w-md relative">
      <button class="absolute top-2 right-2 text-gray-500 hover:text-black" @click="closeModal">✕</button>
      <h3 class="text-xl font-semibold mb-4 text-title">  {{ serviceTitle }}</h3>
      <p class="text-sm text-gray-600 mb-3">
        <span class="font-semibold">사유:</span>
        {{ selectedReason }}
      </p>
      <div v-if="selectedImage" class="mb-4">
        <a :href="selectedImage" target="_blank" rel="noopener noreferrer">
          <img :src="selectedImage" alt="첨부 이미지" class="w-full rounded border cursor-pointer" />
        </a>
      </div>
      <div class="flex justify-end gap-3 mt-6">
<!--        <button class="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400 text-sm" @click="closeModal">닫기</button>-->
        <div class="mt-6 flex justify-end gap-4">
          <button
              class="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg"
              @click="approveService"
          >
            승인하기
          </button>
          <button
              class="px-4 py-2 bg-red-500 hover:bg-red-600 text-white rounded-lg"
              @click="rejectService"
          >
            반려하기
          </button>
        </div>
      </div>

    </div>
  </div>

</template>


<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import Aos from 'aos'
import { useAuthStore } from '@/modules/auth/stores/auth'
import {getVendorOrdersByUserId, updateServiceStatus} from '@/modules/order/services/orderApi'

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
  const codeLabelMap = { 'REFD': '환불', 'EXCH': '교환' }
  const statusLabelMap = { 'REQ': '요청', 'COMP': '완료', 'RJCT': '반려' }
  return `${codeLabelMap[serviceCode] || '처리'} ${statusLabelMap[serviceStatus] || serviceStatus}`
}

function formatDate(yyyymmddhhmmss) {
  if (!yyyymmddhhmmss) return ''
  return `${yyyymmddhhmmss.slice(0, 4)}-${yyyymmddhhmmss.slice(4, 6)}-${yyyymmddhhmmss.slice(6, 8)} ${yyyymmddhhmmss.slice(8, 10)}:${yyyymmddhhmmss.slice(10, 12)}:${yyyymmddhhmmss.slice(12, 14)}`
}


async function fetchOrderList() {
  try {
    const response = await getVendorOrdersByUserId(userId)
    orderList.value = [...response.data]

    console.log('📦 주문 데이터:', orderList.value)

    // 추가로 각 orderItem 내부 정보 확인
    orderList.value.forEach(order => {
      order.items.forEach(item => {
        console.log('🔍 주문 항목:', item)
      })
    })
  } catch (e) {
    console.error('❌ 입점업체 주문내역 조회 실패:', e)
  }
}

const showModal = ref(false)
const selectedReason = ref('')
const selectedImage = ref('')
const selectedItem = ref(null)

const serviceTitle = computed(() => {
  if (!selectedItem.value) return ''
  const code = selectedItem.value.serviceCode
  return code === 'REFD' ? '환불 요청' : code === 'EXCH' ? '교환 요청' : ''
})

function openServiceDetailModal(orderItemId) {
  for (const order of orderList.value) {
    const item = order.items.find(i => i.orderItemId === orderItemId)
    if (item && item.serviceCode) {
      selectedReason.value = item.reason || '사유 없음'
      selectedImage.value = item.img || ''
      showModal.value = true
      selectedItem.value = item
      break
    }
  }
}

function closeModal() {
  showModal.value = false
  selectedReason.value = ''
  selectedImage.value = ''
}

async function approveService() {
  try {
    await updateServiceStatus(selectedItem.value.orderItemId, 'COMP')
    alert('✅ 승인 완료!')
    closeModal()
    await fetchOrderList() // 리스트 갱신
  } catch (e) {
    console.error('승인 실패:', e)
    alert('❌ 승인 중 오류 발생')
  }
}

async function rejectService() {
  try {
    await updateServiceStatus(selectedItem.value.orderItemId, 'RJCT')
    alert('❌ 반려 완료!')
    closeModal()
    await fetchOrderList()
  } catch (e) {
    console.error('반려 실패:', e)
    alert('❌ 반려 중 오류 발생')
  }
}

onMounted(async () => {
  Aos.init()
  await fetchOrderList()
})

watch(currentPage, () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
})
</script>

<style scoped>
/* 추가적인 스타일이 필요한 경우 여기에 작성 */
</style>
