package com.example.livecommerce_server.order.service;

import com.example.livecommerce_server.order.dto.*;

import java.util.List;

public interface OrderService {
    OrderPageDTO getOrderPage(String productId, int quantity);
    OrderPrepareResponseDTO addOrder(OrderPrepareRequestDTO orderPrepareRequestDTO);
    Integer getDiscountRateIfLiveOn(String productId);


    /**
     * 특정 유저의 주문 내역 조회
     * @param userId 사용자 ID
     * @return 주문 내역 리스트
     */
    List<OrderHistoryDTO> findOrderHistoryByUserId(int userId);

    /**
     * 입점업체(userId)가 등록한 상품의 주문내역을 조회한다.
     *
     * @param userId 로그인한 입점업체의 사용자 ID
     * @return 주문내역 리스트 (환불/교환 요청 정보 포함)
     */
    List<VendorOrderHistoryDTO> findOrderHistoryByVendorUserId(Integer userId);

}
