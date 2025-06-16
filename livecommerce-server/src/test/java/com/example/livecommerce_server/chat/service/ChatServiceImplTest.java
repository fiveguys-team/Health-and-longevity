//package com.example.livecommerce_server.chat.service;
//
//import com.example.livecommerce_server.chat.dto.ChatRoomReqDto;
//import com.example.livecommerce_server.chat.mapper.ChatRoomMapper;
//import com.example.livecommerce_server.chat.vo.ChatRoom;
//import org.junit.jupiter.api.BeforeEach;
//import org.junit.jupiter.api.DisplayName;
//import org.junit.jupiter.api.Test;
//import org.junit.jupiter.api.extension.ExtendWith;
//import org.mockito.InjectMocks;
//import org.mockito.Mock;
//import org.mockito.junit.jupiter.MockitoExtension;
//
//import static org.assertj.core.api.Assertions.assertThat;
//import static org.junit.jupiter.api.Assertions.*;
//import static org.mockito.ArgumentMatchers.any;
//import static org.mockito.BDDMockito.given;
//import static org.mockito.Mockito.doAnswer;
//import static org.mockito.Mockito.times;
//
//@ExtendWith(MockitoExtension.class)
//class ChatServiceImplTest {
//    @Mock
//    private ChatRoomMapper chatRoomMapper;
//
//    @InjectMocks
//    private ChatServiceImpl chatService;
//
//    private String testLiveId;
//    private String testAnnouncement;
//
//    @BeforeEach
//    void setUp() {
//        testLiveId = "550e8400-e29b-41d4-a716-446655440000";
//        testAnnouncement = "라이브 방송 중에는 예의 바른 채팅 부탁드립니다.";
//    }
//
//    @Test
//    @DisplayName("채팅방 생성 성공 테스트")
//    void createGroupRoom_Success() {
//        // Given
//        Long expectedRoomId = 123L;
//
//        // Mapper의 동작을 Mock 처리
//        doAnswer(invocation -> {
//            ChatRoom chatRoom = invocation.getArgument(0);
//            // MyBatis가 자동으로 ID를 설정하는 것을 시뮬레이션
//            chatRoom.setRoomId(expectedRoomId);
//            return null;
//        }).when(chatRoomMapper).insertChatRoom(any(ChatRoom.class));
//
//        given(chatRoomMapper.selectAnnouncementByLiveId(testLiveId))
//                .willReturn(testAnnouncement);
//
//        // When
//        ChatRoomReqDto result = chatService.createGroupRoom(testLiveId);
//
//        // Then
//        assertThat(result).isNotNull();
//        assertThat(result.getRoomId()).isEqualTo(expectedRoomId);
//        assertThat(result.getLiveId()).isEqualTo(testLiveId);
//        assertThat(result.getAnnouncement()).isEqualTo(testAnnouncement);
//
//
//    }
//}