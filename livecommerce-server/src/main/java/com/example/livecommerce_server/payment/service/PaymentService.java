package com.example.livecommerce_server.payment.service;

import com.example.livecommerce_server.payment.dto.PaymentConfirmRequest;
import com.example.livecommerce_server.payment.dto.PaymentConfirmResponse;
import com.example.livecommerce_server.payment.dto.PaymentStatusUpdateDTO;
import com.fasterxml.jackson.core.JsonProcessingException;

public interface PaymentService {
    String addTempPaymentAndReturnId();
    PaymentConfirmResponse confirmPayment(PaymentConfirmRequest req) throws JsonProcessingException;
    boolean cancelPayment(PaymentStatusUpdateDTO dto);
    void modifyStockCountByOrderId(String orderId);

}
