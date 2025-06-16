package com.example.livecommerce_server.cart.service;

import com.example.livecommerce_server.cart.dto.CartDTO;
import com.example.livecommerce_server.cart.mapper.CartMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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

    private String nowCompactString() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }
}
