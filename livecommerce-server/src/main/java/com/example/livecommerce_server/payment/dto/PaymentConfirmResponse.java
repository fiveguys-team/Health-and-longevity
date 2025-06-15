package com.example.livecommerce_server.payment.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentConfirmResponse {
    private String paymentKey;
    private String orderId;
    private String orderName;
    private String status;               // DONE, CANCELED, FAILED
    private String approvedAt;
    private String method;               // 카드, 간편결제 등
    private int totalAmount;
    private int suppliedAmount;
    private int vat;
    private String receiptUrl;
    private String easyPayProvider;     // 간편결제 제공자 (ex. 토스페이)
    private CardInfo card;              // 카드 결제일 경우
}
