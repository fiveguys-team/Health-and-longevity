import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import axiosInstance from "@/api/axios";

export const useAuthStore = defineStore('auth', () => {
    // Composition API 스타일로 변경 (더 나은 반응성)
    const role = ref(null)
    const name = ref(null)
    const id = ref(null)
    const email = ref(null)

    // getters를 computed로 변경
    const isAuthorized = computed(() => {
        return (requiredRoles = []) => {
            if (!role.value) return false
            if (!requiredRoles.length) return !!role.value
            return requiredRoles.includes(role.value)
        }
    })

    // actions
    const logout = async () => {
        role.value = null
        name.value = null
        id.value = null
        email.value = null

        try {
            await axiosInstance.post('/member/logout')
        } catch (e) {
            console.warn('서버 로그아웃 실패:', e)
        }
    }

    const initFromServer = async () => {
        try {
            const res = await axiosInstance.get('/member/info')
            const user = res.data
            role.value = user.role
            name.value = user.name
            id.value = user.id
            email.value = user.email
        } catch (e) {
            logout()
        }
    }

    return {
        role,
        name,
        id,
        email,
        isAuthorized,
        logout,
        initFromServer
    }
})