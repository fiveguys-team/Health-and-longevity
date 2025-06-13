package com.example.livecommerce_server.order.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderPrepareResponseDTO {
    private String orderId;
    private int amount;
    private String orderName;
    private String customerName;
}
