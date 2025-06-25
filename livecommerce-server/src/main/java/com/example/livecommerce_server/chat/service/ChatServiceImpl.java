package com.example.livecommerce_server.chat.service;

import com.example.livecommerce_server.chat.dto.ChatRoomReqDto;
import com.example.livecommerce_server.chat.mapper.ChatRoomMapper;
import com.example.livecommerce_server.chat.vo.ChatRoom;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

/**
 * 채팅 서비스 구현 클래스 (Redis 적용 버전)
 * 채팅방 생성, 메시지 저장 등 핵심 비즈니스 로직을 처리합니다.
 *
 * 변경사항:
 * - 참여자 수 관리: RDB → Redis Set
 * - 성능 향상: SQL UPDATE → Redis SADD/SREM
 */

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatServiceImpl implements ChatService {

    private final ChatRoomMapper chatRoomMapper;

    // 🆕 세션 추적 기반 Redis 참여자 관리 서비스
    private final ChatParticipantRedisService participantRedisService;

    @Override
    public ChatRoomReqDto createGroupRoom(String liveId) {
        // 1. 채팅방 생성
        ChatRoom chatRoom = ChatRoom.builder()
                .liveId(liveId)
                .participantsCnt(0)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        chatRoomMapper.insertChatRoom(chatRoom);

        // 2. announcement 조회
        String announcement = chatRoomMapper.selectAnnouncementByLiveId(liveId);

        // 3. 응답 DTO 생성
        ChatRoomReqDto response = new ChatRoomReqDto();
        response.setRoomId(chatRoom.getRoomId());
        response.setLiveId(liveId);
        response.setAnnouncement(announcement);

        return response;
    }

    /**
     * 🆕 세션 추적 기반 참여자 수 증가
     */
    @Override
    public int increaseParticipantCount(Long roomId, Long userId, String sessionId) {
        try {
            if (!isRoomExists(roomId)) {
                log.warn("❌ 채팅방을 찾을 수 없습니다. roomId={}", roomId);
                return -1;
            }

            // 세션 추적 방식으로 사용자 세션 추가
            int count = participantRedisService.addUserSession(roomId, userId, sessionId);

            log.info("✅ 참여자 수 증가 완료 (세션 추적) - roomId: {}, userId: {}, sessionId: {}, 현재 사용자: {}명",
                    roomId, userId, sessionId, count);

            return count;

        } catch (Exception e) {
            log.error("❌ 참여자 수 증가 중 오류 발생 - roomId: {}, userId: {}, sessionId: {}",
                    roomId, userId, sessionId, e);
            return -1;
        }
    }

    /**
     * 🆕 세션 추적 기반 참여자 수 감소
     */
    @Override
    public int decreaseParticipantCount(Long roomId, Long userId, String sessionId) {
        try {
            // 세션 추적 방식으로 사용자 세션 제거
            int count = participantRedisService.removeUserSession(roomId, userId, sessionId);

            log.info("✅ 참여자 수 감소 완료 (세션 추적) - roomId: {}, userId: {}, sessionId: {}, 현재 사용자: {}명",
                    roomId, userId, sessionId, count);

            return count;

        } catch (Exception e) {
            log.error("❌ 참여자 수 감소 중 오류 발생 - roomId: {}, userId: {}, sessionId: {}",
                    roomId, userId, sessionId, e);
            return -1;
        }
    }

    /**
     * 채팅방 참여자 수 조회 (실제 사용자 수)
     */
    @Override
    public int getParticipantCount(Long roomId) {
        try {
            // Redis에서 실제 사용자 수 조회
            return participantRedisService.getParticipantCount(roomId)
                    .orElse(0);

        } catch (Exception e) {
            log.error("❌ 참여자 수 조회 중 오류 발생 - roomId: {}", roomId, e);
            return 0;
        }
    }

    /**
     * 채팅방 존재 여부 확인 (내부 사용)
     */
    private boolean isRoomExists(Long roomId) {
        return chatRoomMapper.selectParticipantCount(roomId).isPresent();
    }
}


