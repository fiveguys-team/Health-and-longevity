package com.example.livecommerce_server.order.service;

import com.example.livecommerce_server.order.dto.OrderPageDTO;
import com.example.livecommerce_server.order.mapper.OrderMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true) //조회니까 읽기만...
public class OrderServiceImpl implements OrderService {
    private final OrderMapper orderMapper;

    @Override
    public OrderPageDTO getOrderPage(String productId) {
        return Optional.ofNullable(orderMapper.findOrderPageByProductId(productId))
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "상품을 찾을 수 없습니다"));

    }
}
