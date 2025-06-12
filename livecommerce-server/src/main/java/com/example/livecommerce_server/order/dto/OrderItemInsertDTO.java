package com.example.livecommerce_server.order.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderItemInsertDTO {
    private String orderItemId;
    private String orderId;
    private String productId;
    private Integer quantity;
    private String createdAt;
}
