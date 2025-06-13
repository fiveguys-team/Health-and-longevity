package com.example.livecommerce_server.chat.vo;

import lombok.*;

import java.time.LocalDateTime;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class ChatMessage {
    private Long messageId;          // 메시지 ID (PK, AUTO_INCREMENT)
    private String content;          // 메시지 내용
    private LocalDateTime createdAt; // 메시지 생성 시간
    private Long userId;             // 사용자 ID (FK)
    private Long roomId;             // 채팅방 ID (FK)

}
