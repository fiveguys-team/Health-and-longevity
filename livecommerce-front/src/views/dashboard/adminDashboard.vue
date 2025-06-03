<template>
  <div class="flex h-screen bg-gray-100 dark:bg-dark-primary">
    <!-- 사이드바 -->
    <div class="w-64 bg-white dark:bg-dark-secondary shadow-lg">
      <div class="text-center py-6">
        <router-link to="/" class="block">
          <img :src="logoDark" alt="무병장수" class="dark:hidden w-32 mx-auto"/>
          <img :src="logoLight" alt="무병장수" class="hidden dark:block w-32 mx-auto"/>
          <h2 class="text-xl font-semibold mt-2">관리자</h2>
        </router-link>
      </div>
      <nav class="mt-6">
        <ul>
          <li>
            <router-link 
              to="/admin/chat/reports" 
              class="flex items-center px-6 py-3 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-dark-light"
              :class="{ 'bg-gray-100 dark:bg-dark-light border-l-4 border-indigo-500': $route.path === '/admin/chat/reports' }"
            >
              <span class="mx-3">채팅 관리</span>
            </router-link>
          </li>
          <li>
            <router-link 
              to="/admin/store" 
              class="flex items-center px-6 py-3 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-dark-light"
              :class="{ 'bg-gray-100 dark:bg-dark-light border-l-4 border-indigo-500': $route.path === '/admin/store' }"
            >
              <span class="mx-3">업체 관리</span>
            </router-link>
          </li>
          <li>
            <router-link 
              to="/admin/products" 
              class="flex items-center px-6 py-3 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-dark-light"
              :class="{ 'bg-gray-100 dark:bg-dark-light border-l-4 border-indigo-500': $route.path === '/admin/products' }"
            >
              <span class="mx-3">상품 관리</span>
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
</script>
