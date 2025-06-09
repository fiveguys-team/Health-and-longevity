package com.example.livecommerce_server.order.service;

import com.example.livecommerce_server.order.dto.OrderPageDTO;
import com.example.livecommerce_server.order.mapper.OrderMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true) //조회니까 읽기만...
public class OrderServiceImpl implements OrderService {
    private final OrderMapper orderMapper;

    @Override
    public OrderPageDTO getOrderPage(String productId) {
        return orderMapper.findOrderPageByProductId(productId);
    }
}
