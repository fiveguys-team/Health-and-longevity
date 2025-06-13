package com.example.livecommerce_server.chat.service;

import com.example.livecommerce_server.chat.mapper.ChatRoomMapper;
import com.example.livecommerce_server.chat.vo.ChatRoom;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

/**
 * 채팅 서비스 구현 클래스
 * 채팅방 생성, 메시지 저장 등 핵심 비즈니스 로직을 처리합니다.
 */
@Service
@RequiredArgsConstructor
public class ChatServiceImpl implements ChatService {

    private final ChatRoomMapper chatRoomMapper;

    /**
     * 전달받은 liveId를 기반으로 채팅방을 생성하고,
     * 생성된 채팅방의 ID(PK)를 반환합니다.
     *
     * @param liveId 라이브 방송 고유 ID
     * @return 생성된 채팅방의 roomId (PK)
     */
    @Override
    public Long createGroupRoom(String liveId) {
        ChatRoom chatRoom = ChatRoom.builder()
                .liveId(liveId)
                .participantsCnt(0)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        chatRoomMapper.insertChatRoom(chatRoom);
        return chatRoom.getRoomId();
    }
}


