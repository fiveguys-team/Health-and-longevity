package com.example.livecommerce_server.cart.service;

import com.example.livecommerce_server.cart.dto.CartDTO;
import com.example.livecommerce_server.cart.dto.CartItemDTO;
import com.example.livecommerce_server.cart.dto.CartItemDetailDTO;

import java.util.List;

public interface CartService {

    /**
     * 장바구니에 상품 추가
     *
     * @param cartItemDTO cartId, productId, quantity가 설정된 CartItemDTO 객체
     */
    void addCartItem(CartItemDTO cartItemDTO);

    /**
     * 장바구니 항목 수량 수정
     *
     * @param cartItemDTO cartItemId, quantity가 설정된 CartItemDTO 객체
     */
    void updateCartItemQuantity(CartItemDTO cartItemDTO);

    /**
     * 장바구니 항목 삭제
     *
     * @param cartItemId 삭제할 항목의 cart_item_id
     */
    void removeCartItem(String cartItemId);

    void removeCartItems(List<String> cartItemIds);

    /**
     * 장바구니 ID로 전체 항목 조회 (할인, 재고 포함)
     *
     * @param cartId 조회 대상 장바구니 ID
     * @return CartItemDetailDTO 목록
     */
    List<CartItemDetailDTO> findCartItemsByCartId(String cartId);

    CartDTO getOrCreateCartByUserId(Integer userId);
}
