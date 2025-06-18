//package com.example.livecommerce_server.chat.service;
//
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.data.redis.core.StringRedisTemplate;
//import org.springframework.stereotype.Service;
//
//import java.util.Optional;
//
///**
// * Redis Set을 활용한 채팅방 참여자 수 관리 서비스
// *
// * Redis 키 구조:
// * - chat:participants:{roomId} → Set<userId>
// *
// * 예시:
// * - chat:participants:123 → {100, 200, 300} (사용자 ID들)
// * - 참여자 수 = Set의 크기
// */
//@Service
//@RequiredArgsConstructor
//@Slf4j
//public class ChatParticipantRedisService2 {
//
//    private final StringRedisTemplate stringRedisTemplate;
//
//    // Redis 키 패턴 상수
//    private static final String PARTICIPANT_KEY_PREFIX = "chat:participants:";
//
//    /**
//     * 채팅방에 참여자 추가
//     *
//     * @param roomId 채팅방 ID
//     * @param userId 사용자 ID
//     * @return 추가 후 총 참여자 수
//     */
//    public int addParticipant(Long roomId, Long userId) {
//        try {
//            String key = getParticipantKey(roomId);
//
//            // 1. Redis Set에 사용자 ID 추가
//            // SADD chat:participants:123 "100"
//            // 반환값: 추가된 요소 개수 (0=이미 존재, 1=새로 추가)
//            Long addedCount = stringRedisTemplate.opsForSet().add(key, userId.toString());
//
//            // 2. 현재 참여자 수 조회
//            Long count = stringRedisTemplate.opsForSet().size(key);
//            int participantCount = count != null ? count.intValue() : 0;
//
//            if (addedCount != null && addedCount > 0) {
//                log.info("✅ 참여자 추가 성공 - roomId: {}, userId: {}, 총 참여자: {}명",
//                        roomId, userId, participantCount);
//            } else {
//                log.info("ℹ 이미 참여 중인 사용자 - roomId: {}, userId: {}, 총 참여자: {}명",
//                        roomId, userId, participantCount);
//            }
//
//            return participantCount;
//
//        } catch (Exception e) {
//            log.error("❌ 참여자 추가 실패 - roomId: {}, userId: {}", roomId, userId, e);
//
//            // Redis 실패 시 기본값 반환 (장애 대응)
//            return 0;
//        }
//    }
//
//    /**
//     * 채팅방에서 참여자 제거
//     *
//     * @param roomId 채팅방 ID
//     * @param userId 사용자 ID
//     * @return 제거 후 총 참여자 수
//     */
//    public int removeParticipant(Long roomId, Long userId) {
//        try {
//            String key = getParticipantKey(roomId);
//
//            // 1. Redis Set에서 사용자 ID 제거
//            // SREM chat:participants:123 "100"
//            // 반환값: 제거된 요소 개수 (0=존재하지 않음, 1=제거됨)
//            Long removedCount = stringRedisTemplate.opsForSet().remove(key, userId.toString());
//
//            // 2. 현재 참여자 수 조회
//            Long count = stringRedisTemplate.opsForSet().size(key);
//
//            int participantCount = count != null ? count.intValue() : 0;
//
//            if (removedCount != null && removedCount > 0) {
//                log.info("✅ 참여자 제거 성공 - roomId: {}, userId: {}, 총 참여자: {}명",
//                        roomId, userId, participantCount);
//            } else {
//                log.info("ℹ 참여하지 않던 사용자 - roomId: {}, userId: {}, 총 참여자: {}명",
//                        roomId, userId, participantCount);
//            }
//
//            return participantCount;
//
//        } catch (Exception e) {
//            log.error("❌ 참여자 제거 실패 - roomId: {}, userId: {}", roomId, userId, e);
//
//            // Redis 실패 시 기본값 반환 (장애 대응)
//            return 0;
//        }
//    }
//
//    /**
//     * 채팅방 참여자 수 조회
//     *
//     * @param roomId 채팅방 ID
//     * @return 현재 참여자 수 (Optional로 안전하게 처리)
//     */
//    public Optional<Integer> getParticipantCount(Long roomId) {
//        try {
//            String key = getParticipantKey(roomId);
//
//            // SCARD chat:participants:123
//            Long count = stringRedisTemplate.opsForSet().size(key);
//
//            if (count == null) {
//                log.warn("⚠️ 참여자 수 조회 결과가 null - roomId: {}", roomId);
//                return Optional.empty();
//            }
//
//            int participantCount = count.intValue();
//            log.debug("📊 참여자 수 조회 - roomId: {}, 참여자: {}명", roomId, participantCount);
//
//            return Optional.of(participantCount);
//
//        } catch (Exception e) {
//            log.error("❌ 참여자 수 조회 실패 - roomId: {}", roomId, e);
//            return Optional.empty();
//        }
//    }
//
//    /**
//     * 채팅방 참여자 데이터 삭제 (채팅방 종료 시 사용)
//     *
//     * @param roomId 채팅방 ID
//     * @return 삭제 성공 여부
//     */
//    public boolean clearParticipants(Long roomId) {
//        try {
//            String key = getParticipantKey(roomId);
//
//            // DEL chat:participants:123
//            Boolean deleted = stringRedisTemplate.delete(key);
//
//            log.info("🗑️ 참여자 데이터 삭제 - roomId: {}, 성공: {}", roomId, deleted);
//
//            return Boolean.TRUE.equals(deleted);
//
//        } catch (Exception e) {
//            log.error("❌ 참여자 데이터 삭제 실패 - roomId: {}", roomId, e);
//            return false;
//        }
//    }
//
//    /**
//     * Redis 키 생성 (내부 유틸리티)
//     *
//     * @param roomId 채팅방 ID
//     * @return Redis 키 문자열
//     */
//    private String getParticipantKey(Long roomId) {
//        return PARTICIPANT_KEY_PREFIX + roomId;
//    }
//}