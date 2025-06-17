package com.example.livecommerce_server.live.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class ProductInfo {
//    private String id;
//    private String name;
//    private Integer price;
    private String productId;
    private String name;
    private int price;
    private int stock;
    private String image;
} 