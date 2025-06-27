package com.example.livecommerce_server.service.mapper;

import com.example.livecommerce_server.service.dto.ServiceRequestDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ServiceMapper {

    /**
     * 교환/환불 요청 저장
     * @param requestDTO 요청 DTO
     */
    void insertServiceRequest(ServiceRequestDTO requestDTO);

    int selectPaidAmountByOrderItemId(String orderItemId);

    /**
     * service_m 테이블에서 order_item_id에 해당하는 서비스 요청의 상태코드를 변경
     *
     * @param orderItemId 주문 상세 항목 ID
     * @param statusCode  변경할 상태 코드 ('COMP' or 'RJCT')
     */
    void updateServiceStatus(@Param("orderItemId") String orderItemId,
                             @Param("statusCode") String statusCode);
}
