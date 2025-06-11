package com.example.livecommerce_server.chat.service;


/**
 * 채팅 관련 비즈니스 로직을 처리하는 서비스 인터페이스
 * 이 인터페이스는 채팅방 생성, 메시지 조회, 신고 처리 등
 * 채팅 기능의 주요 로직을 정의합니다.
 */
public interface ChatService {


    Long createGroupRoom(String liveId);
}
