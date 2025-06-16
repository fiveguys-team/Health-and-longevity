package com.example.livecommerce_server.order.service;

import com.example.livecommerce_server.order.dto.OrderPageDTO;
import com.example.livecommerce_server.order.dto.OrderPrepareRequestDTO;
import com.example.livecommerce_server.order.dto.OrderPrepareResponseDTO;

public interface OrderService {
    OrderPageDTO getOrderPage(String productId, int quantity);
    OrderPrepareResponseDTO addOrder(OrderPrepareRequestDTO orderPrepareRequestDTO);
    Integer getDiscountRateIfLiveOn(String productId);
    
}
