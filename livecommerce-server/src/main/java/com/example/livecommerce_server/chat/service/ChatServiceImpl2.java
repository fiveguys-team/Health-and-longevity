//package com.example.livecommerce_server.chat.service;
//
//import com.example.livecommerce_server.chat.dto.ChatRoomReqDto;
//import com.example.livecommerce_server.chat.mapper.ChatRoomMapper;
//import com.example.livecommerce_server.chat.vo.ChatRoom;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.stereotype.Service;
//
//import java.time.LocalDateTime;
//
///**
// * 채팅 서비스 구현 클래스 (Redis 적용 버전)
// * 채팅방 생성, 메시지 저장 등 핵심 비즈니스 로직을 처리합니다.
// *
// * 변경사항:
// * - 참여자 수 관리: RDB → Redis Set
// * - 성능 향상: SQL UPDATE → Redis SADD/SREM
// */
//
//@Slf4j
//@Service
//@RequiredArgsConstructor
//public class ChatServiceImpl2 implements ChatService {
//
//    private final ChatRoomMapper chatRoomMapper;
//
//    // Redis 참여자 관리 서비스 추가
//    private final ChatParticipantRedisService participantRedisService;
//
//    /**
//     * 전달받은 liveId를 기반으로 채팅방을 생성하고,
//     * 생성된 채팅방의 ID(PK)를 반환합니다.
//     *
//     * @param liveId 라이브 방송 고유 ID
//     * @return 생성된 채팅방의 roomId (PK)
//     */
//    @Override
//    public ChatRoomReqDto createGroupRoom(String liveId) {
//        // 1. 채팅방 생성
//        ChatRoom chatRoom = ChatRoom.builder()
//                .liveId(liveId)
//                .participantsCnt(0)
//                .createdAt(LocalDateTime.now())
//                .updatedAt(LocalDateTime.now())
//                .build();
//
//        chatRoomMapper.insertChatRoom(chatRoom);
//
//        // 2. announcement 조회
//        String announcement = chatRoomMapper.selectAnnouncementByLiveId(liveId);
//
//        // 3. 응답 DTO 생성
//        ChatRoomReqDto response = new ChatRoomReqDto();
//        response.setRoomId(chatRoom.getRoomId());
//        response.setLiveId(liveId);
//        response.setAnnouncement(announcement);
//
//        return response;
//    }
//
//    /**
//     * 채팅방 참여자 수 증가 (Redis 방식)
//     *
//     * - 기존: UPDATE participants_cnt = participants_cnt + 1
//     * - 현재: SADD chat:participants:{roomId} {userId}
//     *
//     * @param roomId 채팅방 ID
//     * @param userId 참여하는 사용자 ID
//     * @return 업데이트된 참여자 수
//     */
//    @Override
//    public int increaseParticipantCount(Long roomId, Long userId) {
//        try {
//            if (!isRoomExists(roomId)) {
//                log.warn("❌ 채팅방을 찾을 수 없습니다. roomId={}", roomId);
//                return -1;
//            }
//
//            // Redis Set에 사용자 추가
//            int count = participantRedisService.addParticipant(roomId, userId);
//
//            log.info("✅ 참여자 수 증가 완료 (Redis) - roomId: {}, userId: {}, 현재: {}명",
//                    roomId, userId, count);
//
//            return count;
//
//        } catch (Exception e) {
//            log.error("❌ 참여자 수 증가 중 오류 발생 - roomId: {}, userId: {}",
//                    roomId, userId, e);
//            return -1;
//        }
//    }
//
//    /**
//     * 채팅방 참여자 수 감소 (Redis 방식)
//     *
//     * @param roomId 채팅방 ID
//     * @param userId 퇴장하는 사용자 ID
//     * @return 업데이트된 참여자 수
//     */
//    @Override
//    public int decreaseParticipantCount(Long roomId, Long userId) {
//        try {
//            // Redis Set에서 사용자 제거
//            int count = participantRedisService.removeParticipant(roomId, userId);
//
//            log.info("✅ 참여자 수 감소 완료 (Redis) - roomId: {}, userId: {}, 현재: {}명",
//                    roomId, userId, count);
//
//            return count;
//
//        } catch (Exception e) {
//            log.error("❌ 참여자 수 감소 중 오류 발생 - roomId: {}, userId: {}",
//                    roomId, userId, e);
//            return -1;
//        }
//    }
//
//    /**
//     * 채팅방 참여자 수 조회 (Redis 방식)
//     *
//     * @param roomId 채팅방 ID
//     * @return 현재 참여자 수
//     */
//    @Override
//    public int getParticipantCount(Long roomId) {
//        try {
//            // Redis에서 참여자 수 조회
//            return participantRedisService.getParticipantCount(roomId)
//                    .orElse(0);
//
//        } catch (Exception e) {
//            log.error("❌ 참여자 수 조회 중 오류 발생 - roomId: {}", roomId, e);
//            return 0;
//        }
//    }
//
//    /**
//     * 채팅방 존재 여부 확인 (내부 사용)
//     *
//     * @param roomId 채팅방 ID
//     * @return 존재 여부
//     */
//    private boolean isRoomExists(Long roomId) {
//        // 참여자 수 조회 결과가 있으면 채팅방 존재
//        return chatRoomMapper.selectParticipantCount(roomId).isPresent();
//    }
//}
//
//
