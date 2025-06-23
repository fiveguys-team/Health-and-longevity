package com.example.livecommerce_server.ai.service;

import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AiTestService {
    private final ChatClient chatClient;

    public String getTestResponse() {
        String prompt = "50대 여성을 위한 건강기능식품을 3개 추천해줘.";
        return chatClient.prompt()
                .user(prompt)
                .call()
                .content();
    }
}
