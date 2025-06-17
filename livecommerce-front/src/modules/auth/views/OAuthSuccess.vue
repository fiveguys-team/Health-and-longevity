<script setup>
import { useAuthStore } from '@/modules/auth/stores/auth'
import { onMounted } from 'vue'
import router from '@/router'

const authStore = useAuthStore()

onMounted(async () => {
  await authStore.initFromServer()
  await router.push("/") // 메인 페이지로 이동
})
</script>

<template>
  <div>로그인 처리 중입니다...</div>
</template>