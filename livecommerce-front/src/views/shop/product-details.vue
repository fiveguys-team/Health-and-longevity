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
              <button class="absolute top-5 left-0 p-2 bg-[#E13939] text-lg leading-none text-white font-medium z-50">-10%</button>
              <div class="product-dtls-slider">
                <img
                    :src="!data?.productImage || data.productImage === '' ? testImg : getImageUrl(data.productImage)"
                    alt="product"
                    class="w-full"
                    :class="activeImage === 1 ? '' : 'hidden'"
                />
              </div>
            </div>
          </div>

          <div class="lg:max-w-[635px] w-full">
            <div class="pb-4 sm:pb-6 border-b border-bdr-clr dark:border-bdr-clr-drk">
              <div v-if="data">
                <h2 class="font-semibold leading-none">{{ data.name }}</h2>
                <div class="flex items-center gap-3 mt-3">
                  <div class="text-yellow-500 font-medium">
                    ⭐ {{ averageRating }} / 5.0
                  </div>
                  <div class="text-gray-600 text-sm">
                    (리뷰 {{ reviewCount }}개)
                  </div>
                </div>
                <p class="sm:text-lg mt-5 md:mt-7">
                  <strong>업체:</strong> {{ data.vendor }}
                </p>
              </div>
              <div v-else class="text-gray-500 p-10 text-center">상품 정보를 불러오는 중입니다...</div>
            </div>

            <div class="flex gap-4 items-center mt-[15px]">
              <span class="text-lg sm:text-xl line-through text-title dark:text-white">₩140,000</span>
              <span class="text-2xl sm:text-3xl text-primary">₩{{ data?.price }}</span>
            </div>

            <div class="mt-5 md:mt-7 flex items-center gap-4 flex-wrap">
              <h4 class="text-xl md:text-[22px] font-semibold">얼마 남지 않았어요!</h4>
              <div class="overflow-auto">
                <div class="py-2 px-3 bg-[#FAF2F2] rounded-[51px] flex items-end gap-[6px] w-[360px]">
                  <h6 class="text-lg font-medium text-[#E13939]">할인 마감 :</h6>
                  <div class="countdown-clock flex gap-[10px] items-center">
                    <div class="clock-days">{{ days }}</div>D
                    <div class="clock-hours">{{ hours }}</div>H
                    <div class="clock-minutes">{{ minutes }}</div>M
                    <div class="clock-seconds">{{ seconds }}</div>S
                  </div>
                </div>
              </div>
            </div>

            <div class="py-4 sm:py-6 border-b border-bdr-clr dark:border-bdr-clr-drk" data-aos="fade-up">
              <IncDec v-model="quantity" />
              <div class="flex gap-4 mt-4 sm:mt-6">
                     <button class="btn btn-outline" @click="goToCart">
                       장바구니 담기
                     </button>
                <button class="btn btn-outline" @click="buyNow">구매</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ✅ 상세 정보 탭 -->
    <div class="s-py-50">
      <DetailTab :productDetail="data" />
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
import testImg from '@/assets/img/product/testimg.jpg'
import bg from '@/assets/img/shortcode/breadcumb.jpg' // ✅ 배경 이미지 import
import Aos from 'aos'
import { useOrderStore } from '@/modules/order/stores/order'
import { detailReview } from '@/data/data'
import {useAuthStore} from "@/modules/auth/stores/auth";
import { getCartByUserId, addCartItem } from "@/modules/order/services/orderApi";

const route = useRoute()
const router = useRouter()
const store = useOrderStore()

const authStore = useAuthStore();
const userId = authStore.id;

const data = ref(null)
const quantity = ref(1)
const activeImage = ref(1)

onMounted(async () => {
  Aos.init()
  const productId = route.params.id

  try {
    const res = await axios.get(`http://localhost:8080/products/${productId}`)
    data.value = res.data
  } catch (err) {
    console.error('상품 정보를 불러오는 데 실패했습니다.', err)
    alert('상품 정보를 불러올 수 없습니다.')
  }
})

function getImageUrl(filename) {
  return `http://localhost:8080/uploads/images/${filename}`
}

// 리뷰 계산
const filteredReviews = computed(() => {
  return detailReview.filter(review => review.product === data.value?.name)
})
const reviewCount = computed(() => filteredReviews.value.length)
const averageRating = computed(() => {
  if (!filteredReviews.value.length) return 0
  const total = filteredReviews.value.reduce((sum, r) => sum + r.rating, 0)
  return (total / filteredReviews.value.length).toFixed(1)
})

// 타이머
const now = ref(new Date().getTime())
const targetTime = ref(new Date('Sep 13 2025').getTime())
const difference = ref(targetTime.value - now.value)

function updateNow() {
  now.value = new Date().getTime()
  difference.value = targetTime.value - now.value
}
setInterval(updateNow, 1000)

const days = computed(() => Math.floor(difference.value / (1000 * 60 * 60 * 24)))
const hours = computed(() => 23 - new Date(now.value).getHours())
const minutes = computed(() => 60 - new Date(now.value).getMinutes())
const seconds = computed(() => 60 - new Date(now.value).getSeconds())

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
