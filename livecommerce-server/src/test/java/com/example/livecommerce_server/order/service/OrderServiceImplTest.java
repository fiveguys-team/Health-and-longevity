package com.example.livecommerce_server.order.service;

import com.example.livecommerce_server.order.dto.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
@ActiveProfiles("test")  // src/test/resources/application-test.yml 사용
class OrderServiceImplTest {

    @Autowired(required = false)
    private OrderService orderService;

    @Test
    @DisplayName("주문 페이지 정보 조회 (정상)")
    void getOrderPageTest() {
        // given
        String productId = "1";
        int quantity = 3;

        // when
        OrderPageDTO result = orderService.getOrderPage(productId, quantity);

        // then
        assertNotNull(result);
        assertEquals(quantity, result.getQuantity());
        assertTrue(result.getTotalAmount() > 0);
        assertTrue(result.getFinalAmount() >= result.getTotalAmount());
    }

    @Test
    @DisplayName("주문 정보 및 결제 준비 데이터 생성")
    void addOrderTest() {
        // given
        String productId = "1"; // test DB에 존재하는 상품 ID 사용
        int quantity = 2;

        OrderItemRequestDTO item = OrderItemRequestDTO.builder()
                .productId(productId)
                .quantity(quantity)
                .build();

        OrderPrepareRequestDTO request = OrderPrepareRequestDTO.builder()
                .userId(1) // test DB에 존재하는 유저 ID 사용
                .orderItems(List.of(item))
                .shippingRequest("문 앞에 두세요")
                .postalCode("12345")
                .basicAddress("서울시 강남구")
                .detailedAddress("101동 202호")
                .build();

        // when
        OrderPrepareResponseDTO result = orderService.addOrder(request);

        // then
        assertNotNull(result);
        assertNotNull(result.getOrderId());
        assertTrue(result.getAmount() > 0);
        assertNotNull(result.getOrderName());
        assertEquals("홍길동", result.getCustomerName()); // 하드코딩된 값 확인
    }
}
