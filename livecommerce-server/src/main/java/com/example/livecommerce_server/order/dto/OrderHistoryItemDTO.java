package com.example.livecommerce_server.order.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderHistoryItemDTO {
    private String orderItemId;
    private String productId;
    private String productName;
    private String productImage;
    private int quantity;

    private String serviceCode;      // 'REFD' or 'EXCH'
    private String serviceStatus;    // 'REQ', 'DONE', 등
}
