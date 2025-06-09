<template>
  <div class="flex min-h-screen">
    <!-- 왼쪽 고정 메뉴 -->
    <aside class="w-64 bg-[#f5f5f5] p-6">
      <StoreNavbar />
    </aside>

    <!-- 오른쪽 콘텐츠 영역 -->
    <div class="flex-1 flex flex-col">
      <main class="flex-1 p-6">
        <router-view />
      </main>

      <!-- 푸터 -->
      <FooterTwo />
    </div>

    <!-- ScrollToTop 컴포넌트 -->
    <ScrollToTop />
  </div>
</template>

<script setup>
import { onMounted } from 'vue';

import ScrollToTop from '@/components/scroll-to-top.vue';

import Aos from 'aos';

import 'swiper/swiper-bundle.css';
import StoreNavbar from '@/components/dashboard/storeNavbar.vue';

onMounted(()=>{
  Aos.init()
})
</script>
