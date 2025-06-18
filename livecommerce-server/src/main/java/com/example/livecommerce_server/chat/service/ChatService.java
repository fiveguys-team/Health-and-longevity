package com.example.livecommerce_server.chat.service;


import com.example.livecommerce_server.chat.dto.ChatRoomReqDto;


/**
 * 채팅 관련 비즈니스 로직을 처리하는 서비스 인터페이스
 * 🔄 세션 기반으로 변경됨
 */


import com.example.livecommerce_server.chat.dto.ChatRoomReqDto;

public interface ChatService {

    ChatRoomReqDto createGroupRoom(String liveId);

    /**
     * 🆕 세션 추적 기반 참여자 수 증가
     *
     * @param roomId 채팅방 ID
     * @param userId 사용자 ID
     * @param sessionId 세션 ID
     * @return 증가 후 참여자 수 (실제 사용자 수, -1: 실패)
     */
    int increaseParticipantCount(Long roomId, Long userId, String sessionId);

    /**
     * 🆕 세션 추적 기반 참여자 수 감소
     *
     * @param roomId 채팅방 ID
     * @param userId 사용자 ID
     * @param sessionId 세션 ID
     * @return 감소 후 참여자 수 (실제 사용자 수)
     */
    int decreaseParticipantCount(Long roomId, Long userId, String sessionId);

    /**
     * 채팅방 참여자 수 조회 (실제 사용자 수)
     *
     * @param roomId 채팅방 ID
     * @return 현재 참여자 수
     */
    int getParticipantCount(Long roomId);
}