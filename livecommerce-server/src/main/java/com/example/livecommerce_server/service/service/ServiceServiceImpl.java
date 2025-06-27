package com.example.livecommerce_server.service.service;

import com.example.livecommerce_server.service.dto.ServiceRequestDTO;
import com.example.livecommerce_server.service.mapper.ServiceMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ServiceServiceImpl implements ServiceService {

    private final ServiceMapper serviceMapper;

    @Override
    public void addServiceRequest(ServiceRequestDTO requestDTO) {
        // UUID 생성
        requestDTO.setServiceId(UUID.randomUUID().toString());
        requestDTO.setCreatedAt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        requestDTO.setUpdateAt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));

        // 1. 환불인 경우: order_item_d에서 paid_amount 조회 후 refund_amount로 세팅
        if ("REFD".equals(requestDTO.getServiceCode())) {
            Integer paidAmount = serviceMapper.selectPaidAmountByOrderItemId(requestDTO.getOrderItemId());
            if (paidAmount == null) {
                throw new IllegalArgumentException("유효하지 않은 주문 항목 ID입니다: " + requestDTO.getOrderItemId());
            }
            requestDTO.setRefundAmount(paidAmount);
        } else {
            // 교환일 경우 환불 금액은 0
            requestDTO.setRefundAmount(0);
        }

        // service_status는 MyBatis XML에서 'REQ'로 처리함
        serviceMapper.insertServiceRequest(requestDTO);
    }

    @Override
    public void updateServiceStatus(String orderItemId, String statusCode) {
        serviceMapper.updateServiceStatus(orderItemId, statusCode);
    }



    private String nowCompactString() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }

}