<!-- 관리자 메뉴바 컴포넌트 완성 -->

<template>
  <div class="header-area header-v2 absolute top-0 left-0 right-0 z-10 w-full border-b-[3px] border-[#EEF1F3] dark:border-bdr-clr-drk bg-white bg-opacity-50 dark:bg-dark-secondary dark:bg-opacity-50" :class="scroll ? 'sticky-header' : ''">
    <div class="absolute top-full left-0 h-[3px] w-0 bg-primary" id="indicator" :style="{ width: scrollWidth + '%' }"></div>
    <div class="container">
      <div class="flex items-center justify-between gap-5 relative py-3 sm:py-5 max-w-1366 mx-auto header-wrapper">
        <NavMenuTwo/>
      </div>
    </div>
    <div class="hdr-v2-menu absolute top-full left-0 w-64 sm:w-80 bg-[#f5f5f5] py-[15px] px-5 sm:px-[30px] transform translate-y-[3px] z-50 dark:bg-dark-secondary shadow-lg">
      <div class="text-center mb-6">
        <router-link class="cursor-pointer block" to="/" aria-label="무병장수">
          <img :src="logoDark" alt="무병장수" class='dark:hidden w-[120px] sm:w-[200px] mx-auto'/>
          <img :src="logoLight" alt="무병장수" class='dark:block hidden w-[120px] sm:w-[200px] mx-auto'/>
          <h2 class="text-xl font-semibold mt-2">관리자</h2>
        </router-link>
      </div>
      <ul>
        <li><router-link to="/admin/chat/reports" class="menu-item">채팅 관리</router-link></li>
        <li><router-link to="/@2" class="menu-item">업체 관리</router-link></li>
        <li><router-link to="/admin/products" class="menu-item">상품 관리</router-link></li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue';

import logoDark from '@/assets/img/svg/logo.png'
import logoLight from '@/assets/img/svg/logo.png'

const scroll = ref(false)
const scrollWidth = ref(0)

const handleScroll = () => {
  if (window.scrollY >= 50) {
    scroll.value = true
  } else {
    scroll.value = false
  }
}

const updateScrollWidth =()=>{
  const scrollTop = window.scrollY; // Pixels scrolled from the top
  const scrollHeight = document.documentElement.scrollHeight - window.innerHeight; // Total scrollable height
  scrollWidth.value = (scrollTop / scrollHeight) * 100; // Calculate width percentage
}
onMounted(()=>{
  window.scrollTo(0,0)
  window.addEventListener('scroll', handleScroll)
  window.addEventListener("scroll", updateScrollWidth);
})
</script>


































