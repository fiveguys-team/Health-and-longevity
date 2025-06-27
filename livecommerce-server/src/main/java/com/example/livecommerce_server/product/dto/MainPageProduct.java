package com.example.livecommerce_server.product.dto;

import lombok.Data;

@Data
public class MainPageProduct {
    private String productId;
    private String categoryId;
    private String productName;
    private String vendorName;
    private Integer price;
    private Integer stockCount;
    private String status;
    private String productImage;
}
