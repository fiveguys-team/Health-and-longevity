package com.example.livecommerce_server.payment.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CardInfo {
    private String number;
    private String cardType;         // 신용 or 체크
    private String ownerType;        // 개인 or 법인
    private int amount;
    private String approveNo;        // 승인번호
    private int installmentPlanMonths;
}
