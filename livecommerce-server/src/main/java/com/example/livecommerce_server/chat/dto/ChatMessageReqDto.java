package com.example.livecommerce_server.chat.dto;


import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ChatMessageReqDto  {

    private Long roomId;       // 채팅방 ID
    private Long userId;       // 보낸 사용자 ID
    private String userName;   // 사용자 이름 (화면 표시용)
    private String content;    // 메시지 내용
    private LocalDateTime createdAt; // 클라이언트에서 보낼 수도 있음 (옵션)


    /**
     * 시스템 경고 메시지를 생성합니다.
     *
     * @param content 경고 메시지 내용
     * @param roomId 채팅방 ID
     * @return 시스템 메시지 DTO
     */
    public static ChatMessageReqDto createWarningMessage(String content, Long roomId) {
        ChatMessageReqDto warningMessage = new ChatMessageReqDto();
        warningMessage.setContent(content);
        warningMessage.setRoomId(roomId);
        warningMessage.setUserId(0L); // 시스템 메시지는 0번
        warningMessage.setUserName("시스템");
        warningMessage.setCreatedAt(LocalDateTime.now());
        return warningMessage;
    }
}

