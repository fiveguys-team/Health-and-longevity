<template>
  <div>

    <StoreNavbar/>

    <FooterTwo/>

    <ScrollToTop/>

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
