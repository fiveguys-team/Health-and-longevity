package com.example.livecommerce_server.cart.service;

import com.example.livecommerce_server.cart.dto.CartDTO;
import com.example.livecommerce_server.cart.dto.CartItemDTO;
import com.example.livecommerce_server.cart.dto.CartItemDetailDTO;
import com.example.livecommerce_server.cart.mapper.CartMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CartServiceImpl implements CartService {
    private final CartMapper cartMapper;
    @Override
    public CartDTO findCartByUserId(CartDTO cartDTO) {
        return cartMapper.selectCartByUserId(cartDTO);
    }

    @Override
    public void addCart(CartDTO cartDTO) {
        if (cartDTO.getCartId() == null || cartDTO.getCartId().isEmpty()) {
            cartDTO.setCartId(UUID.randomUUID().toString());
            cartDTO.setCreatedAt(nowCompactString());
        }
        cartMapper.insertCart(cartDTO);
    }

    @Override
    public void addCartItem(CartItemDTO cartItemDTO) {
        Map<String, Object> param = Map.of(
                "cartId", cartItemDTO.getCartId(),
                "productId", cartItemDTO.getProductId()
        );

        int count = cartMapper.existsCartItemByCartIdAndProductId(param);

        if (count > 0) {
            // 수량만 증가
            param = Map.of(
                    "cartId", cartItemDTO.getCartId(),
                    "productId", cartItemDTO.getProductId(),
                    "quantity", cartItemDTO.getQuantity()
            );
            cartMapper.incrementCartItemQuantity(param);
        } else {
            // 새로 추가
            if (cartItemDTO.getCartItemId() == null || cartItemDTO.getCartItemId().isEmpty()) {
                cartItemDTO.setCartItemId(UUID.randomUUID().toString());
            }
            if (cartItemDTO.getCreatedAt() == null) {
                cartItemDTO.setCreatedAt(nowCompactString()); // 문자열 형태면 String 반환 함수
            }
            cartMapper.insertCartItem(cartItemDTO);
        }
    }

    @Override
    public void updateCartItemQuantity(CartItemDTO cartItemDTO) {
        cartMapper.updateCartItemQuantity(cartItemDTO);
    }

    @Override
    public void removeCartItem(String cartItemId) {
        cartMapper.deleteCartItemById(cartItemId);
    }

    @Override
    public void removeCartItems(List<String> cartItemIds) {
        cartMapper.deleteCartItemsByIds(cartItemIds);
    }

    @Override
    public List<CartItemDetailDTO> findCartItemsByCartId(String cartId) {
        return cartMapper.selectCartItemsByCartId(cartId);
    }

    @Override
    public CartDTO getOrCreateCartByUserId(Integer userId) {
        CartDTO param = CartDTO.builder().userId(userId).build();

        CartDTO cart = cartMapper.selectCartByUserId(param);
        if (cart != null) return cart;

        // 없으면 생성
        String cartId = UUID.randomUUID().toString();
        String createdAt = nowCompactString();

        CartDTO newCart = CartDTO.builder()
                .userId(userId)
                .cartId(cartId)
                .createdAt(createdAt)
                .build();

        cartMapper.insertCart(newCart);

        return newCart; // or cartMapper.selectCartByUserId(param) 로 재조회
    }


    private String nowCompactString() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }
}
