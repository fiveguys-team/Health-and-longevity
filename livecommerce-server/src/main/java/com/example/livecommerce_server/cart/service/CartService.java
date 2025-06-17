package com.example.livecommerce_server.cart.service;

import com.example.livecommerce_server.cart.dto.CartDTO;

public interface CartService {
    /**
     * 특정 사용자(userId)에 매핑된 장바구니 조회
     *
     * @param cartDTO userId를 담은 CartDTO 객체
     * @return CartDTO (해당 사용자의 장바구니가 없으면 null)
     */
    CartDTO findCartByUserId(CartDTO cartDTO);

    /**
     * 신규 장바구니 생성
     *
     * @param cartDTO cartId, userId가 설정된 CartDTO 객체
     */
    void addCart(CartDTO cartDTO);

}
