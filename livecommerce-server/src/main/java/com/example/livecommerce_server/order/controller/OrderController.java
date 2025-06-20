package com.example.livecommerce_server.order.controller;

import com.example.livecommerce_server.order.dto.OrderHistoryDTO;
import com.example.livecommerce_server.order.dto.OrderPageDTO;
import com.example.livecommerce_server.order.dto.OrderPrepareRequestDTO;
import com.example.livecommerce_server.order.dto.OrderPrepareResponseDTO;
import com.example.livecommerce_server.order.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
        return orderService.getOrderPage(productId, quantity);
    }

    // 결제 전 임시 주문 저장
    @PostMapping("/prepare")
    public ResponseEntity<OrderPrepareResponseDTO> prepareOrder(@RequestBody OrderPrepareRequestDTO requestDTO) {
        OrderPrepareResponseDTO responseDTO = orderService.addOrder(requestDTO);
        return ResponseEntity.ok(responseDTO);
    }

    /**
     * 특정 유저의 주문내역 조회 API
     * @param userId 사용자 ID
     * @return 주문내역 리스트
     */
    @GetMapping("/history")
    public List<OrderHistoryDTO> getOrderHistory(@RequestParam("userId") int userId) {
        return orderService.findOrderHistoryByUserId(userId);
    }
}