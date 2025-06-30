package com.example.livecommerce_server.chat.validator;

import com.example.livecommerce_server.chat.dto.UserMessageState;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 중복 메시지 도배 방지를 위한 검증기
 * 동일한 메시지나 유사한 패턴을 연속으로 전송하는 경우를 감지하고 제한합니다.
 */
@Component
@Slf4j
public class DuplicateMessageValidator {

    // 사용자별 메시지 상태 저장 (추후 Redis로 교체 가능)
    private final Map<String, UserMessageState> userStates = new ConcurrentHashMap<>();

    // 설정값들 (추후 application.yml로 외부화 가능)
    private static final int CONSECUTIVE_LIMIT = 3;      // 연속 동일 메시지 제한 횟수
    private static final int DELAY_SECONDS = 2;          // 2회째부터 적용할 딜레이(초)
    private static final int BLOCK_SECONDS = 30;         // 3회째 차단 시간(초)

    /**
     * 메시지 전송 가능 여부를 검증합니다.
     *
     * @param userId  사용자 ID
     * @param roomId  채팅방 ID
     * @param message 전송하려는 메시지
     * @return 검증 결과
     */
    public ValidationResult validate(Long userId, Long roomId, String message) {
        // 1. 사용자 고유 키 생성 (채팅방별로 독립적으로 관리)
        String userKey = generateUserKey(userId, roomId);

        // 2. 사용자의 현재 상태 조회
        UserMessageState state = userStates.computeIfAbsent(
                userKey,
                k -> UserMessageState.builder().build()
        );

        // 3. 차단 상태 확인
        if (state.isBlocked()) {
            long remaining = Duration
                    .between(LocalDateTime.now(), state.getBlockedUntil())
                    .getSeconds();
            log.warn("차단된 사용자의 메시지 시도 - userId: {}, roomId: {}, 남은 차단 시간: {}초",
                    userId, roomId, remaining);
            return ValidationResult.blocked(
                    "도배로 인해 " + remaining + "초 동안 채팅이 제한됩니다."
            );
        }

        // 4. 첫 메시지이거나 다른 패턴의 메시지인 경우 → 상태 초기화
        if (state.getLastMessage() == null || !isSimilarMessage(state.getLastMessage(), message)) {
            state.reset(message);
            log.debug("새로운 메시지 패턴 - userId: {}, message: {}", userId, message);
            return ValidationResult.allowed();
        }

        // 5. 유사한 메시지 패턴인 경우 → 카운트 증가
        state.incrementCount();
        state.setLastSentTime(LocalDateTime.now());

        log.info("유사 메시지 패턴 감지 - userId: {}, count: {}, message: {}",
                userId, state.getConsecutiveCount(), message);

        // 6. 연속 횟수에 따른 처리
        if (state.getConsecutiveCount() == 2) {
            // 2회째 → 지연 + 안내 메시지
            log.info("딜레이 적용 - userId: {}, delaySeconds: {}", userId, DELAY_SECONDS);
            return ValidationResult.delayed(
                    DELAY_SECONDS,
                    "동일한 패턴의 메시지 반복으로 " + DELAY_SECONDS + "초 딜레이가 적용됩니다."
            );

        } else if (state.getConsecutiveCount() >= CONSECUTIVE_LIMIT) {
            // 3회째 → 차단
            state.block(BLOCK_SECONDS);
            log.warn("사용자 차단 - userId: {}, blockSeconds: {}", userId, BLOCK_SECONDS);
            return ValidationResult.blocked(
                    "도배로 인해 " + BLOCK_SECONDS + "초 동안 채팅이 제한됩니다."
            );
        }

        // 1회째는 그냥 통과
        return ValidationResult.allowed();
    }

    /**
     * 두 메시지가 유사한 패턴인지 검사합니다.
     *
     * @param lastMessage    이전 메시지
     * @param currentMessage 현재 메시지
     * @return 유사한 패턴이면 true
     */
    private boolean isSimilarMessage(String lastMessage, String currentMessage) {
        // 1. 완전히 동일한 경우
        if (lastMessage.equals(currentMessage)) {
            log.debug("완전 동일 메시지 감지: {}", currentMessage);
            return true;
        }

        // 2. 같은 문자 반복 패턴 검사 (ㅋㅋㅋ, ㅎㅎㅎ, 하하하 등)
        if (isRepeatingCharPattern(lastMessage) && isRepeatingCharPattern(currentMessage)) {
            log.debug("반복 문자 패턴 감지: {} -> {}", lastMessage, currentMessage);
            return true;
        }

        // 3. 짧은 감탄사 패턴 검사 (와, 오, 어 등의 단순 반복)
        if (isSimpleExclamationPattern(lastMessage) && isSimpleExclamationPattern(currentMessage)) {
            log.debug("단순 감탄사 패턴 감지: {} -> {}", lastMessage, currentMessage);
            return true;
        }

        // 4. 길이와 유사도 기반 검사 (매우 유사한 메시지)
        if (isSimilarByLength(lastMessage, currentMessage)) {
            double similarity = calculateSimilarity(lastMessage, currentMessage);
            if (similarity > 0.8) { // 80% 이상 유사하면 도배로 간주
                log.debug("유사도 기반 패턴 감지: {} -> {} (유사도: {})",
                        lastMessage, currentMessage, similarity);
                return true;
            }
        }

        return false;
    }

    /**
     * 반복되는 문자 패턴인지 검사 (ㅋㅋㅋ, ㅎㅎㅎ, 하하하 등)
     */
    private boolean isRepeatingCharPattern(String message) {
        if (message == null || message.length() < 3) {
            return false;
        }

        // 웃음 표현 패턴
        if (message.matches("^[ㅋㅎ하호히헤ㅠㅜ]{3,}$")) {
            return true;
        }

        // 같은 문자만 반복되는 패턴 (아아아, 네네네 등)
        if (message.length() >= 3) {
            char firstChar = message.charAt(0);
            return message.chars().allMatch(c -> c == firstChar);
        }

        return false;
    }

    /**
     * 단순 감탄사 패턴 검사 (와, 오, 어, 음 등의 짧은 반응)
     */
    private boolean isSimpleExclamationPattern(String message) {
        if (message == null || message.length() > 3) {
            return false;
        }

        // 짧은 감탄사들
        return message.matches("^[와오어음아이야]+$");
    }

    /**
     * 길이가 비슷한지 검사 (유사도 계산 전 필터링)
     */
    private boolean isSimilarByLength(String msg1, String msg2) {
        int len1 = msg1.length();
        int len2 = msg2.length();

        // 둘 다 짧거나, 길이 차이가 크지 않은 경우만 유사도 검사
        return (Math.max(len1, len2) <= 10) ||
                (Math.abs(len1 - len2) <= Math.max(len1, len2) * 0.3);
    }

    /**
     * 두 문자열의 유사도를 계산합니다 (Levenshtein Distance 기반)
     */
    private double calculateSimilarity(String s1, String s2) {
        int maxLen = Math.max(s1.length(), s2.length());
        if (maxLen == 0) return 1.0;

        int distance = levenshteinDistance(s1, s2);
        return 1.0 - (double) distance / maxLen;
    }

    /**
     * Levenshtein Distance 계산 (편집 거리)
     */
    private int levenshteinDistance(String s1, String s2) {
        int[][] dp = new int[s1.length() + 1][s2.length() + 1];

        for (int i = 0; i <= s1.length(); i++) {
            dp[i][0] = i;
        }
        for (int j = 0; j <= s2.length(); j++) {
            dp[0][j] = j;
        }

        for (int i = 1; i <= s1.length(); i++) {
            for (int j = 1; j <= s2.length(); j++) {
                int cost = (s1.charAt(i - 1) == s2.charAt(j - 1)) ? 0 : 1;
                dp[i][j] = Math.min(Math.min(
                                dp[i - 1][j] + 1,      // 삭제
                                dp[i][j - 1] + 1),     // 삽입
                        dp[i - 1][j - 1] + cost // 대체
                );
            }
        }

        return dp[s1.length()][s2.length()];
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
        // 차단/딜레이 시 사용자에게 보여줄 안내 메시지
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
         */
        public static ValidationResult allowed() {
            return new ValidationResult(true, false, 0, null);
        }

        /**
         * 전송을 허용하되, 지정된 초만큼 지연할 결과를 생성합니다. (메시지 없음)
         */
        public static ValidationResult delayed(int seconds) {
            return new ValidationResult(true, true, seconds, null);
        }

        /**
         * 전송을 허용하되, 지정된 초만큼 지연하고 안내 메시지를 보여줄 결과를 생성합니다.
         */
        public static ValidationResult delayed(int seconds, String message) {
            return new ValidationResult(true, true, seconds, message);
        }

        /**
         * 전송을 차단할 결과를 생성합니다.
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