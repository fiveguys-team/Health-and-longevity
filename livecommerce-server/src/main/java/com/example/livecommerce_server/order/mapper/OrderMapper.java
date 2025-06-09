package com.example.livecommerce_server.order.mapper;

import com.example.livecommerce_server.order.dto.OrderPageDTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderMapper {
    OrderPageDTO findOrderPageByProductId(String productId);
}
