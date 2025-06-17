package com.example.livecommerce_server.cart.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CartItemDetailDTO {
    private String cartItemId;
    private String productId;
    private String productName;
    private int quantity;
    private int price;
    private int stockCount;
    private int discountRate;
    private int appliedDiscountRate;
    private int discountedPrice;
}
