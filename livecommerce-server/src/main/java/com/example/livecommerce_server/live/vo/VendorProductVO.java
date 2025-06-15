package com.example.livecommerce_server.live.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VendorProductVO {
	private String productId; // 상품 ID
	private String name; // 상품 이름
	private Integer price; // 상품 가격
	private Integer stock; // 재고
	private String image; // 상품 썸네일


}
