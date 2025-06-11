package com.example.livecommerce_server.chat.service;

import com.example.livecommerce_server.chat.mapper.ChatRoomMapper;
import com.example.livecommerce_server.chat.vo.ChatRoom;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import lombok.extern.slf4j.Slf4j;

@SpringBootTest
@Slf4j
class ChatServiceImpTest {

    @Autowired
    private ChatService chatService;

    @Autowired
    private ChatRoomMapper chatRoomMapper;




    @Test
    @Transactional
    @DisplayName("채팅방 생성 테스트")
    void createGroupRoom() {
        // given
        String testLiveId = "550e8400-e29b-41d4-a716-446655440000";

        // when
        Long roomId = chatService.createGroupRoom(testLiveId);


        log.info("✅ 채팅방 생성 성공! 생성된 roomId: {}", roomId);

    }

}