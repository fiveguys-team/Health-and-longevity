package com.example.livecommerce_server.payment.service;

import com.example.livecommerce_server.order.dto.OrderStatusUpdateDTO;
import com.example.livecommerce_server.order.mapper.OrderMapper;
import com.example.livecommerce_server.payment.dto.PaymentConfirmRequest;
import com.example.livecommerce_server.payment.dto.PaymentConfirmResponse;
import com.example.livecommerce_server.payment.dto.PaymentDTO;
import com.example.livecommerce_server.payment.dto.PaymentUpdateDTO;
import com.example.livecommerce_server.payment.mapper.PaymentMapper;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.UUID;

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
                .paymentMethod("TEMP")
                .paymentPayload("{}")
                .paidAt("NOT_YET")
                .createdAt(nowCompactString())
                .paymentStatusCode("TEMP")
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

        PaymentUpdateDTO paymentDTO = PaymentUpdateDTO.builder()
                .orderId(req.getOrderId())
                .status(result.getStatus())
                .approvedAt(formatApprovedAt(result.getApprovedAt()))
                .method(result.getMethod())
                .paymentKey(result.getPaymentKey())
                .payload(new ObjectMapper().writeValueAsString(result))
                .build();
        paymentMapper.updatePaymentByOrderId(paymentDTO);

        return result;
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
