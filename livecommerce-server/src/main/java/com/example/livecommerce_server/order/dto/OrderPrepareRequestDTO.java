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
public class OrderPrepareRequestDTO {
    private Integer userId;
    private List<OrderItemRequestDTO> orderItems;

    private String shippingRequest;
    private String postalCode;
    private String basicAddress;
    private String detailedAddress;

}
