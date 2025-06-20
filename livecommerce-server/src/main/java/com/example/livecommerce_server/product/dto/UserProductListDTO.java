package com.example.livecommerce_server.product.dto;

import lombok.Data;

@Data
public class UserProductListDTO {
    private String id;
    private String name;
    private String category;
    private String vendor;
    private String image;
    private int price;
    private int stockCount;
    private String status;

    private Integer discountRate;       // 할인율 (null 또는 0이면 비할인)
    private Integer discountedPrice;    // 할인된 가격
}
