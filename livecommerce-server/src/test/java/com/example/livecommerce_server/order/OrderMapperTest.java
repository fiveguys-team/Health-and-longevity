package com.example.livecommerce_server.order;

import com.example.livecommerce_server.order.dto.OrderPageDTO;
import com.example.livecommerce_server.order.mapper.OrderMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mybatis.spring.boot.test.autoconfigure.MybatisTest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.test.context.jdbc.Sql;

import static org.assertj.core.api.Assertions.assertThat;

@MybatisTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.ANY)
@Sql("classpath:sql/test-product.sql")
public class OrderMapperTest {
    @Autowired
    private OrderMapper orderMapper;

    @Test
    @DisplayName("존재하는 productId 조회 시 OrderPageDTO 반환")
    void findOrderById() {
        OrderPageDTO orderPageDTO = orderMapper.findOrderPageByProductId("1");

        assertThat(orderPageDTO).isNotNull();
    }
}
