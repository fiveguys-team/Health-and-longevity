package com.example.livecommerce_server.order.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VendorOrderItemDTO {
    private String orderItemId;
    private String productId;
    private String productName;
    private String productImage;
    private Integer quantity;
    private Integer paidAmount;
    private String reason;
    private String img;

    private String serviceCode;   // 'REFD', 'EXCH' 등
    private String serviceStatus; // 'REQ', 'APRV', 'REJT' 등
}
