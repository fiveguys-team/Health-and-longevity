package com.example.livecommerce_server.live.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 입점업체가 방송 준비 시 판매 가능한 상품 정보를 담는 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VendorProductDTO {
	private String productId; // 상품 ID
	private String name; // 상품 이름
	private Integer price; // 상품 가격
	private Integer stock; // 재고
	private String image; // 상품 썸네일

}
