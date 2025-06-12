package com.example.livecommerce_server.order.service;

import com.example.livecommerce_server.order.dto.*;
import com.example.livecommerce_server.order.mapper.OrderMapper;
import com.example.livecommerce_server.payment.mapper.PaymentMapper;
import com.example.livecommerce_server.payment.service.PaymentService;
import com.example.livecommerce_server.product.dto.ProductDTO;
import com.example.livecommerce_server.product.repository.ProductMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {
    private final OrderMapper orderMapper;
    private final ProductMapper productMapper;
    private final PaymentService paymentService;

    @Override
    public OrderPageDTO getOrderPage(String productId, int quantity) {
        OrderPageDTO dto = Optional.ofNullable(orderMapper.findOrderPageByProductId(productId))
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "상품을 찾을 수 없습니다"));

        int totalAmount = dto.getPrice() * quantity;
        int shippingFee = totalAmount >= 50000 ? 0 : 3000;
        int finalAmount = totalAmount + shippingFee;

        dto.setQuantity(quantity);
        dto.setTotalAmount(totalAmount);
        dto.setShippingFee(shippingFee);
        dto.setFinalAmount(finalAmount);

        return dto;
    }

    @Override
    public OrderPrepareResponseDTO addOrder(OrderPrepareRequestDTO orderPrepareRequestDTO) {
        //UUID 생성
        String orderId = UUID.randomUUID().toString();
        //주문 테이블 생성 시간
        String now = nowCompactString();

        //상품 ID 리스트 추출
        List<String> productIds = orderPrepareRequestDTO.getOrderItems().stream()
                .map(OrderItemRequestDTO::getProductId)
                .toList();

        //상품 정보 조회
        List<ProductDTO> products = productMapper.findProductsByProductId(productIds);
        Map<String, ProductDTO> productMap = products.stream().
                collect(Collectors.toMap(ProductDTO::getProductId, p -> p));

        //총 결제 금액 계산
        int totalAmount = 0;
        for(OrderItemRequestDTO item : orderPrepareRequestDTO.getOrderItems()) {
            ProductDTO product = productMap.get(item.getProductId());
            if (product == null) {
                throw new IllegalArgumentException("상품 정보 없음: " + item.getProductId());
            }

            int price = product.getPrice();
            int discountedPrice = price; //아직 할인 로직 (X)
            totalAmount += discountedPrice * item.getQuantity();
        }

        String paymentId = paymentService.addTempPaymentAndReturnId();

        // 주문 마스터 테이블 insert
        OrderInsertDTO orderInsertDTO = OrderInsertDTO.builder()
                .orderId(orderId)
                .paymentId(paymentId) // 결제 전 상태
                .userId(orderPrepareRequestDTO.getUserId())
                .orderStatusCode("PEND")
                .discountAmount(0)
                .orderDate(now)
                .createdAt(now)
                .totalAmount(totalAmount)
                .shippingReq(orderPrepareRequestDTO.getShippingRequest())
                .postalCode(orderPrepareRequestDTO.getPostalCode())
                .basicAddress(orderPrepareRequestDTO.getBasicAddress())
                .detailAddress(orderPrepareRequestDTO.getDetailedAddress())
                .build();
        orderMapper.insertOrder(orderInsertDTO);

        // 주문 상세 insert
        List<OrderItemInsertDTO> itemInsertDTOs = orderPrepareRequestDTO.getOrderItems().stream()
                .map(item -> OrderItemInsertDTO.builder()
                        .orderItemId(UUID.randomUUID().toString())
                        .orderId(orderId)
                        .productId(item.getProductId())
                        .quantity(item.getQuantity())
                        .createdAt(now)
                        .build())
                .collect(Collectors.toList());
        orderMapper.insertOrderItems(itemInsertDTOs);


        String orderName = generateOrderName(products);
        String customerName = "홍길동"; // 시큐리티로 자기 이름.

        return OrderPrepareResponseDTO.builder()
                .orderId(orderId)
                .amount(totalAmount)
                .orderName(orderName)
                .customerName(customerName)
                .build();
    }

    private String nowCompactString() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }

    private String generateOrderName(List<ProductDTO> products) {
        if (products.isEmpty()) return "상품 없음";
        if (products.size() == 1) return products.get(0).getName();
        return products.get(0).getName() + " 외 " + (products.size() - 1) + "건";
    }
}
