package com.example.livecommerce_server.payment.mapper;

import com.example.livecommerce_server.payment.dto.PaymentDTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PaymentMapper {
    int insertTempPayment(PaymentDTO paymentDTO);
}
