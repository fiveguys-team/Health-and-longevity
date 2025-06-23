package com.example.livecommerce_server.ai.controller;

import com.example.livecommerce_server.ai.service.AiTestService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/ai")
@RequiredArgsConstructor
public class AiTestController {
    private final AiTestService aiTestService;

    @GetMapping("test")
    public String testAiResponse() {
        return aiTestService.getTestResponse();
    }
}
