package com.example.livecommerce_server.product.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminProductDetailDTO {

    // product 테이블
    private String productId;
    private String name;           // 상품명
    private int price;             // 가격
    private int stockCount;        // 수량
    private String productImage;   // 이미지 파일명
    private String status;         // 상태 (PENDING, APPROVED 등)
    private String createdAt;      // 등록일자 (옵션)

    // vendor_m 테이블
    private String company;        // 업체명

    // product_detail 테이블
    private String certNo;         // 인증번호
    private String productName;    // 품목명
    private String expiryDate;     // 유통기한
    private String approvalDate;   // 허가일자
    private String howToTake;      // 섭취방법
    private String mainFunction;   // 주된 기능성
    private String precautions;    // 주의사항
    private String storageMethod;  // 보관방법
    private String standard;       // 기준규격
    private String ingredients;    // 원재료

    // 카테고리명은 필요 시 조인해서 추가 가능
    private int categoryId;
}
