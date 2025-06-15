import { defineStore } from 'pinia'
import { ref, computed } from 'vue' // 추가

function getCookie(name) {
    const matches = document.cookie.match(new RegExp(
        '(?:^|; )' + name.replace(/([.$?*|{}()[\]\\/+^])/g, '\\$1') + '=([^;]*)'
    ));
    return matches ? decodeURIComponent(matches[1]) : undefined;
}

export const useAuthStore = defineStore('auth', () => {
    // Composition API 스타일로 변경 (더 나은 반응성)
    const token = ref(getCookie('token') || null)
    const role = ref(getCookie('role') || null)
    const name = ref(getCookie('name') || null)
    const id = ref(getCookie('id') || null)

    // getters를 computed로 변경
    const isAuthorized = computed(() => {
        return (requiredRoles = []) => token.value && requiredRoles.includes(role.value)
    })

    // actions
    const login = (newToken, newRole, newName, newId) => {
        token.value = newToken
        role.value = newRole
        name.value = newName
        id.value = newId

        // 쿠키 설정
        document.cookie = `token=${newToken}; path=/`
        document.cookie = `role=${newRole}; path=/`
        document.cookie = `name=${newName}; path=/`
        document.cookie = `id=${newId}; path=/`
        console.log('쿠키 확인:', document.cookie)
    }

    const logout = () => {
        token.value = null
        role.value = null
        name.value = null
        id.value = null

        // 쿠키 삭제
        document.cookie = 'token=; Max-Age=0; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT'
        document.cookie = 'role=; Max-Age=0; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT'
        document.cookie = 'name=; Max-Age=0; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT'
        document.cookie = 'id=; Max-Age=0; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT'
    }

    const initFromCookie = () => {
        token.value = getCookie('token') || null
        role.value = getCookie('role') || null
        name.value = getCookie('name') || null
        id.value = getCookie('id') || null
    }

    return {
        // state
        token,
        role,
        name,
        id,
        // getters
        isAuthorized,
        // actions
        login,
        logout,
        initFromCookie
    }
})