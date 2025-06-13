package com.example.livecommerce_server.order.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderInsertDTO {
    private String orderId;         // UUID
    private String paymentId;
    private Integer userId;
    private String orderStatusCode; // 초기값: "PEND"
    private Integer discountAmount;
    private String orderDate;
    private Integer totalAmount;
    private String shippingReq;
    private String postalCode;
    private String basicAddress;
    private String detailAddress;
    private String createdAt;
}
