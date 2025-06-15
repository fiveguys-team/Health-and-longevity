package com.example.livecommerce_server.chat.service;

import com.example.livecommerce_server.chat.mapper.ChatRoomMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

/**
 * ChatService 단위 테스트 (Mock 사용)
 */
@ExtendWith(MockitoExtension.class)  // @SpringBootTest 대신 MockitoExtension 사용
class ChatServiceUnitTest {

    @Mock
    private ChatRoomMapper chatRoomMapper;

    @InjectMocks
    private ChatServiceImpl chatService;

    @Test
    @DisplayName("참여자 수 증가 테스트")
    void increaseParticipantCount() {
        // Given
        Long roomId = 1L;
        when(chatRoomMapper.selectParticipantCount(roomId))
                .thenReturn(Optional.of(5));  // 채팅방 존재, 현재 5명
        when(chatRoomMapper.updateParticipantCount(roomId, 1))
                .thenReturn(1);  // 업데이트 성공

        // When
        boolean result = chatService.increaseParticipantCount(roomId);

        // Then
        assertThat(result).isTrue();
    }

    @Test
    @DisplayName("참여자 수 감소 테스트")
    void decreaseParticipantCount() {
        // Given
        Long roomId = 1L;
        when(chatRoomMapper.selectParticipantCount(roomId))
                .thenReturn(Optional.of(5));  // 현재 5명
        when(chatRoomMapper.updateParticipantCount(roomId, -1))
                .thenReturn(1);  // 업데이트 성공

        // When
        boolean result = chatService.decreaseParticipantCount(roomId);

        // Then
        assertThat(result).isTrue();
    }

    @Test
    @DisplayName("참여자 수 조회 테스트")
    void getParticipantCount() {
        // Given
        Long roomId = 1L;
        when(chatRoomMapper.selectParticipantCount(roomId))
                .thenReturn(Optional.of(10));

        // When
        int count = chatService.getParticipantCount(roomId);

        // Then
        assertThat(count).isEqualTo(10);
    }

    @Test
    @DisplayName("채팅방이 없을 때 0 반환")
    void getParticipantCount_RoomNotFound() {
        // Given
        Long roomId = 999L;
        when(chatRoomMapper.selectParticipantCount(roomId))
                .thenReturn(Optional.empty());

        // When
        int count = chatService.getParticipantCount(roomId);

        // Then
        assertThat(count).isEqualTo(0);
    }
}