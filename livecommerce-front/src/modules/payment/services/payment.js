// payment.js

import axios from 'axios'

const API_BASE_URL = 'http://localhost:8080/api/payment';

/**
 * 결제 승인 요청
 * @param {string} paymentKey
 * @param {string} orderId
 * @param {number} amount
 * @returns {Promise<Object>} Toss 응답 데이터
 */
export async function confirmPayment({ paymentKey, orderId, amount }) {
    try {
        const response = await axios.post(`${API_BASE_URL}/confirm`, {
            paymentKey,
            orderId,
            amount
        })
        return response.data
    } catch (error) {
        console.error('❌ [confirmPayment] 서버 승인 실패:', error)
        throw error
    }
}
