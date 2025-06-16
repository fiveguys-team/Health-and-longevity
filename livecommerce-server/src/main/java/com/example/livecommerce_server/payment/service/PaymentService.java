package com.example.livecommerce_server.payment.service;

import com.example.livecommerce_server.payment.dto.PaymentConfirmRequest;
import com.example.livecommerce_server.payment.dto.PaymentConfirmResponse;
import com.example.livecommerce_server.payment.dto.PaymentRefundUpdateDTO;
import com.example.livecommerce_server.payment.dto.PaymentStatusUpdateDTO;
import com.fasterxml.jackson.core.JsonProcessingException;

public interface PaymentService {
    String addTempPaymentAndReturnId();
    PaymentConfirmResponse confirmPayment(PaymentConfirmRequest req) throws JsonProcessingException;
    boolean cancelPayment(PaymentStatusUpdateDTO dto);
    void modifyStockCountByOrderId(String orderId);

    /**
     * 결제 환불 상태를 업데이트합니다.
     * @param paymentRefundUpdateDTO 환불 관련 정보(PaymentKey, 상태, payload 등)
     * @return 업데이트된 행 수
     */
    int updateRefundStatus(PaymentRefundUpdateDTO paymentRefundUpdateDTO);

}
