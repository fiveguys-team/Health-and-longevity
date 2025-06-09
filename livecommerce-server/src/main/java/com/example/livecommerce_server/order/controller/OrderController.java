package com.example.livecommerce_server.order.controller;

import com.example.livecommerce_server.order.dto.OrderPageDTO;
import com.example.livecommerce_server.order.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/order")
@RequiredArgsConstructor
public class OrderController {
    private final OrderService orderService;

    /**
     * 주문 페이지 렌더링에 필요한 상품 정보 + 수량을 반환
     * GET /order?productId={productId}&quantity={quantity}
     */
    @GetMapping
    public OrderPageDTO getOrderPage(
            @RequestParam String productId,
            @RequestParam(defaultValue = "1") int quantity
    ) {
        return orderService.getOrderPage(productId);
    }
}