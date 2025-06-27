import axios from 'axios';
// 서버 URL 설정 (배포 시 이 부분만 변경하면 됨)
// export const SERVER_BASE_URL = 'https://healthy-and-longevity.shop/';
const SERVER_BASE_URL = 'http://localhost:8080';
const axiosInstance = axios.create({
    baseURL: SERVER_BASE_URL,
    withCredentials: true,
});

// 리프레시 요청을 위한 별도의 인스턴스 (인터셉터 없음)
const axiosRefreshInstance = axios.create({
    baseURL: SERVER_BASE_URL,
    withCredentials: true,
});
// WebSocket 연결용 URL (같은 서버 사용)
// export const WS_BASE_URL = 'https://healthy-and-longevity.shop';
export const WS_BASE_URL = 'http://localhost:8080';
// 응답 에러 처리 (401 등)

let isRefreshing = false;
let lastRefreshAttempt = 0;
const REFRESH_COOLDOWN = 5000;

axiosInstance.interceptors.response.use(
    response => response,
    async (error) => {
        const originalRequest = error.config;
        const currentTime = Date.now();

        if (error.response?.status === 401 && !isRefreshing &&
            !originalRequest._retry &&
            originalRequest.url !== '/member/token/refresh' &&
            currentTime - lastRefreshAttempt > REFRESH_COOLDOWN) {

            originalRequest._retry = true;
            isRefreshing = true;
            lastRefreshAttempt = currentTime;

            try {
                console.log('토큰 갱신 시도');
                // 중요: 인터셉터가 없는 별도의 인스턴스 사용
                const refreshResponse = await axiosRefreshInstance.post('/member/token/refresh', {});
                console.log('토큰 갱신 응답:', refreshResponse.data);

                isRefreshing = false;
                return axiosInstance(originalRequest);
            } catch (refreshError) {
                console.error('토큰 갱신 실패:', refreshError.response?.status);
                isRefreshing = false;

                // 로그아웃 처리
                try {
                    const { useAuthStore } = await import('@/modules/auth/stores/auth');
                    const authStore = useAuthStore();
                    authStore.logout();
                } catch (e) {
                    console.error('로그아웃 처리 실패:', e);
                }
            }
        }
        return Promise.reject(error);
    }
);
export default axiosInstance;