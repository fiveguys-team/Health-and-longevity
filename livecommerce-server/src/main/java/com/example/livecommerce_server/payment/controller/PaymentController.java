package com.example.livecommerce_server.payment.controller;

import com.example.livecommerce_server.payment.dto.PaymentConfirmRequest;
import com.example.livecommerce_server.payment.dto.PaymentConfirmResponse;
import com.example.livecommerce_server.payment.service.PaymentService;
import com.fasterxml.jackson.core.JsonProcessingException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/payment")
public class PaymentController {
    private final PaymentService paymentService;

    @PostMapping("/confirm")
    public ResponseEntity<PaymentConfirmResponse> confirmPayment
            (@RequestBody PaymentConfirmRequest paymentConfirmRequest) throws JsonProcessingException {
        PaymentConfirmResponse paymentConfirmResponse = paymentService.confirmPayment(paymentConfirmRequest);
        return ResponseEntity.ok(paymentConfirmResponse);
    }
}
