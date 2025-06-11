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

}
