package com.example.livecommerce_server.chat.validator;


import com.example.livecommerce_server.chat.dto.UserMessageState;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 중복 메시지 도배 방지를 위한 검증기
 * 동일한 메시지를 연속으로 전송하는 경우를 감지하고 제한합니다.
 */
@Component
@Slf4j
public class DuplicateMessageValidator  {

    // 사용자별 메시지 상태 저장 (추후 Redis로 교체 가능)
    private final Map<String, UserMessageState> userStates = new ConcurrentHashMap<>();

    // 설정값들 (추후 application.yml로 외부화 가능)
    private static final int CONSECUTIVE_LIMIT = 3;      // 연속 동일 메시지 제한 횟수
    private static final int DELAY_SECONDS = 3;          // 2회째부터 적용할 딜레이(초)
    private static final int BLOCK_SECONDS = 5;          // 3회째 차단 시간(초)


    /**
     * 메시지 전송 가능 여부를 검증합니다.
     *
     * @param userId 사용자 ID
     * @param roomId 채팅방 ID
     * @param message 전송하려는 메시지
     * @return 검증 결과
     */
    public ValidationResult validate(Long userId, Long roomId, String message) {
        // 1. 사용자 고유 키 생성 (채팅방별로 독립적으로 관리)
        String userKey = generateUserKey(userId, roomId);

        // 2. 사용자의 현재 상태 조회
        UserMessageState state = userStates.computeIfAbsent(userKey,
                k -> UserMessageState.builder().build()
        );

        // 3. 차단 상태 확인
        if (state.isBlocked()) {
            log.warn("차단된 사용자의 메시지 시도 - userId: {}, roomId: {}", userId, roomId);
            return ValidationResult.blocked("동일한 메시지를 반복 전송하여 일시적으로 채팅이 제한됩니다.");
        }

        // 4. 첫 메시지이거나 다른 메시지인 경우 → 상태 초기화
        if (state.getLastMessage() == null || !state.getLastMessage().equals(message)) {
            state.reset(message);
            log.debug("새로운 메시지 - userId: {}, message: {}", userId, message);
            return ValidationResult.allowed();
        }

        // 5. 동일한 메시지인 경우 → 카운트 증가
        state.incrementCount();
        state.setLastSentTime(LocalDateTime.now());

        log.info("동일 메시지 감지 - userId: {}, count: {}, message: {}",
                userId, state.getConsecutiveCount(), message);

        // 6. 연속 횟수에 따른 처리
        if (state.getConsecutiveCount() >= CONSECUTIVE_LIMIT) {
            // 3회째 → 5초 차단
            state.block(BLOCK_SECONDS);
            log.warn("사용자 차단 - userId: {}, blockSeconds: {}", userId, BLOCK_SECONDS);
            return ValidationResult.blocked("동일한 메시지를 반복 전송하여 일시적으로 채팅이 제한됩니다.");
        } else if (state.getConsecutiveCount() == 2) {
            // 2회째 → 3초 딜레이
            log.info("딜레이 적용 - userId: {}, delaySeconds: {}", userId, DELAY_SECONDS);
            return ValidationResult.delayed(DELAY_SECONDS);
        }

        // 7. 1회째는 그냥 통과
        return ValidationResult.allowed();
    }

    /**
     * 사용자별 고유 키 생성
     *
     * @param userId 사용자 ID
     * @param roomId 채팅방 ID
     * @return 조합된 키
     */
    private String generateUserKey(Long userId, Long roomId) {
        return String.format("user:%d:room:%d", userId, roomId);
    }

    /**
     * 오래된 상태 정보 정리 (메모리 관리)
     * 실제 운영시에는 스케줄러로 주기적으로 실행
     */
    @Scheduled(fixedDelayString = "PT10M")
    public void cleanupOldStates() {
        LocalDateTime threshold = LocalDateTime.now().minusMinutes(30);

        userStates.entrySet().removeIf(entry -> {
            UserMessageState state = entry.getValue();
            // 30분 이상 활동 없는 사용자 정보 제거
            return state.getLastSentTime() != null &&
                    state.getLastSentTime().isBefore(threshold);
        });

        log.info("오래된 상태 정리 완료 - 남은 사용자 수: {}", userStates.size());
    }

    /**
     * 검증 결과를 담는 내부 클래스
     */
    public static class ValidationResult {
        // 메시지 전송을 허용할지 여부
        private final boolean allowed;
        // 허용은 하지만 지연할지 여부
        private final boolean delayed;
        // 지연 전송 시 적용할 대기 시간(초)
        private final int delaySeconds;
        // 차단 시 사용자에게 보여줄 안내 메시지 (허용/지연 시 null)
        private final String message;

        // 생성자는 외부에서 직접 호출하지 않고, 정적 팩토리 메서드만 사용하도록 private
        private ValidationResult(boolean allowed, boolean delayed, int delaySeconds, String message) {
            this.allowed      = allowed;
            this.delayed      = delayed;
            this.delaySeconds = delaySeconds;
            this.message      = message;
        }

        /**
         * 즉시 전송을 허용하는 결과를 생성합니다.
         * allowed = true, delayed = false, delaySeconds = 0, message = null
         */
        public static ValidationResult allowed() {
            return new ValidationResult(true, false, 0, null);
        }

        /**
         * 전송을 허용하되, 지정된 초만큼 지연할 결과를 생성합니다.
         * allowed = true, delayed = true, delaySeconds = seconds, message = null
         *
         * @param seconds 지연할 시간(초)
         */
        public static ValidationResult delayed(int seconds) {
            return new ValidationResult(true, true, seconds, null);
        }

        /**
         * 전송을 차단할 결과를 생성합니다.
         * allowed = false, delayed = false, delaySeconds = 0, message = 안내문구
         *
         * @param message 사용자에게 보여줄 차단 안내 메시지
         */
        public static ValidationResult blocked(String message) {
            return new ValidationResult(false, false, 0, message);
        }

        public boolean isAllowed() {
            return allowed;
        }

        public boolean isDelayed() {
            return delayed;
        }

        public int getDelaySeconds() {
            return delaySeconds;
        }

        public String getMessage() {
            return message;
        }
    }


}
