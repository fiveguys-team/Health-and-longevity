<template>
  <div>
    <NavbarOne />

    <!-- 헤더 영역 -->
    <div
        class="flex items-center gap-4 flex-wrap bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70"
        :style="{ backgroundImage: 'url(' + bg + ')' }"
    >
      <div class="text-center w-full">
        <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">
          결제 완료
        </h2>
        <ul
            class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4"
        >
          <li><router-link to="/">쇼핑하기</router-link></li>
          <li>/</li>
          <li class="text-primary">결제 완료</li>
        </ul>
      </div>
    </div>

    <!-- 본문 -->
    <div class="py-16 sm:py-24 bg-gray-50">
      <div class="max-w-xl mx-auto bg-white shadow-xl rounded-xl p-10 text-center">
        <h2 class="text-2xl font-bold text-green-600 mb-2">
          결제가 완료되었습니다!
        </h2>
        <p class="text-gray-600 mb-8">고객님의 결제가 안전하게 처리되었습니다.</p>

        <div v-if="paymentInfo.orderId" class="text-left space-y-3 text-sm sm:text-base">
          <p><strong>주문번호:</strong> {{ paymentInfo.orderId }}</p>
          <p><strong>상품명:</strong> {{ paymentInfo.orderName }}</p>
          <p><strong>결제수단:</strong> {{ paymentInfo.method }}</p>
          <p><strong>결제금액:</strong> {{ formatCurrency(paymentInfo.totalAmount) }}</p>
          <p><strong>승인일시:</strong> {{ formatDate(paymentInfo.approvedAt) }}</p>
        </div>
        <div v-else class="text-center text-gray-400 mt-6">
          결제 정보를 불러오는 중입니다...
        </div>

        <router-link
            to="/"
            class="mt-8 inline-block bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg transition"
        >
          홈으로 돌아가기
        </router-link>
      </div>
    </div>

    <FooterThree />
    <ScrollToTop />
  </div>
</template>

<script setup>
import NavbarOne from '@/components/navbar/navbar-one.vue'
import FooterThree from '@/components/footer/footer-three.vue'
import ScrollToTop from '@/components/scroll-to-top.vue'
import bg from '@/assets/img/shortcode/breadcumb.jpg'
import { useRoute, useRouter } from 'vue-router'
import { onMounted, ref } from 'vue'
import { confirmPayment } from '@/modules/payment/services/payment'

const route = useRoute()
const router = useRouter()
const paymentInfo = ref({})

// 포맷터
const formatCurrency = amount =>
    amount ? Number(amount).toLocaleString() + ' 원' : '-'
const formatDate = dateStr =>
    new Date(dateStr).toLocaleString()

onMounted(async () => {
  const { paymentKey, orderId, amount } = route.query
  const storedRaw = sessionStorage.getItem('paymentInfo')
  let stored

  // 1) 세션에 저장된 게 있으면 파싱
  if (storedRaw) {
    try {
      stored = JSON.parse(storedRaw)
    } catch {
      sessionStorage.removeItem('paymentInfo')
    }
  }

  // 2) 만약 저장된 주문이 있고, URL에 파라미터가 없거나(새로고침) URL의 orderId === 저장된 orderId 라면 → 복원만
  if (stored && (!orderId || orderId === stored.orderId)) {
    paymentInfo.value = stored
    return
  }

  // 3) 여기까지 왔으면 (1) 저장 없거나, (2) 새 결제(orderId 다름)이므로 세션 초기화
  sessionStorage.removeItem('paymentInfo')

  // 4) 쿼리 파라미터가 없으면 홈으로
  if (!paymentKey || !orderId || !amount) {
    router.replace({ name: 'home' })
    return
  }

  // 5) API 호출 후 세션에 저장
  try {
    const data = await confirmPayment({
      paymentKey,
      orderId,
      amount: Number(amount)
    })
    paymentInfo.value = data
    sessionStorage.setItem('paymentInfo', JSON.stringify(data))
  } catch (e) {
    console.error('❌ Toss 결제 승인 오류:', e)
    router.replace({ name: 'home' })
  }
})
</script>

<style scoped>
/* 추가적인 스타일이 필요하다면 여기에 */
</style>
