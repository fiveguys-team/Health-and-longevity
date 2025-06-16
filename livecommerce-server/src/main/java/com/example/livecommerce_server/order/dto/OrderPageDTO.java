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

    // 🆕 추가 필드
    private Integer originalPrice;     // 할인 전 가격 (개당)
    private Integer discountRate;      // 할인률 (예: 10은 10%)
    private Integer discountAmount;    // 할인 금액 (개당 차감된 금액)


    // 👇 추가 필드 (계산용)
    private Integer quantity;      // 요청한 수량
    private Integer totalAmount;   // 상품 총액 (price * quantity)
    private Integer shippingFee;   // 배송비 (조건에 따라 0원 or 3천원 등)
    private Integer finalAmount;   // 최종 결제 금액 (총액 + 배송비)

}
