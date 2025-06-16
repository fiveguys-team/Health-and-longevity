package com.example.livecommerce_server.cart.controller;

import com.example.livecommerce_server.cart.dto.CartDTO;
import com.example.livecommerce_server.cart.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;

    /**
     * 특정 사용자의 장바구니 조회
     * GET /api/cart/{userId}
     */
    @GetMapping("/{userId}")
    public CartDTO getOrCreateCartByUserId(@PathVariable("userId") Integer userId) {
        // 1) userId만 담은 DTO 생성
        CartDTO cartDTO = new CartDTO();
        cartDTO.setUserId(userId);

        // 2) 기존 장바구니 조회
        CartDTO existing = cartService.findCartByUserId(cartDTO);
        if (existing != null) {
            return existing;
        }

        // 3) 없으면 신규 생성
        cartService.addCart(cartDTO);

        // 4) cartId가 세팅된 cartDTO 반환
        return cartDTO;
    }
}
