package com.example.livecommerce_server.cart.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CartItemDTO {
    private String cartItemId;
    private String cartId;
    private String productId;
    private Integer quantity;
    private String createdAt;
}
