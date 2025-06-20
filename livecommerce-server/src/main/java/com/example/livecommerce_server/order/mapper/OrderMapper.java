package com.example.livecommerce_server.order.mapper;

import com.example.livecommerce_server.order.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface OrderMapper {
    //구매하기 클릭시 상품정보를 조회
    OrderPageDTO findOrderPageByProductId(String productId);

    // 주문시 마스터 테이블 insert
    int insertOrder(OrderInsertDTO  orderInsertDTO);

    // 주문시 상세 테이블 inset  << 여러개가 insert 될 수 있기 때문에 List
    int insertOrderItems(List<OrderItemInsertDTO>  orderItemInsertDTOs);

    int updateOrderStatusByOrderId(OrderStatusUpdateDTO dto);

    int updateStockCountByOrderId(String orderId);

    Integer selectDiscountRateByProductIdIfLiveOn(String productId);

    List<OrderHistoryDTO> findOrderHistoryByUserId(@Param("userId") int userId);
}
