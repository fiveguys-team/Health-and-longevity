<!-- 입점업체 메뉴파 컴포넌트 완성 -->

<template>
  <div class="header-area header-v2 absolute top-0 left-0 right-0 z-10 w-full border-b-[3px] border-[#EEF1F3] dark:border-bdr-clr-drk bg-white bg-opacity-50 dark:bg-dark-secondary dark:bg-opacity-50" :class="scroll ? 'sticky-header' : ''">
    <div class="absolute top-full left-0 h-[3px] w-0 bg-primary" id="indicator" :style="{ width: scrollWidth + '%' }"></div>
    <div class="container">
      <div class="flex items-center justify-between gap-5 relative py-3 sm:py-5 max-w-1366 mx-auto header-wrapper">
        <div class="flex items-center gap-5 sm:gap-8 md:gap-12">
          <router-link class="cursor-pointer block" to="/" aria-label="Furnixar">
            <img :src="logoDark" alt="" class='dark:hidden w-[120px] sm:w-[200px]'/>
            <img :src="logoLight" alt="" class='dark:block hidden w-[120px] sm:w-[200px]'/>
          </router-link>

          <button class="hamburger hamburger-v2 transform translate-y-1 sm:translate-y-[6px]" :class="toggle ? 'opened' : ''" @click="toggle = !toggle">
            <svg class="stroke-current text-title dark:text-white" width="40" viewBox="0 0 100 100">
              <path class="line line1" d="M 20,29.000046 H 80.000231 C 80.000231,29.000046 94.498839,28.817352 94.532987,66.711331 94.543142,77.980673 90.966081,81.670246 85.259173,81.668997 79.552261,81.667751 75.000211,74.999942 75.000211,74.999942 L 25.000021,25.000058" />
              <path class="line line2" d="M 20,50 H 80" />
              <path class="line line3" d="M 20,70.999954 H 80.000231 C 80.000231,70.999954 94.498839,71.182648 94.532987,33.288669 94.543142,22.019327 90.966081,18.329754 85.259173,18.331003 79.552261,18.332249 75.000211,25.000058 75.000211,25.000058 L 25.000021,74.999942" />
            </svg>
          </button>
        </div>
        <NavMenuTwo/>
      </div>
    </div>
    <div class="hdr-v2-menu absolute top-full left-0 w-64 sm:w-80 bg-[#f5f5f5] py-[15px] px-5 sm:px-[30px] transform translate-y-[3px] z-50 dark:bg-dark-secondary shadow-lg -translate-x-[256px] sm:-translate-x-[300px] opacity-0 invisible" :class="toggle ? 'active' : ''">
      <ul>
        <!-- 라이브 메뉴판 -->
        <li class="relative" :class="['/','/index-v2','/index-v3'].includes(current) ? 'active' : ''">
          <router-link to="#">라이브<span></span></router-link>
          <ul class="sub-menu">
            <li :class="current === '/' ? 'active' : ''"><router-link to="/live-register" class="menu-item">등록</router-link></li>
            <li :class="current === '/index-v2' ? 'active' : ''"><router-link to="/store-live-streaming" class="menu-item">방송 진행</router-link></li>
            <li :class="current === '/index-v3' ? 'active' : ''"><router-link to="/live-report" class="menu-item">레포트</router-link></li>
          </ul>
        </li>
        <!-- 상품/리뷰 메뉴판 -->
        <li :class="['/about', '/pricing', '/team'].includes(current) ? 'active' : ''">
          <router-link to="#">상품/리뷰<span></span></router-link>
          <div class="mega-menu">
            <div class="megamenu-item">
              <ul>
                <li :class="current === '/about' ? 'active' : ''"><router-link to="/@">상품 등록</router-link></li>
                <li :class="current === '/pricing' ? 'active' : ''"><router-link to="/@1">상품 등록 현황</router-link></li>
                <li :class="current === '/team' ? 'active' : ''"><router-link to="/@2">리뷰</router-link></li>
              </ul>
            </div>
          </div>
        </li>
        <!-- 주문/결제 메뉴판 -->
        <li class="relative" :class="['/shop-v1','/shop-v2'].includes(current) ? 'active' : ''">
          <router-link to="#">주문/결제<span></span></router-link>
          <ul class="sub-menu">
            <li :class="current === '/shop-v1' ? 'active' : ''"><router-link to="/@1">주문 확인</router-link></li>
            <li :class="current === '/shop-v2' ? 'active' : ''"><router-link to="/@2">교환 / 환불</router-link></li>
          </ul>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue';

import logoDark from '@/assets/img/svg/logo.svg'
import logoLight from '@/assets/img/svg/logo-light.svg'

import { useRoute } from 'vue-router';

const toggle = ref(false);

const router = useRoute();
const current = ref(router.path);

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
