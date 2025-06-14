import axios from 'axios';
import {useAuthStore} from "@/modules/auth/stores/auth";

const axiosInstance = axios.create({
    baseURL: 'http://localhost:8080', // 또는 import.meta.env.VITE_API_BASE_URL
    withCredentials: true,            // 쿠키 포함해서 보내려면 이거 꼭 필요
});

// 요청 시 accessToken 자동 삽입
axiosInstance.interceptors.request.use(
    (config) => {
        const token = useAuthStore().token;
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => Promise.reject(error)
);

// 응답 에러 처리 (401 등)
axiosInstance.interceptors.response.use(
    response => response,
    async (error) => {
        if (error.response?.status === 401) {
            console.warn('토큰 만료 or 인증 실패. 로그아웃 처리 예정');

            // TODO: refresh token 처리 또는 자동 로그아웃 로직
            // 예시: router.push('/login') or store.logout()

            // 예시용 로그 출력만:
            console.error('요청 실패:', error.response);
        }
        return Promise.reject(error);
    }
);

export default axiosInstance;