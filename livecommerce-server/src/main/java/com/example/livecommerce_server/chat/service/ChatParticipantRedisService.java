package com.example.livecommerce_server.chat.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.Set;

/**
 * 🆕 세션 추적 기반 채팅방 참여자 수 관리 서비스
 *
 * Redis 키 구조:
 * - chat:participants:{roomId} → Set<userId> (실제 참여자 수)
 * - chat:user:sessions:{roomId}:{userId} → Set<sessionId> (사용자별 세션 추적)
 *
 * 예시:
 * - chat:participants:123 → {"100", "200"} (실제 사용자 2명)
 * - chat:user:sessions:123:100 → {"sess001", "sess002"} (사용자 100의 세션들)
 * - 참여자 수 = chat:participants의 크기 (실제 사람 수)
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ChatParticipantRedisService {

    private final StringRedisTemplate stringRedisTemplate;

    // Redis 키 패턴 상수
    private static final String PARTICIPANT_KEY_PREFIX = "chat:participants:";
    private static final String USER_SESSION_KEY_PREFIX = "chat:user:sessions:";

    /**
     * 사용자 세션 추가 (세션 추적 기반)
     *
     * @param roomId 채팅방 ID
     * @param userId 사용자 ID
     * @param sessionId 세션 ID
     * @return 추가 후 총 참여자 수 (실제 사용자 수)
     */
    public int addUserSession(Long roomId, Long userId, String sessionId) {
        try {
            String participantKey = getParticipantKey(roomId);
            String userSessionKey = getUserSessionKey(roomId, userId);

            // 1. 사용자별 세션 Set에 세션 ID 추가
            Long sessionAdded = stringRedisTemplate.opsForSet().add(userSessionKey, sessionId);

            // 2. 첫 번째 세션인지 확인 후 참여자 목록에 추가
            Long userAdded = stringRedisTemplate.opsForSet().add(participantKey, userId.toString());

            // 3. 현재 참여자 수 조회 (실제 사용자 수)
            Long count = stringRedisTemplate.opsForSet().size(participantKey);
            int participantCount = count != null ? count.intValue() : 0;

            // 4. 사용자 세션 수 확인 (디버깅용)
            Long userSessionCount = stringRedisTemplate.opsForSet().size(userSessionKey);

            if (sessionAdded != null && sessionAdded > 0) {
                if (userAdded != null && userAdded > 0) {
                    log.info("✅ 새 사용자 참여 - roomId: {}, userId: {}, sessionId: {}, 총 사용자: {}명",
                            roomId, userId, sessionId, participantCount);
                } else {
                    log.info("✅ 기존 사용자 추가 세션 - roomId: {}, userId: {}, sessionId: {}, 사용자 세션: {}개, 총 사용자: {}명",
                            roomId, userId, sessionId, userSessionCount, participantCount);
                }
            } else {
                log.debug("ℹ 세션 이미 존재 - roomId: {}, userId: {}, sessionId: {}, 총 사용자: {}명",
                        roomId, userId, sessionId, participantCount);
            }

            return participantCount;

        } catch (Exception e) {
            log.error("❌ 사용자 세션 추가 실패 - roomId: {}, userId: {}, sessionId: {}",
                    roomId, userId, sessionId, e);
            return 0;
        }
    }

    /**
     * 사용자 세션 제거 (세션 추적 기반)
     *
     * @param roomId 채팅방 ID
     * @param userId 사용자 ID
     * @param sessionId 세션 ID
     * @return 제거 후 총 참여자 수 (실제 사용자 수)
     */
    public int removeUserSession(Long roomId, Long userId, String sessionId) {
        try {
            String participantKey = getParticipantKey(roomId);
            String userSessionKey = getUserSessionKey(roomId, userId);

            // 1. 사용자별 세션에서 해당 세션 제거
            Long sessionRemoved = stringRedisTemplate.opsForSet().remove(userSessionKey, sessionId);

            // 2. 해당 사용자의 남은 세션 수 확인
            Long remainingSessions = stringRedisTemplate.opsForSet().size(userSessionKey);

            // 3. 마지막 세션이었다면 참여자 목록에서도 제거
            if (remainingSessions != null && remainingSessions == 0) {
                stringRedisTemplate.opsForSet().remove(participantKey, userId.toString());
                // 빈 세션 키도 삭제 (메모리 절약)
                stringRedisTemplate.delete(userSessionKey);

                log.info(" 사용자 완전 퇴장 - roomId: {}, userId: {}, sessionId: {}",
                        roomId, userId, sessionId);
            }

            // 4. 현재 참여자 수 조회 (실제 사용자 수)
            Long count = stringRedisTemplate.opsForSet().size(participantKey);
            int participantCount = count != null ? count.intValue() : 0;

            if (sessionRemoved != null && sessionRemoved > 0) {
                if (remainingSessions != null && remainingSessions == 0) {
                    log.info(" 사용자 완전 퇴장 - roomId: {}, userId: {}, sessionId: {}, 총 사용자: {}명",
                            roomId, userId, sessionId, participantCount);
                } else {
                    log.info("사용자 일부 세션 종료 - roomId: {}, userId: {}, sessionId: {}, 남은 세션: {}개, 총 사용자: {}명",
                            roomId, userId, sessionId, remainingSessions, participantCount);
                }
            } else {
                log.debug("ℹ 세션 없음 - roomId: {}, userId: {}, sessionId: {}, 총 사용자: {}명",
                        roomId, userId, sessionId, participantCount);
            }

            return participantCount;

        } catch (Exception e) {
            log.error(" 사용자 세션 제거 실패 - roomId: {}, userId: {}, sessionId: {}",
                    roomId, userId, sessionId, e);
            return 0;
        }
    }

    /**
     * 채팅방 참여자 수 조회 (실제 사용자 수)
     *
     * @param roomId 채팅방 ID
     * @return 현재 참여자 수 (실제 사용자 수)
     */
    public Optional<Integer> getParticipantCount(Long roomId) {
        try {
            String participantKey = getParticipantKey(roomId);
            Long count = stringRedisTemplate.opsForSet().size(participantKey);

            if (count == null) {
                log.warn("⚠️ 참여자 수 조회 결과가 null - roomId: {}", roomId);
                return Optional.empty();
            }

            int participantCount = count.intValue();
            log.debug("📊 참여자 수 조회 - roomId: {}, 실제 사용자: {}명", roomId, participantCount);

            return Optional.of(participantCount);

        } catch (Exception e) {
            log.error("❌ 참여자 수 조회 실패 - roomId: {}", roomId, e);
            return Optional.empty();
        }
    }

    /**
     * 특정 사용자의 세션 수 조회 (디버깅용)
     *
     * @param roomId 채팅방 ID
     * @param userId 사용자 ID
     * @return 해당 사용자의 세션 수
     */
    public int getUserSessionCount(Long roomId, Long userId) {
        try {
            String userSessionKey = getUserSessionKey(roomId, userId);
            Long count = stringRedisTemplate.opsForSet().size(userSessionKey);
            return count != null ? count.intValue() : 0;
        } catch (Exception e) {
            log.error("❌ 사용자 세션 수 조회 실패 - roomId: {}, userId: {}", roomId, userId, e);
            return 0;
        }
    }

    /**
     * 특정 사용자의 모든 세션 조회 (디버깅용)
     *
     * @param roomId 채팅방 ID
     * @param userId 사용자 ID
     * @return 해당 사용자의 세션 ID 목록
     */
    public Set<String> getUserSessions(Long roomId, Long userId) {
        try {
            String userSessionKey = getUserSessionKey(roomId, userId);
            return stringRedisTemplate.opsForSet().members(userSessionKey);
        } catch (Exception e) {
            log.error("❌ 사용자 세션 목록 조회 실패 - roomId: {}, userId: {}", roomId, userId, e);
            return Set.of();
        }
    }

    /**
     * 채팅방 데이터 삭제 (채팅방 종료 시)
     *
     * @param roomId 채팅방 ID
     * @return 삭제 성공 여부
     */
    public boolean clearParticipants(Long roomId) {
        try {
            String participantKey = getParticipantKey(roomId);

            // 1. 모든 사용자 조회
            Set<String> users = stringRedisTemplate.opsForSet().members(participantKey);

            // 2. 각 사용자의 세션 데이터 삭제
            if (users != null && !users.isEmpty()) {
                for (String userId : users) {
                    String userSessionKey = getUserSessionKey(roomId, Long.parseLong(userId));
                    stringRedisTemplate.delete(userSessionKey);
                }
                log.info("🗑️ 사용자별 세션 데이터 삭제 완료 - roomId: {}, 사용자 수: {}명", roomId, users.size());
            }

            // 3. 참여자 목록 삭제
            Boolean deleted = stringRedisTemplate.delete(participantKey);

            log.info("🗑️ 참여자 데이터 삭제 완료 - roomId: {}, 성공: {}", roomId, deleted);

            return Boolean.TRUE.equals(deleted);

        } catch (Exception e) {
            log.error("❌ 참여자 데이터 삭제 실패 - roomId: {}", roomId, e);
            return false;
        }
    }

    /**
     * Redis 키 생성 유틸리티들
     */
    private String getParticipantKey(Long roomId) {
        return PARTICIPANT_KEY_PREFIX + roomId;
    }

    private String getUserSessionKey(Long roomId, Long userId) {
        return USER_SESSION_KEY_PREFIX + roomId + ":" + userId;
    }
}