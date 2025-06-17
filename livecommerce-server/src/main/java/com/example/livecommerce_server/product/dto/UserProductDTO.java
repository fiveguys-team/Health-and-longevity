package com.example.livecommerce_server.product.dto;

import lombok.Data;

@Data
public class UserProductDTO {
    private String id;
    private String name;
    private String category;
    private String vendor;
    private String image;
    private int price;
    private int stockCount;
    private String status;
}
