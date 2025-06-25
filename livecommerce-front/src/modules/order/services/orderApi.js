import axiosInstance from '@/api/axios';

/**
 * 주문 프리페어 API 호출
 * @param {Object} payload - 주문 요청 데이터
 * @param {string} token - JWT 토큰
 * @returns {Promise}
 */

export async function prepareOrder(payload) {
    return axiosInstance.post(`/api/order/prepare`, payload, {
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
    return axiosInstance.get(`/api/cart/${userId}`, {
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
    return axiosInstance.get(`/api/cart/items/${cartId}`, {
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
    return axiosInstance.post(`/api/cart/items`, payload, {
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
    return axiosInstance.put(`/api/cart/items`, payload, {
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
    return axiosInstance.delete(`/api/cart/items/${cartItemId}`, {
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
    return axiosInstance.delete(`/api/cart/items`, {
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
    return axiosInstance.get(`/api/order/history`, {
        params: { userId },
        headers: {
            'Content-Type': 'application/json',
        }
    });
}

/**
 * 교환/환불 요청 API 호출
 * @param {Object} payload - 요청 데이터
 * @param {string} payload.orderItemId - 주문 상세 항목 ID
 * @param {number} payload.userId - 사용자 ID
 * @param {string} payload.serviceCode - 요청 종류 ('REFD' | 'EXCH')
 * @param {string} payload.reason - 요청 사유
 * @param {string} payload.img - 첨부 이미지 URL
 * @returns {Promise} - Axios 응답 프로미스
 */
export async function requestService(payload) {
    return axiosInstance.post(`api/service/request`, payload, {
        headers: {
            'Content-Type': 'application/json',
        }
    });
}

