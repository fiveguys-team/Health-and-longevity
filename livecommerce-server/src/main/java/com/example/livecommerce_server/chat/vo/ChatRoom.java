package com.example.livecommerce_server.chat.vo;

import lombok.*;

import java.time.LocalDateTime;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class ChatRoom {
    private Long roomId;
    private String liveId;
    private Integer participantsCnt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

}
