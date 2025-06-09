package com.example.livecommerce_server.chat.dto;


import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ChatMessageReqDto  {

    private Long roomId;
    private Long userId;
    private String content;
    private LocalDateTime createdAt;

}
