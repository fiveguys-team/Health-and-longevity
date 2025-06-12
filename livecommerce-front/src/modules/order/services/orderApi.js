import axios from 'axios';

const API_BASE_URL = 'http://localhost:8080/api/order';
/**
 * 주문 프리페어 API 호출
 * @param {Object} payload - 주문 요청 데이터
 * @param {string} token - JWT 토큰
 * @returns {Promise}
 */

export async function prepareOrder(payload) {
    return axios.post(`${API_BASE_URL}/prepare`, payload, {
        headers: {
            'Content-Type': 'application/json',
            // 'Authorization': `Bearer ${token}`
        }
    })
}
