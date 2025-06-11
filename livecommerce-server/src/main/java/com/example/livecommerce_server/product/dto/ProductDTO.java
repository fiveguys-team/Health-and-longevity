package com.example.livecommerce_server.product.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProductDTO {
    private String productId;
    private Long categoryId;
    private Long vendorId;
    private String name;
    private Integer price;
    private Integer stockCount;
    private String status;
    private String productImage;
}
