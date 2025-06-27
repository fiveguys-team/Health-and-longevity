package com.example.livecommerce_server.chat.controller;


import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class WebSocketTestController {

    @GetMapping("/connect/test")
    public ResponseEntity<String> testWebSocket() {
        return ResponseEntity.ok("WebSocket endpoint is accessible");
    }
}
