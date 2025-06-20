package com.example.livecommerce_server.order.service;

import com.example.livecommerce_server.common.config.CustomUserDetails;
import com.example.livecommerce_server.order.dto.*;
import com.example.livecommerce_server.order.mapper.OrderMapper;
import com.example.livecommerce_server.payment.mapper.PaymentMapper;
import com.example.livecommerce_server.payment.service.PaymentService;
import com.example.livecommerce_server.product.dto.ProductDTO;
import com.example.livecommerce_server.product.repository.ProductMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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

        int originalPrice = dto.getPrice(); // 할인 전 원래 가격
        Integer discountRate = getDiscountRateIfLiveOn(productId); // null일 수 있음
        int discountAmount = 0;
        int finalUnitPrice = originalPrice;

        if (discountRate != null && discountRate > 0) {
            discountAmount = originalPrice * discountRate / 100;
            finalUnitPrice = originalPrice - discountAmount;
        }

        int totalAmount = finalUnitPrice * quantity;
        int shippingFee = totalAmount >= 50000 ? 0 : 3000;
        int finalAmount = totalAmount + shippingFee;

        dto.setOriginalPrice(originalPrice);
        dto.setDiscountRate(discountRate);
        dto.setDiscountAmount(discountAmount);
        dto.setPrice(finalUnitPrice);  // 할인 적용된 개당 가격

        dto.setQuantity(quantity);
        dto.setTotalAmount(totalAmount);
        dto.setShippingFee(shippingFee);
        dto.setFinalAmount(finalAmount);

        return dto;
    }

    @Override
    public OrderPrepareResponseDTO addOrder(OrderPrepareRequestDTO orderPrepareRequestDTO) {
        // UUID 생성
        String orderId = UUID.randomUUID().toString();
        String now = nowCompactString();

        // 상품 ID 리스트 추출
        List<String> productIds = orderPrepareRequestDTO.getOrderItems().stream()
                .map(OrderItemRequestDTO::getProductId)
                .toList();

        // 상품 정보 조회
        List<ProductDTO> products = productMapper.findProductsByProductId(productIds);
        Map<String, ProductDTO> productMap = products.stream()
                .collect(Collectors.toMap(ProductDTO::getProductId, p -> p));

        int totalAmount = 0;
        int totalDiscountAmount = 0;

        for (OrderItemRequestDTO item : orderPrepareRequestDTO.getOrderItems()) {
            ProductDTO product = productMap.get(item.getProductId());
            if (product == null) {
                throw new IllegalArgumentException("상품 정보 없음: " + item.getProductId());
            }

            int originalPrice = product.getPrice();
            Integer discountRate = getDiscountRateIfLiveOn(product.getProductId());
            int discountAmount = 0;
            int finalUnitPrice = originalPrice;

            if (discountRate != null && discountRate > 0) {
                discountAmount = originalPrice * discountRate / 100;
                finalUnitPrice = originalPrice - discountAmount;
            }

            totalAmount += finalUnitPrice * item.getQuantity();
            totalDiscountAmount += discountAmount * item.getQuantity();
        }

        // 배송비 정책: 5만원 미만이면 3000원 추가
        int shippingFee = (totalAmount < 50000) ? 3000 : 0;
        int finalAmount = totalAmount + shippingFee;

        // 결제 ID 생성
        String paymentId = paymentService.addTempPaymentAndReturnId();

        // 주문 마스터 insert
        OrderInsertDTO orderInsertDTO = OrderInsertDTO.builder()
                .orderId(orderId)
                .paymentId(paymentId)
                .userId(orderPrepareRequestDTO.getUserId())
                .orderStatusCode("PEND")
                .discountAmount(totalDiscountAmount)
                .orderDate(now)
                .createdAt(now)
                .totalAmount(finalAmount) // 배송비 포함
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

        // 주문명 생성
        String orderName = generateOrderName(products);
        String customerName = "테스트커스터머"; // 추후 Security 기반 이름 사용 가능

        return OrderPrepareResponseDTO.builder()
                .orderId(orderId)
                .amount(finalAmount)
                .orderName(orderName)
                .customerName(customerName)
                .build();
    }


    @Override
    public Integer getDiscountRateIfLiveOn(String productId) {
        return orderMapper.selectDiscountRateByProductIdIfLiveOn(productId);
    }


    @Override
    public List<OrderHistoryDTO> findOrderHistoryByUserId(int userId) {
        return orderMapper.findOrderHistoryByUserId(userId);
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
