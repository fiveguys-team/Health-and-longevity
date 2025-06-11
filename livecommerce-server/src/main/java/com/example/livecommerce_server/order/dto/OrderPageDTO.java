package com.example.livecommerce_server.order.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderPageDTO {

    private String productId;
    private Integer price;
    private Integer stockCount;
    private String productName;
    private String productImage;
    private String categoryName;

}
