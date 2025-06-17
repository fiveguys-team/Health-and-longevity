package com.example.livecommerce_server.cart.mapper;

import com.example.livecommerce_server.cart.dto.CartDTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CartMapper {
    /**
     * 사용자(userId)에 매핑된 장바구니 조회
     * @param cartDTO userId를 담은 CartDTO 객체
     * @return CartDTO (없으면 null)
     */
    CartDTO selectCartByUserId(CartDTO cartDTO);

    /**
     * 신규 장바구니 생성
     * @param cartDTO CartDTO 객체 (cartId, userId 필수)
     */
    void insertCart(CartDTO cartDTO);
}
