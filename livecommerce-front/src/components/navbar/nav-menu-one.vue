<!-- eslint-disable vue/no-mutating-props -->
<template>
    <div class="flex items-center gap-4 sm:gap-6">
        <router-link v-if="!isLogin" to="/login" class="text-lg leading-none text-title dark:text-white transition-all duration-300 hover:text-primary hidden lg:block">로그인</router-link>
        <button v-if="isLogin" @click="doLogout" class="text-lg leading-none text-title dark:text-white transition-all duration-300 hover:text-primary hidden lg:block">로그아웃</button>
        <router-link :to="profileRoute" class="relative hdr_profile_btn">
            <i class="mdi mdi-account-outline text-title dark:text-white text-[24px] sm:text-[28px]"></i>
        </router-link>

      <button class="relative hdr_cart_btn" @click="goToCart">
        <span class="mdi mdi-shopping-outline text-title dark:text-white text-[24px] sm:text-[28px]"></span>
      </button>
        <div v-if="cartList" class="hdr_cart_popup w-80 md:w-96 absolute z-50 top-full right-0 sm:right-10 xl:right-0 bg-white dark:bg-title p-5 md:p-[30px] border border-primary">
            <h4 class="font-medium leading-none mb-4 text-xl md:text-2xl">Cart List</h4>
            <div>
                <div class="hdr-cart-item">
                </div>
                <div class="pt-5 md:pt-[30px] mt-5 md:mt-[30px] border-t border-bdr-clr dark:border-bdr-clr-drk">
                    <h4 class="mb-5 md:mb-[30px] font-medium !leading-none text-lg md:text-xl text-right">Subtotal : </h4>
                    <div class="grid grid-cols-2 gap-4">
                        <router-link to="/cart" class="btn btn-outline btn-sm" data-text="View Cart">
                            <span>View Cart</span>
                        </router-link>
                        <router-link to="/checkout" class="btn btn-theme-solid btn-sm" data-text="Checkout">
                            <span>Checkout</span>
                        </router-link>
                    </div>
                </div>
            </div>
        </div>
        <button class="hamburger" :class="toggle ? 'opened' : ''" @click="handleToggle">
            <svg class="stroke-current text-title dark:text-white" width="40" viewBox="0 0 100 100">
                <path class="line line1" d="M 20,29.000046 H 80.000231 C 80.000231,29.000046 94.498839,28.817352 94.532987,66.711331 94.543142,77.980673 90.966081,81.670246 85.259173,81.668997 79.552261,81.667751 75.000211,74.999942 75.000211,74.999942 L 25.000021,25.000058" />
                <path class="line line2" d="M 20,50 H 80" />
                <path class="line line3" d="M 20,70.999954 H 80.000231 C 80.000231,70.999954 94.498839,71.182648 94.532987,33.288669 94.543142,22.019327 90.966081,18.329754 85.259173,18.331003 79.552261,18.332249 75.000211,25.000058 75.000211,25.000058 L 25.000021,74.999942" />
            </svg>
        </button>
        <div class="w-[1px] bg-title/20 dark:bg-white/20 h-7 hidden sm:block"></div>
        <SwitcherS/>
    </div>
</template>

<script setup>
    import {ref, defineProps, defineEmits, computed} from 'vue'
    import SwitcherS from '../switcher-s.vue'
    import { useAuthStore } from "@/modules/auth/stores/auth";

    const cartList = ref(false)
    const authStore = useAuthStore();
    const isLogin = computed(() => !!authStore.id);
    import { useRouter, useRoute } from 'vue-router'

    const router = useRouter();
    const route = useRoute()

    const profileRoute = computed(() => {
      switch (authStore.role) {
        case 'ADMIN':
          return '/admin-dashboard'
        case 'VENDOR':
          return '/store-dashboard'
        default:
          return '/my-profile'
      }
    })

    const doLogout = () => {
      authStore.logout();
    }

    const props = defineProps({
    toggle: Boolean,
    });

    const emit = defineEmits(['toggle-change']);

    function handleToggle() {
        emit('toggle-change', !props.toggle); // Correctly use `toggle` prop here
    }


    async function goToCart() {
      if (!isLogin.value) {
        alert('로그인이 필요합니다. 로그인 페이지로 이동합니다.');
        router.push({
          path: '/login',
          query: { redirect: route.fullPath }
        });
        return;
      }

      router.push('/cart');
    }
</script>
