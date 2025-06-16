package com.example.livecommerce_server.payment.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentRefundUpdateDTO {
    private String paymentKey;  // 결제 키로 조건 찾기
    private String status;      // 보통 "REFD"
    private String payload;     // Toss 환불 응답 JSON 통째로 저장
}
