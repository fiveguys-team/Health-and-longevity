package com.example.livecommerce_server.order;

import com.example.livecommerce_server.order.dto.OrderPageDTO;
import com.example.livecommerce_server.order.mapper.OrderMapper;
import com.example.livecommerce_server.order.service.OrderServiceImpl;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.BDDMockito.given;

@ExtendWith(MockitoExtension.class)
public class OrderServiceTest {
    @Mock
    private OrderMapper orderMapper;

    @InjectMocks
    private OrderServiceImpl orderService;

    @Test
    @DisplayName("getOrderPage: 존재하는 productId 조회 시 DTO 반환")
    void getOrderPage() {
        OrderPageDTO mockDto = new OrderPageDTO();
        mockDto.setProductId("1");
        mockDto.setName("테스트 상품");
        mockDto.setPrice(12345);
        mockDto.setStockCount(10);

        //해당 DB가 있는 것 처럼..
        given(orderMapper.findOrderPageByProductId("1"))
                .willReturn(mockDto);

        OrderPageDTO result = orderService.getOrderPage("1");

        assertThat(result).isSameAs(mockDto);
        assertThat(result.getName()).isEqualTo("테스트 상품");
        assertThat(result.getPrice()).isEqualTo(12345);

    }


}
