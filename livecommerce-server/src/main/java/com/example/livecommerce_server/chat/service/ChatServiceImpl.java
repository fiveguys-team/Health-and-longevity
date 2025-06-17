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
 * 채팅 서비스 구현 클래스
 * 채팅방 생성, 메시지 저장 등 핵심 비즈니스 로직을 처리합니다.
 */
@Slf4j
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
    public ChatRoomReqDto  createGroupRoom(String liveId) {
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
     * 채팅방 참여자 수 증가
     *
     * @param roomId 채팅방 ID
     * @return 업데이트 성공 여부
     */
    @Override
    @Transactional
    public int increaseParticipantCount(Long roomId) {
        try {
            if (!isRoomExists(roomId)) {
                log.warn("채팅방을 찾을 수 없습니다. roomId={}", roomId);
                return -1;
            }

            int result = chatRoomMapper.updateParticipantCount(roomId, 1);
            if (result > 0) {
                int count = getParticipantCount(roomId);
                log.info("참여자 수 증가 성공. roomId: {}, 현재: {}", roomId, count);
                return count;
            }

            return -1;

        } catch (Exception e) {
            log.error("참여자 수 증가 중 오류 발생. roomId: {}", roomId, e);
            return -1;
        }
    }


    /**
     * 채팅방 참여자 수 감소
     *
     * @param roomId 채팅방 ID
     * @return 업데이트 성공 여부
     */
    @Override
    @Transactional
    public int decreaseParticipantCount(Long roomId) {
        try {
            int currentCount = getParticipantCount(roomId);
            if (currentCount <= 0) {
                log.warn("참여자 수가 이미 0입니다. roomId: {}", roomId);
                return currentCount;
            }

            int result = chatRoomMapper.updateParticipantCount(roomId, -1);
            if (result > 0) {
                int newCount = getParticipantCount(roomId);
                log.info("참여자 수 감소 성공. roomId: {}, 현재: {}", roomId, newCount);
                return newCount;
            }

            return currentCount;

        } catch (Exception e) {
            log.error("참여자 수 감소 중 오류 발생. roomId: {}", roomId, e);
            return -1;
        }
    }

    /**
     * 채팅방 참여자 수 조회
     *
     * @param roomId 채팅방 ID
     * @return 현재 참여자 수
     */
    @Override
    public int getParticipantCount(Long roomId) {
        try {
            // 1. Optional로 안전하게 조회
            // → 채팅방이 없으면 0 반환
            return chatRoomMapper.selectParticipantCount(roomId)
                    .orElse(0);

        } catch (Exception e) {
            log.error("참여자 수 조회 중 오류 발생. roomId: {}", roomId, e);
            return 0;
        }
    }



    /**
     * 채팅방 존재 여부 확인 (내부 사용)
     *
     * @param roomId 채팅방 ID
     * @return 존재 여부
     */
    private boolean isRoomExists(Long roomId) {
        // 참여자 수 조회 결과가 있으면 채팅방 존재
        return chatRoomMapper.selectParticipantCount(roomId).isPresent();
    }
}


