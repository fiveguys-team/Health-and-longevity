package com.example.livecommerce_server.payment.service;

import com.example.livecommerce_server.payment.dto.PaymentDTO;
import com.example.livecommerce_server.payment.mapper.PaymentMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PaymentServiceImpl implements PaymentService {
    private final PaymentMapper paymentMapper;

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

    private String nowCompactString() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }
}
