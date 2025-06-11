package com.example.livecommerce_server.chat.service;

import com.example.livecommerce_server.chat.dto.ChatMessageReqDto;
import com.example.livecommerce_server.chat.mapper.ChatMessageMapper;
import com.example.livecommerce_server.chat.vo.ChatMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatMessageServiceImpl implements ChatMessageService {

    private final ChatMessageMapper chatMessageMapper;
    @Override
    public void addMessage(ChatMessageReqDto messageDto) {

        try {
            // DTO를 VO로 변환 (Builder 패턴 사용)
            ChatMessage chatMessage = ChatMessage.builder()
                    .content(messageDto.getContent())
                    .userId(messageDto.getUserId())
                    .roomId(messageDto.getRoomId())
                    .createdAt(messageDto.getCreatedAt() != null ?
                            messageDto.getCreatedAt() : LocalDateTime.now())
                    .build();

            // 데이터베이스에 저장
            int result = chatMessageMapper.insertChatMessage(chatMessage);

            if (result > 0) {
                log.info("채팅 메시지 저장 성공 - 채팅방 ID: {}, 사용자 ID: {}",
                        messageDto.getRoomId(), messageDto.getUserId());
            } else {
                log.warn("채팅 메시지 저장 실패 - 채팅방 ID: {}, 사용자 ID: {}",
                        messageDto.getRoomId(), messageDto.getUserId());
                throw new RuntimeException("메시지 저장에 실패했습니다.");
            }

        } catch (Exception e) {
            log.error("채팅 메시지 저장 중 오류 발생 - 채팅방 ID: {}, 사용자 ID: {}, 오류: {}",
                    messageDto.getRoomId(), messageDto.getUserId(), e.getMessage(), e);
            throw new RuntimeException("메시지 저장 중 오류가 발생했습니다.", e);
        }
    }
}
