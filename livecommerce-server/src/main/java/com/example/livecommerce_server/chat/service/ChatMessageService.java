package com.example.livecommerce_server.chat.service;

import com.example.livecommerce_server.chat.dto.ChatMessageReqDto;

public interface ChatMessageService {

    /**
     * 채팅 메시지 저장
     *
     * @param messageDto 저장할 메시지 정보
     */
    void addMessage(ChatMessageReqDto messageDto);
}
