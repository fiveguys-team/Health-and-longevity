import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import axiosInstance from "@/api/axios";

export const useAuthStore = defineStore('auth', () => {
    // Composition API 스타일로 변경 (더 나은 반응성)
    const role = ref(null)
    const name = ref(null)
    const id = ref(null)
    const email = ref(null)
    const vendorId = ref(null)

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
        vendorId.value = null
        localStorage.removeItem('surveyModalDismissed')

        try {
            await axiosInstance.post('/member/logout')
        } catch (e) {
            console.warn('서버 로그아웃 실패:', e)
        }
    }

    const fetchVendorId = async () => {
        if (!id.value || role.value !== 'VENDOR') return null;
        // 이미 vendorId가 있다면 API 호출 방지
        if (vendorId.value) return vendorId.value;

        try {
            const res = await axiosInstance.get(`/api/vendors/user/${id.value}`);
            vendorId.value = res.data;
            return res.data;
        } catch (e) {
            console.error('Vendor ID를 가져오는데 실패했습니다:', e);
            return null;
        }
    }

    const initFromServer = async () => {
        try {
            // 기존 사용자 정보 요청
            const res = await axiosInstance.get('/member/info')
            const user = res.data
            role.value = user.role
            name.value = user.name
            id.value = user.id
            email.value = user.email

            if (role.value === 'VENDOR') {
                await fetchVendorId();
            }
        } catch (e) {
            console.error('사용자 정보 요청 실패:', e.response?.status);

            // axios.js에서 토큰 갱신을 처리하도록 하고 여기서는 로그아웃만 수행
            logout();
        }
    }

    return {
        role,
        name,
        id,
        email,
        vendorId,
        isAuthorized,
        logout,
        initFromServer,
        fetchVendorId
    }
})