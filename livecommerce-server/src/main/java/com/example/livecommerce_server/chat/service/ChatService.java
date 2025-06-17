package com.example.livecommerce_server.chat.service;


import com.example.livecommerce_server.chat.dto.ChatRoomReqDto;

/**
 * 채팅 관련 비즈니스 로직을 처리하는 서비스 인터페이스
 * 이 인터페이스는 채팅방 생성, 메시지 조회, 신고 처리 등
 * 채팅 기능의 주요 로직을 정의합니다.
 */
public interface ChatService {


    ChatRoomReqDto createGroupRoom(String liveId);

    /**
     * 채팅방 참여자 수 증가
     *
     * @param roomId 채팅방 ID
     * @return 업데이트 성공 여부
     */
    int increaseParticipantCount(Long roomId);

    /**
     * 채팅방 참여자 수 감소
     *
     * @param roomId 채팅방 ID
     * @return 업데이트 성공 여부
     */
    int decreaseParticipantCount(Long roomId);

    /**
     * 채팅방 참여자 수 조회
     *
     * @param roomId 채팅방 ID
     * @return 현재 참여자 수
     */
    int getParticipantCount(Long roomId);
}
