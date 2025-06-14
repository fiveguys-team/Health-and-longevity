package com.example.livecommerce_server.payment.service;

import com.example.livecommerce_server.payment.dto.PaymentConfirmRequest;
import com.example.livecommerce_server.payment.dto.PaymentConfirmResponse;
import com.fasterxml.jackson.core.JsonProcessingException;

public interface PaymentService {
    String addTempPaymentAndReturnId();
    PaymentConfirmResponse confirmPayment(PaymentConfirmRequest req) throws JsonProcessingException;
}
