//package com.example.livecommerce_server.chat.service;
//
//
//import com.example.livecommerce_server.chat.dto.ChatRoomReqDto;
//
///**
// * 채팅 관련 비즈니스 로직을 처리하는 서비스 인터페이스
// * 이 인터페이스는 채팅방 생성, 메시지 조회, 신고 처리 등
// * 채팅 기능의 주요 로직을 정의합니다.
// */
//
///**
// * 채팅 관련 비즈니스 로직을 처리하는 서비스 인터페이스
// * 🔄 세션 기반으로 변경됨
// */
//public interface ChatService2 {
//
//    ChatRoomReqDto createGroupRoom(String liveId);
//
//    /**
//     * 채팅방 참여자 수 증가
//     *
//     * @param roomId 채팅방 ID
//     * @param userId 사용자 ID
//     * @return 업데이트된 참여자 수 (-1: 실패)
//     */
//    int increaseParticipantCount(Long roomId, Long userId);
//
//    /**
//     * 채팅방 참여자 수 감소
//     *
//     * @param roomId 채팅방 ID
//     * @param userId 사용자 ID
//     * @return 업데이트된 참여자 수
//     */
//    int decreaseParticipantCount(Long roomId, Long userId);
//
//    /**
//     * 채팅방 참여자 수 조회
//     *
//     * @param roomId 채팅방 ID
//     * @return 현재 참여자 수
//     */
//    int getParticipantCount(Long roomId);
//}
