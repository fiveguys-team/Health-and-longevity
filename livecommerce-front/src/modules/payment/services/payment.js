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

/**
 * 결제 중도 취소 (사용자 수동 취소 시)
 * @param {string} orderId
 * @returns {Promise<string>} 서버 응답 메시지
 */
export async function cancelPayment(orderId) {
    try {
        const response = await axios.post(`${API_BASE_URL}/cancel`, {
            orderId,
            status: 'CNCL'
        });
        return response.data;
    } catch (error) {
        console.error('❌ [cancelPayment] 결제 취소 실패:', error);
        throw error;
    }
}
