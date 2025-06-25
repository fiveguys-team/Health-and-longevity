import axios from 'axios';
// 서버 URL 설정 (배포 시 이 부분만 변경하면 됨)
const SERVER_BASE_URL = 'http://localhost:8080';
const axiosInstance = axios.create({
  baseURL: SERVER_BASE_URL, // HTTP API 요청용
  withCredentials: true,            // 쿠키 포함해서 보내려면 이거 꼭 필요
});
// WebSocket 연결용 URL (같은 서버 사용)
export const wsBaseURL = SERVER_BASE_URL;
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