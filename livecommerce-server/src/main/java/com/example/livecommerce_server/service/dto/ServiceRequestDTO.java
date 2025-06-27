package com.example.livecommerce_server.service.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ServiceRequestDTO {
    private String serviceId;         // UUID
    private String orderItemId;       // 주문 상세 ID (UUID)
    private String serviceCode;       // 'REFD' or 'EXCH'
    private String reason;            // 요청 사유
    private String img;               // 첨부 이미지 URL
    private Integer refundAmount;     // 환불 금액
    private String statusCode;        // 상태코드 ('REQ' 기본값으로 사용 가능)
    private String createdAt;         // 요청 시간 (yyyyMMddHHmmss)
    private String updateAt;         // 수정 시간 (yyyyMMddHHmmss)
}
