package com.example.livecommerce_server.order.service;

import com.example.livecommerce_server.order.dto.OrderPageDTO;

public interface OrderService {
    OrderPageDTO getOrderPage(String productId);
}
