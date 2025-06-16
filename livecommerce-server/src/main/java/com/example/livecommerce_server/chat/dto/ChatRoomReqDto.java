package com.example.livecommerce_server.chat.dto;


import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 채팅방 자동 생성을 위한 요청 DTO
 * 이 클래스는 liveId를 전달받아 채팅방을 생성할 때 사용됩니다.
 */
@Data
public class ChatRoomReqDto {

    /**
     * 연동된 라이브 방소의 고유ID(UUID)
     *
     */
    @NotNull
    private String liveId;

    // 응답용 필드들
    private Long roomId;
    private String announcement;
}
