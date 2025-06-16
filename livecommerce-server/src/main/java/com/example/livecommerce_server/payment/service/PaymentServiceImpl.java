package com.example.livecommerce_server.payment.service;

import com.example.livecommerce_server.order.dto.OrderStatusUpdateDTO;
import com.example.livecommerce_server.order.mapper.OrderMapper;
import com.example.livecommerce_server.order.service.OrderService;
import com.example.livecommerce_server.payment.dto.*;
import com.example.livecommerce_server.payment.mapper.PaymentMapper;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class PaymentServiceImpl implements PaymentService {
    private final OrderMapper orderMapper;
    private final PaymentMapper paymentMapper;
    private final RestTemplate restTemplate = new RestTemplate();

    @Override
    public String addTempPaymentAndReturnId() {
        String uuid = UUID.randomUUID().toString();
        PaymentDTO paymentDTO = PaymentDTO.builder()
                .paymentsId(uuid)
                .paymentMethod("PEND")
                .paymentPayload("{}")
                .paidAt("NOT_YET")
                .createdAt(nowCompactString())
                .paymentStatusCode("PEND")
                .build();

        paymentMapper.insertTempPayment(paymentDTO);
        return uuid;
    }

    @Override
    public PaymentConfirmResponse confirmPayment(PaymentConfirmRequest req) throws JsonProcessingException {

        // 1. Toss API 호출
        HttpHeaders headers = new HttpHeaders();
        String secretKey = "test_gsk_docs_OaPz8L5KdmQXkzRz3y47BMw6"; // 환경변수로 분리 예정 (지금은 테스트키니까)
        String encodedAuth = Base64.getEncoder().encodeToString((secretKey + ":").getBytes());
        headers.set("Authorization", "Basic " + encodedAuth);
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<PaymentConfirmRequest> httpEntity = new HttpEntity<>(req, headers);

        ResponseEntity<PaymentConfirmResponse> tossResponse = restTemplate.exchange(
                "https://api.tosspayments.com/v1/payments/confirm",
                HttpMethod.POST,
                httpEntity,
                PaymentConfirmResponse.class
        );

        PaymentConfirmResponse result = tossResponse.getBody();

        // 2. DB 업데이트
        OrderStatusUpdateDTO orderStatusDTO = OrderStatusUpdateDTO.builder()
                .orderId(req.getOrderId())
                .status(result.getStatus())
                .build();
        orderMapper.updateOrderStatusByOrderId(orderStatusDTO);

        PaymentSuccessUpdateDTO paymentDTO = PaymentSuccessUpdateDTO.builder()
                .orderId(req.getOrderId())
                .status(result.getStatus())
                .approvedAt(formatApprovedAt(result.getApprovedAt()))
                .method(result.getMethod())
                .paymentKey(result.getPaymentKey())
                .payload(new ObjectMapper().writeValueAsString(result))
                .build();
        paymentMapper.updatePaymentSuccessByOrderId(paymentDTO);

        try {
            if ("DONE".equalsIgnoreCase(result.getStatus())) {
                modifyStockCountByOrderId(req.getOrderId());
            }
        } catch (Exception e) {
            // 재고 차감 실패 → 결제 취소 시도
            refundPayment(result.getPaymentKey(), "재고부족"); // 직접 구현 필요
            throw new IllegalStateException("결제는 완료되었으나 재고 차감 실패로 인해 결제 취소 처리됨", e);
        }

        return result;
    }

    @Override
    public void modifyStockCountByOrderId(String orderId) {
        int affected = orderMapper.updateStockCountByOrderId(orderId);
        if (affected == 0) {
            throw new IllegalStateException("재고 부족 또는 재고 차감 실패");
        }
    }

    @Override
    public boolean cancelPayment(PaymentStatusUpdateDTO paymentStatusUpdateDTO) {

        int updatedPayment = paymentMapper.updatePaymentStatusByOrderId(paymentStatusUpdateDTO);

        int updatedOrder = orderMapper.updateOrderStatusByOrderId(
                OrderStatusUpdateDTO.builder()
                        .orderId(paymentStatusUpdateDTO.getOrderId())
                        .status(paymentStatusUpdateDTO.getStatus()) // "CANCL"
                        .build()
        );

        return updatedPayment > 0 && updatedOrder > 0;
    }

    public void refundPayment(String paymentKey, String reason) {
        HttpHeaders headers = new HttpHeaders();
        String secretKey = "test_gsk_docs_OaPz8L5KdmQXkzRz3y47BMw6";
        String encodedAuth = Base64.getEncoder().encodeToString((secretKey + ":").getBytes());
        headers.set("Authorization", "Basic " + encodedAuth);
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, String> cancelPayload = new HashMap<>();
        cancelPayload.put("cancelReason", reason != null ? reason : "재고 부족으로 인한 자동 취소");

        HttpEntity<Map<String, String>> entity = new HttpEntity<>(cancelPayload, headers);

        ResponseEntity<String> response = restTemplate.exchange(
                "https://api.tosspayments.com/v1/payments/" + paymentKey + "/cancel",
                HttpMethod.POST,
                entity,
                String.class
        );

        // ✅ 콘솔에 응답 로그 출력
        System.out.println("=== 결제 취소 응답 ===");
        System.out.println("Status: " + response.getStatusCode());
        System.out.println("Body: " + response.getBody());
    }

    private String nowCompactString() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }

    private String formatApprovedAt(String iso8601) {
        return OffsetDateTime.parse(iso8601)
                .toLocalDateTime()
                .format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }
}
