package com.example.livecommerce_server.product.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProductListDTO {
    private String id;        // 상품 ID (product_id)
    private String name;      // 상품명 (product.name)
    private String company;   // 업체명 또는 회사명
    private String status;    // 승인 상태
}