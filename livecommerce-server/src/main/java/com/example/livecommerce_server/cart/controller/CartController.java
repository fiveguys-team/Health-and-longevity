package com.example.livecommerce_server.cart.controller;

import com.example.livecommerce_server.cart.dto.CartDTO;
import com.example.livecommerce_server.cart.dto.CartItemDTO;
import com.example.livecommerce_server.cart.dto.CartItemDetailDTO;
import com.example.livecommerce_server.cart.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;

    /**
     * 특정 사용자의 장바구니 조회 또는 생성
     * GET /api/cart/{userId}
     */
    @GetMapping("/{userId}")
    public ResponseEntity<CartDTO> getOrCreateCartDetail(@PathVariable("userId") Integer userId) {
        return ResponseEntity.ok(cartService.getOrCreateCartByUserId(userId));
    }

    /**
     * 장바구니 항목 전체 목록 조회
     * GET /api/cart/items/{cartId}
     */
    @GetMapping("/items/{cartId}")
    public ResponseEntity<List<CartItemDetailDTO>> CartItemList(@PathVariable("cartId") String cartId) {
        List<CartItemDetailDTO> items = cartService.findCartItemsByCartId(cartId);
        return ResponseEntity.ok(items);
    }

    /**
     * 장바구니에 상품 추가
     * POST /api/cart/items
     */
    @PostMapping("/items")
    public ResponseEntity<Void> CartItemAdd(@RequestBody CartItemDTO cartItemDTO) {
        cartService.addCartItem(cartItemDTO);
        return ResponseEntity.ok().build();
    }

    /**
     * 장바구니 수량 수정
     * PUT /api/cart/items
     */
    @PutMapping("/items")
    public ResponseEntity<Void> CartItemQuantityModify(@RequestBody CartItemDTO cartItemDTO) {
        cartService.updateCartItemQuantity(cartItemDTO);
        return ResponseEntity.ok().build();
    }

    /**
     * 장바구니 항목 삭제
     * DELETE /api/cart/items/{cartItemId}
     */
    @DeleteMapping("/items/{cartItemId}")
    public ResponseEntity<Void> CartItemRemove(@PathVariable("cartItemId") String cartItemId) {
        cartService.removeCartItem(cartItemId);
        return ResponseEntity.ok().build();
    }

    /**
     * 장바구니 항목 여러 개 삭제
     * DELETE /api/cart/items
     */
    @DeleteMapping("/items")
    public ResponseEntity<Void> removeCartItems(@RequestBody List<String> cartItemIds) {
        cartService.removeCartItems(cartItemIds);
        return ResponseEntity.ok().build();
    }


}
