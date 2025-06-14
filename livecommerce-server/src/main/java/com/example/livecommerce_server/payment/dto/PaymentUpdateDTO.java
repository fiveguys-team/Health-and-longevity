package com.example.livecommerce_server.payment.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentUpdateDTO {
    private String orderId;            // 주문 ID (조건절: orders_m에서 payment_id 찾기 위함)
    private String paymentKey;
    private String status;            // 결제 상태 (DONE, FAILED, CANCELED 등)
    private String approvedAt;        // 승인 시간
    private String method;            // 결제 수단 (카드, 간편결제 등)
    private String payload;           // 결제 리스폰스 전체 (JSON String 등)
}
