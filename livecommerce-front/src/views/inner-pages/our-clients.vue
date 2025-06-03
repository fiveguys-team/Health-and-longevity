<template>
    <div>
        <NavbarOne/>

        <div class="flex items-center gap-4 flex-wrap mt-5 md:mt-7 bg-overlay p-14 sm:p-16 before:bg-title before:bg-opacity-70" :style="{backgroundImage:'url(' + bg + ')'}">
            <div class="text-center w-full">
                <h2 class="text-white text-8 md:text-[40px] font-normal leading-none text-center">Our Clients</h2>
                <ul class="flex items-center justify-center gap-[10px] text-base md:text-lg leading-none font-normal text-white mt-3 md:mt-4">
                    <li><router-link to="/">Home</router-link></li>
                    <li>/</li>
                    <li class="text-primary">Clients</li>
                </ul>
            </div>
        </div>

        <div class="s-py-100">
            <div class="container">
                <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-x-10 gap-y-10 md:gap-y-16">
                    <router-link to="#" v-for="(item, index) in partnerDataTwo" :key="index" class="flex items-center justify-center" data-aos="fade-up" :data-aos-delay="item.delay">
                        <img :src="item.image" class="inline-block dark:hidden" alt=""/>
                        <img :src="item.image2" class="dark:inline-block hidden" alt=""/>
                    </router-link>
                </div>
            </div>
        </div>

        <FooterOne/>

        <ScrollToTop/>

    </div>
</template>

<script setup>
import NavbarOne from '@/components/navbar/navbar-one.vue';
import bg from '@/assets/img/shortcode/breadcumb.jpg'
import { onMounted } from 'vue';
import Aos from 'aos';
import FooterOne from '@/components/footer/footer-one.vue';
import { partnerDataTwo } from '@/data/data';
import ScrollToTop from '@/components/scroll-to-top.vue';

onMounted(()=>{
    Aos.init()
})

</script>
