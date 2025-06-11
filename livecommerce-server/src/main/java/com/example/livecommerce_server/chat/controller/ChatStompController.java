package com.example.livecommerce_server.chat.controller;

import com.example.livecommerce_server.chat.dto.ChatMessageReqDto;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.time.LocalDateTime;

@Controller
@RequiredArgsConstructor
public class ChatStompController {

    private final SimpMessagingTemplate messageTemplate;



    @MessageMapping("/chat/send/{roomId}")
    public void sendMessage(@DestinationVariable Long roomId, ChatMessageReqDto messageDto) {
        System.out.println("받은 메시지: " + messageDto.getMessage());

        // 메시지에 시간 추가
        messageDto.setCreatedAt(LocalDateTime.now());

        // 모든 구독자에게 메시지 전송
        messageTemplate.convertAndSend("/topic/" + roomId, messageDto);
    }


}
