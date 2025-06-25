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
            <router-link :to="`/vendor-dashboard/live/reportList/${vendorId}`"
                         class="flex items-center px-6 py-3 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-dark-light"
                         :class="{ 'bg-gray-100 dark:bg-dark-light border-l-4 border-indigo-500': $route.path === `/vendor-dashboard/live/reportList/${vendorId}` }"
            >
              <span class="mx-3">레포트</span>
            </router-link>
          </li>
          <li>
            <router-link :to="`/store-live-streaming/${vendorId}`" class="flex items-center px-6 py-3 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-dark-light"
                         :class="{ 'bg-gray-100 dark:bg-dark-light border-l-4 border-indigo-500': $route.path === `/store-live-streaming/${vendorId}` }"
            >
              <span class="mx-3">방송 진행</span>
            </router-link>
          </li>
          <li>
            <router-link
                to="/vendor-dashboard/product/register"
                class="flex items-center px-6 py-3 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-dark-light"
                :class="{ 'bg-gray-100 dark:bg-dark-light border-l-4 border-indigo-500': $route.path === '/vendor-dashboard/product/register' }"
            >
              <span class="mx-3">상품 등록</span>
            </router-link>
          </li>
          <li>
            <router-link
                to="/vendor-dashboard/product/status"
                class="flex items-center px-6 py-3 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-dark-light"
                :class="{ 'bg-gray-100 dark:bg-dark-light border-l-4 border-indigo-500': $route.path === '/vendor-dashboard/product/status' }"
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
import { useAuthStore } from '@/modules/auth/stores/auth'
import { computed } from 'vue'

const auth = useAuthStore()
const vendorId = computed(() => auth.vendorId)

const $route = useRoute()
</script>
