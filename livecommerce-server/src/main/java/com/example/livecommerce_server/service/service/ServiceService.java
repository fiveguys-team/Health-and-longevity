package com.example.livecommerce_server.service.service;

import com.example.livecommerce_server.service.dto.ServiceRequestDTO;

public interface ServiceService {
    /**
     * 교환/환불 요청 등록
     * @param requestDTO 요청 정보 (orderItemId, userId, serviceCode, reason, img)
     */
    void addServiceRequest(ServiceRequestDTO requestDTO);

    /**
     * 환불 또는 교환 요청에 대한 상태코드 변경 (승인 or 반려)
     *
     * @param orderItemId 주문 상세 항목 ID
     * @param statusCode  변경할 상태 코드 ('COMP' or 'RJCT')
     */
    void updateServiceStatus(String orderItemId, String statusCode);


}
