import axios from 'axios';

const API_BASE_URL = 'http://localhost:8080/api';
/**
 * 주문 프리페어 API 호출
 * @param {Object} payload - 주문 요청 데이터
 * @param {string} token - JWT 토큰
 * @returns {Promise}
 */

export async function prepareOrder(payload) {
    return axios.post(`${API_BASE_URL}/order/prepare`, payload, {
        headers: {
            'Content-Type': 'application/json',
            // 'Authorization': `Bearer ${token}`
        }
    })
}

/**
 * 장바구니 조회 API 호출
 * @param {number|string} userId - 사용자 ID
 * @param {string} token - (선택) JWT 토큰
 * @returns {Promise}
 */
export async function getCartByUserId(userId) {
    return axios.get(`${API_BASE_URL}/cart/${userId}`, {
        headers: {
            'Content-Type': 'application/json',
            // 'Authorization': `Bearer ${token}`
        }
    });
}
