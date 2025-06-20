package com.example.livecommerce_server.order.service;

import com.example.livecommerce_server.order.dto.OrderHistoryDTO;
import com.example.livecommerce_server.order.dto.OrderPageDTO;
import com.example.livecommerce_server.order.dto.OrderPrepareRequestDTO;
import com.example.livecommerce_server.order.dto.OrderPrepareResponseDTO;

import java.util.List;

public interface OrderService {
    OrderPageDTO getOrderPage(String productId, int quantity);
    OrderPrepareResponseDTO addOrder(OrderPrepareRequestDTO orderPrepareRequestDTO);
    Integer getDiscountRateIfLiveOn(String productId);


    /**
     * 특정 유저의 주문 내역 조회
     * @param userId 사용자 ID
     * @return 주문 내역 리스트
     */
    List<OrderHistoryDTO> findOrderHistoryByUserId(int userId);
    
}
