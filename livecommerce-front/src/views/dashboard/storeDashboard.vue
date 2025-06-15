<!--<template>-->
<!--  <div class="flex min-h-screen">-->
<!--    &lt;!&ndash; 왼쪽 고정 메뉴 &ndash;&gt;-->
<!--    <aside class="w-64 bg-[#f5f5f5] p-6">-->
<!--      <StoreNavbar />-->
<!--    </aside>-->

<!--    &lt;!&ndash; 오른쪽 콘텐츠 영역 &ndash;&gt;-->
<!--    <div class="flex-1 flex flex-col">-->
<!--      <main class="flex-1 p-6">-->
<!--        <router-view />-->
<!--      </main>-->

<!--      &lt;!&ndash; 푸터 &ndash;&gt;-->
<!--      <FooterTwo />-->
<!--    </div>-->

<!--    &lt;!&ndash; ScrollToTop 컴포넌트 &ndash;&gt;-->
<!--    <ScrollToTop />-->
<!--  </div>-->
<!--</template>-->

<!--<script setup>-->
<!--import { onMounted } from 'vue';-->

<!--import ScrollToTop from '@/components/scroll-to-top.vue';-->

<!--import Aos from 'aos';-->

<!--import 'swiper/swiper-bundle.css';-->
<!--import StoreNavbar from '@/components/dashboard/storeNavbar.vue';-->

<!--onMounted(()=>{-->
<!--  Aos.init()-->
<!--})-->
<!--</script>-->
<template>
  <div class="flex h-screen bg-gray-100 dark:bg-dark-primary">
    <!-- 사이드바 -->
    <div class="w-64 bg-white dark:bg-dark-secondary shadow-lg">
      <div class="text-center py-6">
        <router-link to="/" class="block">
          <img :src="logoDark" alt="무병장수" class="dark:hidden w-32 mx-auto"/>
          <img :src="logoLight" alt="무병장수" class="hidden dark:block w-32 mx-auto"/>
          <h2 class="text-xl font-semibold mt-2">입점업체</h2>
        </router-link>
      </div>
      <nav class="mt-6">
        <ul>
          <li>
            <router-link :to="`/store-live-streaming/${vendorId}`" class="flex items-center px-6 py-3 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-dark-light"
                         :class="{ 'bg-gray-100 dark:bg-dark-light border-l-4 border-indigo-500': $route.path === `/store-live-streaming/${vendorId}` }"
            >
              <span class="mx-3">방송 진행</span>
            </router-link>
          </li>

          <li>
            <router-link
                to="/vendor/live/reportList"
                class="flex items-center px-6 py-3 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-dark-light"
                :class="{ 'bg-gray-100 dark:bg-dark-light border-l-4 border-indigo-500': $route.path === '/vendor/live/reportList' }"
            >
              <span class="mx-3">레포트</span>
            </router-link>
          </li>

          <li>
            <router-link
                to="/vendor/product/register"
                class="flex items-center px-6 py-3 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-dark-light"
                :class="{ 'bg-gray-100 dark:bg-dark-light border-l-4 border-indigo-500': $route.path === '/vendor/product/register' }"
            >
              <span class="mx-3">상품 등록</span>
            </router-link>
          </li>

          <li>
            <router-link
                to="/vendor/product/status"
                class="flex items-center px-6 py-3 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-dark-light"
                :class="{ 'bg-gray-100 dark:bg-dark-light border-l-4 border-indigo-500': $route.path === '/vendor/product/status' }"
            >
              <span class="mx-3">상품 등록 현황</span>
            </router-link>
          </li>







        </ul>
      </nav>
    </div>

    <!-- 메인 컨텐츠 -->
    <div class="flex-1 overflow-x-hidden overflow-y-auto">
      <router-view></router-view>
    </div>
  </div>
</template>

<script setup>
import logoDark from '@/assets/img/svg/logo.png'
import logoLight from '@/assets/img/svg/logo.png'
import { useRoute } from 'vue-router'

const vendorId = 1;

const $route = useRoute()
</script>
