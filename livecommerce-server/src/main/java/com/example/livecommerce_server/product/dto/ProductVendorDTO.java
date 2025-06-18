// src/main/java/com/example/livecommerce_server/product/dto/VendorProductDTO.java
package com.example.livecommerce_server.product.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProductVendorDTO {
    private String productId;
    private String name;
    private int price;
    private int stockCount;
    private String productImage;
    private String vendor;

    private Integer discountRate;     // ex: 20 (%)
    private Integer discountedPrice;  // 할인가
}
