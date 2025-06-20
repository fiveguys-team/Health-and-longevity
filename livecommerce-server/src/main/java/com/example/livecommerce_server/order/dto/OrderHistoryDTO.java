package com.example.livecommerce_server.order.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderHistoryDTO {
    private String orderId;
    private String orderDate;
    private String paymentMethod;
    private int totalAmount;
    private List<OrderHistoryItemDTO> items;
}