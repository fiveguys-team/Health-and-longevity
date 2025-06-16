<template>
  <div>
    <NavbarOne/>

    <div class="bg-[#F8F5F0] dark:bg-dark-secondary py-5 md:py-[30px]">
      <div class="container-fluid">
        <ul class="flex items-center gap-[10px] text-base md:text-lg leading-none font-normal text-title dark:text-white max-w-[1720px] mx-auto flex-wrap">
          <li><router-link to="/">Home</router-link></li>
          <li>/</li>
          <li><router-link to="/shop-v1">Shop</router-link></li>
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
                    :src="!data?.image || data.image === '' ? testImg : data.image"
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
              <span class="text-lg sm:text-xl line-through text-title dark:text-white">$140.99</span>
              <span class="text-2xl sm:text-3xl text-primary">$85.00</span>
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
                <router-link to="/cart" class="btn btn-outline">장바구니</router-link>
                <button class="btn btn-outline" @click="buyNow">구매</button>
                <!--                <router-link :to="{-->
                <!--                path: '/order',-->
                <!--                query: {-->
                <!--                  productId: data?.id,-->
                <!--                  quantity-->
                <!--                }-->
                <!--                }" class="btn btn-outline">-->
                <!--                  구매</router-link>-->
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="s-py-50">
      <DetailTab :productName="data?.name || ''"/>
    </div>

    <FooterOne/>
    <ScrollToTop/>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue';
import {useRoute, useRouter} from 'vue-router'
import axios from "axios";
import {useOrderStore} from '@/modules/order/stores/order'
import NavbarOne from '@/components/navbar/navbar-one.vue';
import IncDec from '@/components/inc-dec.vue';
import DetailTab from '@/components/product/detail-tab.vue';
import FooterOne from '@/components/footer/footer-one.vue';
import ScrollToTop from '@/components/scroll-to-top.vue';
import testImg from '@/assets/img/product/testimg.jpg';
import Aos from 'aos';
import { productList } from '@/data/data';
import { detailReview } from '@/data/data';

onMounted(() => {
  Aos.init();
});

// inc-dec 수량 변경 테스트
const quantity = ref(1);

watch(
    quantity,
    () => { /* no-op or console.log */ },
    { flush: 'sync' }
);

const activeImage = ref(1);
const now = ref(new Date().getTime());
const targetTime = ref(new Date('Sep 13 2025').getTime());
const difference = ref(0);


const days = computed(() => Math.floor(difference.value / (1000 * 60 * 60 * 24)));
const hours = computed(() => 23 - new Date(now.value).getHours());
const minutes = computed(() => 60 - new Date(now.value).getMinutes());
const seconds = computed(() => 60 - new Date(now.value).getSeconds());

watch(now, () => {
  difference.value = targetTime.value - now.value;
});

function updateNow() {
  now.value = new Date().getTime();
}
updateNow();
setInterval(updateNow, 1000);

const route = useRoute();
const data = ref(null);

onMounted(() => {
  const productId = parseInt(route.params.id);
  data.value = productList.find(item => item.id === productId);
});

const filteredReviews = computed(() => {
  return detailReview.filter(review => review.product === data.value?.name);
});

const reviewCount = computed(() => filteredReviews.value.length);

const averageRating = computed(() => {
  if (!filteredReviews.value.length) return 0;
  const total = filteredReviews.value.reduce((sum, r) => sum + r.rating, 0);
  return (total / filteredReviews.value.length).toFixed(1);
});

const store = useOrderStore()
const productId = computed(() => parseInt(route.params.id, 10))
const router = useRouter()

async function buyNow() {
  try {
    console.log('[✅ 호출 시작] productId:', productId.value, 'quantity:', quantity.value)

    const response = await axios.get('http://localhost:8080/api/order', {
      params: {
        productId: productId.value.toString(),
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
