package com.example.livecommerce_server.product.dto;

import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
public class ProductListDTO {
    private String id;
    private String name;
    private String category;     // ✅ 추가
    private String vendor;       // ✅ 기존 company -> vendor로
    private String image;
    private int price;
    private int stockCount;
    private String status;
}
