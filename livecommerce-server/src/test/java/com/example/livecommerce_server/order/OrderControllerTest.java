package com.example.livecommerce_server.order;

import com.example.livecommerce_server.order.controller.OrderController;
import com.example.livecommerce_server.order.dto.OrderPageDTO;
import com.example.livecommerce_server.order.service.OrderService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(OrderController.class)
public class OrderControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private OrderService orderService;



    @Test
    @DisplayName("GET /order?productId=1 정상호출 테스트")
    void getOrderPage_success() throws Exception {
        OrderPageDTO orderPageDTO = new OrderPageDTO();
        orderPageDTO.setProductId("1");
        orderPageDTO.setName("테스트 상품");
        orderPageDTO.setPrice(12345);
        orderPageDTO.setStockCount(10);

        given(orderService.getOrderPage("1")).willReturn(orderPageDTO);

        mockMvc.perform(get("/order") // get /order 엔드포인트 호출.
                        .param("productId", "1") // 쿼리파라미터 productId=1 추가
                        .accept(MediaType.APPLICATION_JSON)) // 헤더를 application/json 설정
                .andExpect(status().isOk()) // HTTP 코드가 200인지 검증
                .andExpect(jsonPath("$.productId").value("1")) //json 검증
                .andExpect(jsonPath("$.name").value("테스트 상품")) //json 검증
                .andExpect(jsonPath("$.price").value(12345)); //json 검증
    }

}
