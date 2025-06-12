package com.example.livecommerce_server.payment.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentDTO {
    private String paymentsId;
    private String paymentMethod;
    private String paymentKey;
    private String paymentPayload;
    private String paidAt;
    private String createdAt;
    private String paymentStatusCode;
}
