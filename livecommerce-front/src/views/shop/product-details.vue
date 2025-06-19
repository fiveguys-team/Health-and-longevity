<template>
  <div>
    <NavbarOne />

    <!-- ✅ 상품 경로 (breadcrumb) -->
    <div
        class="flex items-center gap-4 flex-wrap bg-overlay py-16 sm:py-20 before:bg-title before:bg-opacity-70"
        :style="bg ? { backgroundImage: `url(${bg})` } : { backgroundColor: '#333' }"
    >
      <div class="text-center w-full">
        <h2 class="text-white text-4xl md:text-5xl font-semibold leading-none">
          {{ data?.name || '상품명' }}
        </h2>
        <ul class="flex justify-center gap-2 text-base md:text-lg text-white mt-4">
          <li><router-link to="/shop-v1">고민별</router-link></li>
          <li>/</li>
          <li>
            <router-link
                :to="`/category/${encodeURIComponent(data?.category || '')}`"
                class="capitalize"
            >
              {{ data?.category || '카테고리' }}
            </router-link>
          </li>
          <li>/</li>
          <li class="text-primary">{{ data?.name || '상품명' }}</li>
        </ul>
      </div>
    </div>

    <div class="s-py-50" data-aos="fade-up">
      <div class="container-fluid">
        <div class="max-w-[1720px] mx-auto flex justify-between gap-10 flex-col lg:flex-row">
          <div class="w-full lg:w-[58%]">
            <div class="relative product-dtls-wrapper">
              <div class="relative">
                <div
                    v-if="data?.discountRate > 0"
                    class="absolute top-4 right-4 bg-green-600 text-white text-base font-bold px-3 py-1 rounded z-50 shadow-lg"
                >
                  할인중
                </div>

                <img
                    :src="getImageUrl(data?.productImage)"
                    alt="product"
                    class="w-full"
                    @error="onImageError"
                />
                <!-- ✅ 품절일 경우 오버레이 강조 -->
                <div
                    v-if="data?.stockCount === 0"
                    class="absolute inset-0 bg-black bg-opacity-60 flex items-center justify-center z-50"
                >
                  <span class="text-white text-4xl font-extrabold animate-pulse tracking-wider">
                    품절
                  </span>
                </div>
              </div>
            </div>
          </div>

          <div class="lg:max-w-[635px] w-full">
            <div class="pb-4 sm:pb-6 border-b border-bdr-clr dark:border-bdr-clr-drk">
              <div v-if="data">
                <h2 class="font-semibold leading-none">{{ data.name }}</h2>
                <p class="sm:text-lg mt-5 md:mt-7">
                  <strong>업체:</strong> {{ data.vendor }}
                </p>
              </div>
              <div v-else class="text-gray-500 p-10 text-center">상품 정보를 불러오는 중입니다...</div>
            </div>

            <div class="flex gap-4 items-center mt-[15px]">
              <template v-if="typeof data?.discountRate === 'number' && data.discountRate > 0">
                <!-- 원래 가격 -->
                <span class="text-lg sm:text-xl line-through text-title dark:text-white">
      ₩{{ data?.price != null ? data.price.toLocaleString() : '' }}
    </span>
                <!-- 할인된 가격 -->
                <span class="text-2xl sm:text-3xl text-primary">
      ₩{{ data?.discountedPrice != null ? data.discountedPrice.toLocaleString() : '' }}
    </span>
                <!-- 할인 배지 -->
                <span class="ml-2 px-2 py-1 text-sm bg-[#E13939] text-white rounded-md">
      -{{ data.discountRate }}%
    </span>
              </template>

              <template v-else>
                <!-- 할인 없을 경우 그냥 현재 가격만 -->
                <span class="text-2xl sm:text-3xl text-primary">
      ₩{{ data?.price != null ? data.price.toLocaleString() : '' }}
    </span>
              </template>
            </div>


            <!-- 🔽 기존 얼마 남지 않았어요 + 품절 텍스트 부분 수정 -->
            <div class="mt-5 md:mt-7 flex items-center gap-4 flex-wrap">
              <template v-if="data?.stockCount === 0">
                <p class="text-red-600 font-semibold flex items-center gap-2">
                  <span>🔒</span> 현재 품절된 상품입니다.
                </p>
              </template>
              <template v-else-if="data?.stockCount < 10">
                <h4 class="text-xl md:text-[22px] font-semibold text-red-500">얼마 남지 않았어요!</h4>
              </template>
            </div>

            <!-- ✅ 수량 선택 + 버튼 모두 숨김 처리 -->
            <div
                class="py-4 sm:py-6 border-b border-bdr-clr dark:border-bdr-clr-drk"
                data-aos="fade-up"
            >
              <template v-if="data?.stockCount > 0">
                <IncDec v-model="quantity" :max="data.stockCount" />

                <div class="flex gap-4 mt-4 sm:mt-6">
                  <button class="btn btn-outline" @click="goToCart">
                    장바구니 담기
                  </button>
                  <button class="btn btn-outline" @click="buyNow">
                    구매
                  </button>
                </div>
              </template>
            </div>

          </div>
        </div>
      </div>
    </div>

    <!-- ✅ 상세 정보 탭 -->
    <div class="s-py-50">
      <DetailTab v-if="data && data.id" :productDetail="data" />
    </div>

    <FooterOne />
    <ScrollToTop />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'
import NavbarOne from '@/components/navbar/navbar-one.vue'
import IncDec from '@/components/inc-dec.vue'
import DetailTab from '@/components/product/detail-tab.vue'
import FooterOne from '@/components/footer/footer-one.vue'
import ScrollToTop from '@/components/scroll-to-top.vue'
import bg from '@/assets/img/shortcode/breadcumb.jpg' // ✅ 배경 이미지 import
import Aos from 'aos'
import { useOrderStore } from '@/modules/order/stores/order'
import {useAuthStore} from "@/modules/auth/stores/auth";
import { getCartByUserId, addCartItem } from "@/modules/order/services/orderApi";

const route = useRoute()
const router = useRouter()
const store = useOrderStore()

const authStore = useAuthStore();
const userId = authStore.id;

const data = ref(null)
const quantity = ref(1)

onMounted(async () => {
  Aos.init()
  const productId = route.params.id

  try {
    const res = await axios.get(`http://localhost:8080/product/detail/${productId}`)

    if (typeof res.data !== 'object' || !res.data.id) {
      console.warn('⚠️ 올바르지 않은 데이터 응답:', res.data)
      data.value = null
      return
    }

    data.value = res.data
    console.log('[🔥 실제 응답]', data.value)

  } catch (err) {
    console.error('❌ 상품 정보를 불러오는 데 실패했습니다.', err)
    alert('상품 정보를 불러올 수 없습니다.')
  }
})

function getImageUrl(url) {
  if (!url || url === '') {
    return '/no-image.png';
  }
  return url; // 전체 URL이면 그대로 반환
}

function onImageError(event) {
  event.target.src = '/no-image.png';
}



// 타이머
const now = ref(new Date().getTime())
const targetTime = ref(new Date('Sep 13 2025').getTime())
const difference = ref(targetTime.value - now.value)

function updateNow() {
  now.value = new Date().getTime()
  difference.value = targetTime.value - now.value
}
setInterval(updateNow, 1000)



const productId = computed(() => route.params.id)

async function goToCart() {
  if (!userId) {
    alert('로그인이 필요합니다. 로그인 페이지로 이동합니다.');
    router.push({
      path: '/login',
      query: { redirect: route.fullPath }
    });
    return;
  }

  try {
    // 1. 사용자 장바구니 조회 → cartId 확보
    const cartResponse = await getCartByUserId(userId);
    const cartId = cartResponse.data?.cartId;

    if (!cartId) {
      alert('장바구니를 불러올 수 없습니다.');
      return;
    }

    // 2. 장바구니 항목 추가
    const payload = {
      cartId: cartId,
      productId: productId.value,
      quantity: quantity.value
    };

    const res = await addCartItem(payload);
    console.log('[✅ 장바구니 추가 성공]', res.data);

    // 3. 장바구니 페이지로 이동
    const confirmed = window.confirm('🛒 장바구니에 추가되었습니다.\n장바구니로 이동하시겠습니까?');
    if (confirmed) {
      router.push({path: '/cart'});
    }
  } catch (err) {
    console.error('[❌ 장바구니 처리 실패]', err);
    alert('장바구니 추가 중 오류가 발생했습니다.');
  }
}


// 구매 API
async function buyNow() {

  if (userId === null) {
    alert('로그인이 필요합니다. 로그인 페이지로 이동합니다.');
    router.push({
      path: '/login',
      query: { redirect: route.fullPath }
    });
    return;
  }

  try {
    console.log('[✅ 호출 시작] productId:', productId.value, 'quantity:', quantity.value)

    const response = await axios.get('http://localhost:8080/api/order', {
      params: {
        productId: productId.value,
        quantity: quantity.value
      }
    });

    console.log('[🎯 API 응답]', response.data);

    store.setOrderItem({ ...response.data, quantity: quantity.value });

    console.log('[📦 저장된 주문정보]', store.orderItem);

    router.push({ name: 'order' });
  } catch (err) {
    alert('API 호출 실패\n' + err);
    console.error('[❌ Order API 호출 실패]', err);
  }
}
</script>
