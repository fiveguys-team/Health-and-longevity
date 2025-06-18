package com.example.livecommerce_server.cart.mapper;

import com.example.livecommerce_server.cart.dto.CartDTO;
import com.example.livecommerce_server.cart.dto.CartItemDTO;
import com.example.livecommerce_server.cart.dto.CartItemDetailDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

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

    /**
     * 장바구니에 상품 추가
     * @param cartItemDTO 장바구니 항목 DTO
     */
    void insertCartItem(CartItemDTO cartItemDTO);

    /**
     * 장바구니 항목 수량 수정
     * @param cartItemDTO 장바구니 항목 DTO
     */
    void updateCartItemQuantity(CartItemDTO cartItemDTO);

    /**
     * 장바구니 항목 삭제
     * @param cartItemId 삭제할 항목 ID
     */
    void deleteCartItemById(String cartItemId);

    /**
     * 여러 장바구니 항목 삭제
     * @param cartItemIds 삭제할 항목 ID 목록
     */
    void deleteCartItemsByIds(List<String> cartItemIds);

    /**
     * 장바구니 ID로 장바구니 항목들 조회 (할인/재고/가격 계산 포함)
     * @param cartId 장바구니 ID
     * @return 장바구니 상세 항목 리스트
     */
    List<CartItemDetailDTO> selectCartItemsByCartId(String cartId);

    /**
     * 장바구니에 해당 상품이 이미 존재하는지 확인
     * @param param cartId, productId 포함 Map
     * @return 존재하면 1 이상, 없으면 0
     */
    int existsCartItemByCartIdAndProductId(java.util.Map<String, Object> param);

    /**
     * 장바구니 항목 수량 증가
     * @param param cartId, productId, quantity 포함 Map
     */
    void incrementCartItemQuantity(java.util.Map<String, Object> param);
}
