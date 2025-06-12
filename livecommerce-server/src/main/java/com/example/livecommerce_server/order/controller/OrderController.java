package com.example.livecommerce_server.order.controller;

import com.example.livecommerce_server.order.dto.OrderPageDTO;
import com.example.livecommerce_server.order.dto.OrderPrepareRequestDTO;
import com.example.livecommerce_server.order.dto.OrderPrepareResponseDTO;
import com.example.livecommerce_server.order.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/order")
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
            @RequestParam(defaultValue = "1") int quantity) {
        return orderService.getOrderPage(productId);
    }

    // 결제 전 임시 주문 저장
    @PostMapping("/prepare")
    public ResponseEntity<OrderPrepareResponseDTO> prepareOrder(@RequestBody OrderPrepareRequestDTO requestDTO) {
        OrderPrepareResponseDTO responseDTO = orderService.addOrder(requestDTO);
        return ResponseEntity.ok(responseDTO);
    }
}