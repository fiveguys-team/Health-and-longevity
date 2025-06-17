package com.example.livecommerce_server.product.dto;

import lombok.Data;

@Data
public class ProductDetailUserDTO {
    // product 테이블 정보
    private String id;
    private String name;
    private String vendor;
    private int price;
    private int stockCount;
    private String productImage;
    private String category;

    // product_detail 테이블 정보
    private Long certNo;
    private String expiryDate;
    private String approvalDate;
    private String howToTake;
    private String mainFunction;
    private String precautions;
    private String storageMethod;
    private String standard;
    private String ingredients;
    private String productName;
}
