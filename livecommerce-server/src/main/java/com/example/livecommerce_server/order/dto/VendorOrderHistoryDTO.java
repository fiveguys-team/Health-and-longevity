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
public class VendorOrderHistoryDTO {
    private String orderId;
    private String orderDate;
    private Integer totalAmount;
    private List<VendorOrderItemDTO> items;
}
