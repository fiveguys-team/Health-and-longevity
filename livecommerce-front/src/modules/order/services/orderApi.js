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

/**
 * 장바구니 항목 목록 조회 API 호출
 * @param {string} cartId - 장바구니 ID
 * @returns {Promise} - Axios 응답 프로미스
 */
export async function getCartItems(cartId) {
    return axios.get(`${API_BASE_URL}/cart/items/${cartId}`, {
        headers: {
            'Content-Type': 'application/json',
        }
    });
}

/**
 * 장바구니 항목 추가 API 호출
 * @param {Object} payload - 추가할 장바구니 항목 정보
 * @param {string} payload.cartId - 장바구니 ID
 * @param {string} payload.productId - 상품 ID
 * @param {number} payload.quantity - 담을 수량
 * @returns {Promise} - Axios 응답 프로미스
 */
export async function addCartItem(payload) {
    return axios.post(`${API_BASE_URL}/cart/items`, payload, {
        headers: {
            'Content-Type': 'application/json',
        }
    });
}

/**
 * 장바구니 항목 수량 수정 API 호출
 * @param {Object} payload - 수정할 항목 정보
 * @param {string} payload.cartItemId - 장바구니 항목 ID
 * @param {number} payload.quantity - 변경할 수량
 * @returns {Promise} - Axios 응답 프로미스
 */
export async function updateCartItemQuantity(payload) {
    return axios.put(`${API_BASE_URL}/cart/items`, payload, {
        headers: {
            'Content-Type': 'application/json',
        }
    });
}

/**
 * 장바구니 항목 삭제 API 호출
 * @param {string} cartItemId - 삭제할 장바구니 항목 ID
 * @returns {Promise} - Axios 응답 프로미스
 */
export async function deleteCartItem(cartItemId) {
    return axios.delete(`${API_BASE_URL}/cart/items/${cartItemId}`, {
        headers: {
            'Content-Type': 'application/json',
        }
    });
}

/**
 * 장바구니 다중 항목 삭제 API 호출
 * @param {string[]} cartItemIds - 삭제할 장바구니 항목 ID 배열
 * @returns {Promise} - Axios 응답 프로미스
 */
export async function deleteCartItems(cartItemIds) {
    return axios.delete(`${API_BASE_URL}/cart/items`, {
        headers: {
            'Content-Type': 'application/json',
        },
        data: cartItemIds,  // DELETE 메서드에서 body를 넘길 때는 data 필드에 담아야 함
    });
}

/**
 * 주문 내역 조회 API 호출
 * @param {number|string} userId - 사용자 ID
 * @returns {Promise} - Axios 응답 프로미스
 */
export async function getOrderHistoryByUserId(userId) {
    return axios.get(`${API_BASE_URL}/order/history`, {
        params: { userId },
        headers: {
            'Content-Type': 'application/json',
        }
    });
}

