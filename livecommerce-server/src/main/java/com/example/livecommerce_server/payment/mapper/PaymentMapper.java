package com.example.livecommerce_server.payment.mapper;

import com.example.livecommerce_server.payment.dto.PaymentDTO;
import com.example.livecommerce_server.payment.dto.PaymentUpdateDTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PaymentMapper {

    int insertTempPayment(PaymentDTO paymentDTO);

    // 결제 상태 및 결제 상세 정보 업데이트 (orderId 기준)
    int updatePaymentByOrderId(PaymentUpdateDTO paymentUpdateDTO);

}
