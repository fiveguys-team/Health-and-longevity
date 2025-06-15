package com.example.livecommerce_server.payment.mapper;

import com.example.livecommerce_server.payment.dto.PaymentDTO;
import com.example.livecommerce_server.payment.dto.PaymentStatusUpdateDTO;
import com.example.livecommerce_server.payment.dto.PaymentSuccessUpdateDTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PaymentMapper {

    int insertTempPayment(PaymentDTO paymentDTO);

    // 결제 성공 기준 결제 상세 정보 업데이트 (orderId 기준)
    int updatePaymentSuccessByOrderId(PaymentSuccessUpdateDTO paymentUpdateDTO);

    int updatePaymentStatusByOrderId(PaymentStatusUpdateDTO paymentStatusUpdateDTO);

}
