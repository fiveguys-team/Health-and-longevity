package com.example.livecommerce_server.product.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DiscountedProductDTO {
    private String productId;
    private String name;
    private int price;             // 정상가
    private Integer discountRate;  // 할인율 (%)
    private Integer discountedPrice; // 실제 할인가
    private String productImage;
    private int stockCount;
    private String vendor;
}
