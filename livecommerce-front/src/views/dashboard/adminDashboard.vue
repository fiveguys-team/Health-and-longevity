<template>
  <div>

    <AdminNavbar/>

    <FooterTwo/>

    <ScrollToTop/>

  </div>
</template>

<script setup>
import { onMounted } from 'vue';

import ScrollToTop from '@/components/scroll-to-top.vue';

import Aos from 'aos';

import 'swiper/swiper-bundle.css';

import AdminNavbar from '@/components/dashboard/adminNavbar.vue';

onMounted(()=>{
  Aos.init()
})
</script>
