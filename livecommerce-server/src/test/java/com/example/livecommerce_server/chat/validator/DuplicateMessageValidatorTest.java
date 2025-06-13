package com.example.livecommerce_server.chat.validator;

import com.example.livecommerce_server.chat.dto.UserMessageState;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Field;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import static org.assertj.core.api.Java6Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.*;

class DuplicateMessageValidatorTest {

    private DuplicateMessageValidator validator;
    private Map<String, UserMessageState> userStates;

    @BeforeEach
    void setUp() throws Exception {
        validator = new DuplicateMessageValidator();

        // 리플렉션으로 private userStates 맵에 접근
        Field statesField = DuplicateMessageValidator.class.getDeclaredField("userStates");
        statesField.setAccessible(true);
        userStates = (ConcurrentHashMap<String, UserMessageState>) statesField.get(validator);
    }

    @Test
    void cleanupOldStates_shouldRemoveEntriesOlderThan30Minutes() {
        // 1) 기준 시각
        LocalDateTime now = LocalDateTime.now();

        // 2) 오래된 상태 (lastSentTime 31분 전)
        UserMessageState oldState = UserMessageState.builder().build();
        oldState.setLastSentTime(now.minusMinutes(31));
        userStates.put("user:1:room:1", oldState);

        // 3) 최근 상태 (lastSentTime 10분 전)
        UserMessageState recentState = UserMessageState.builder().build();
        recentState.setLastSentTime(now.minusMinutes(10));
        userStates.put("user:2:room:1", recentState);

        // pre-condition
        assertThat(userStates.size()).isEqualTo(2);

        // 4) cleanup 호출
        validator.cleanupOldStates();

        // post-condition: 오래된 key만 제거되어야 함
        assertThat(userStates.containsKey("user:1:room:1")).isFalse();
        assertThat(userStates.containsKey("user:2:room:1")).isTrue();
    }
}