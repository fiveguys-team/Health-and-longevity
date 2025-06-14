package com.example.livecommerce_server.test;

import com.example.livecommerce_server.common.config.CustomUserDetails;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/test")
public class TestController {

    @GetMapping("/ping")
    public ResponseEntity<?> ping() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails customUserDetails = (CustomUserDetails) authentication.getPrincipal();
        String email = customUserDetails.getEmail();
        String id = customUserDetails.getUserId();
        String name = customUserDetails.getName();
        String role = customUserDetails.getRole();

        Map<String, Object> result = new HashMap<>();
        result.put("message", "토큰 인증 성공!");
        result.put("status", "OK");
        result.put("email", email);
        result.put("id", id);
        result.put("name", name);
        result.put("role", role);
        return ResponseEntity.ok().body(result);
    }
}
