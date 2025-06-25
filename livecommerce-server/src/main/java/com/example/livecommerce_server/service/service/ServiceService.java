package com.example.livecommerce_server.service.service;

import com.example.livecommerce_server.service.dto.ServiceRequestDTO;

public interface ServiceService {
    /**
     * 교환/환불 요청 등록
     * @param requestDTO 요청 정보 (orderItemId, userId, serviceCode, reason, img)
     */
    void addServiceRequest(ServiceRequestDTO requestDTO);
}
