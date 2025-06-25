package com.example.livecommerce_server.service.mapper;

import com.example.livecommerce_server.service.dto.ServiceRequestDTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ServiceMapper {

    /**
     * 교환/환불 요청 저장
     * @param requestDTO 요청 DTO
     */
    void insertServiceRequest(ServiceRequestDTO requestDTO);

    int selectPaidAmountByOrderItemId(String orderItemId);
}
