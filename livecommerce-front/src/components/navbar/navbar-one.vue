<template>
    <div class="header-area default-header relative z-50 bg-white dark:bg-title" :class="scroll ? 'sticky-header' : ''">
        <div class="container-fluid">
            <div class="flex items-center justify-between gap-x-6 max-w-[1720px] mx-auto relative py-[10px] sm:py-4 lg:py-0">
                <router-link class="cursor-pointer block" to="/" aria-label="Furnixar">
                    <img :src="logoDark" alt="" class='dark:hidden w-[120px] sm:w-[200px]'/> 
                    <img :src="logoLight" alt="" class='dark:block hidden w-[120px] sm:w-[200px]'/>
                </router-link>

                <div class="main-menu absolute z-50 w-full lg:w-auto top-full left-0 lg:static bg-white dark:bg-title lg:bg-transparent lg:dark:bg-transparent px-5 sm:px-[30px] py-[10px] sm:py-5 lg:px-0 lg:py-0" :class="toggle ? 'active' : ''">
                    <ul class="text-lg leading-none text-title dark:text-white lg:flex lg:gap-[30px]">
                        <!-- <li class="relative" :class="['/','/index-v2','/index-v3','/index-v4','/index-v5','/index-v6', '/live-test'].includes(current) ? 'active' : ''"> -->
                        <li class="relative">
                            <router-link to="#">라이브<span></span></router-link>
                            <ul class="sub-menu lg:absolute z-50 lg:top-full lg:left-0 lg:min-w-[220px] lg:invisible lg:transition-all lg:bg-white lg:dark:bg-title lg:py-[15px] lg:pr-[30px]">
                                <li :class="current === '/live-test' ? 'active' : ''"><router-link to="/live-streaming" class="menu-item">Live</router-link></li>
                                <li :class="current === '/live-test' ? 'active' : ''"><router-link to="/live-chart" class="menu-item">편성표</router-link></li>
                            </ul>
                        </li>
                        <!-- <li class="relative" :class="['/shop-v1','/shop-v2','/shop-v3','/shop-v4','/product-details','/cart','/checkout'].includes(current) ? 'active' : ''"> -->
                      <li class="relative">
                        <router-link to="#">고민별<span></span></router-link>
                        <ul class="sub-menu lg:absolute z-50 lg:top-full lg:left-0 lg:min-w-[220px] lg:invisible lg:transition-all lg:bg-white lg:dark:bg-title lg:py-[15px] lg:pr-[30px]">
                          <li><router-link :to="`/product/blood-pressure`" class="menu-item">혈압</router-link></li>
                          <li><router-link :to="`/product/eye`" class="menu-item">눈</router-link></li>
                          <li><router-link :to="`/product/joint`" class="menu-item">뼈/관절/연골</router-link></li>
                          <li><router-link :to="`/product/gut-health`" class="menu-item">장건강</router-link></li>
                          <li><router-link :to="`/product/supplement`" class="menu-item">영양보충</router-link></li>
                        </ul>
                      </li>

                      <li class="relative">
                        <router-link to="/vendor-category">업체별</router-link>
                      </li>

                      <li v-if="role === 'ADMIN'">
                        <router-link to="/admin-dashboard">대시보드</router-link>
                      </li>
                      <li v-if="role === 'VENDOR'">
                        <router-link to="/store-dashboard">대시보드</router-link>
                      </li>

                      <li v-if="role === 'USER' || role === null">
                        <router-link to="/contact">입점신청</router-link>
                      </li>
<!--                        <li :class="current === '/login' ? 'active' : ''" class="lg:hidden"><router-link to="/login">로그인</router-link></li>-->
                    </ul>
                </div>
                <NavMenuOne :toggle="toggle" @toggle-change="toggle = $event"/>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue';
import { useAuthStore } from "@/modules/auth/stores/auth";
import logoDark from '@/assets/img/svg/logo.png'
import logoLight from '@/assets/img/svg/logo.png'
import NavMenuOne from './nav-menu-one.vue';

const toggle = ref(false);
const scroll = ref(false)
const authStore = useAuthStore();

const role = computed(() => authStore.role);

const handleScroll = () => {
    if (window.scrollY >= 50) {
        scroll.value = true
    } else {
        scroll.value = false
    }
}

onMounted(()=>{
    window.scrollTo(0,0)
    window.addEventListener('scroll', handleScroll)
})
</script>
