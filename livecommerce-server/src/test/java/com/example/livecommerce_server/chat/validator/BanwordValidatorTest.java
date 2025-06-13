//package com.example.livecommerce_server.chat.validator;
//
//import com.example.livecommerce_server.chat.enums.BanwordFilterPolicy;
//import org.junit.jupiter.api.BeforeEach;
//import org.junit.jupiter.api.Test;
//
//import java.util.Set;
//
//import static org.junit.jupiter.api.Assertions.*;
///**
// * BanwordValidator 테스트
// */
//public class BanwordValidatorTest {
//
//    private BanwordValidator validator;
//
//    @BeforeEach
//    void setUp() {
//        validator = new BanwordValidator();
//        validator.init(); // @PostConstruct 수동 호출
//    }
//
//    @Test
//    public void 정상_메시지_테스트() {
//        // Given: 정상적인 메시지들
//        String[] normalMessages = {
//                "안녕하세요",
//                "오메가3 좋네요",
//                "건강기능식품 추천해주세요",
//                "DHA 효과가 어떤가요?"
//        };
//
//        // When & Then: 모두 금지어가 없어야 함
//        for (String message : normalMessages) {a
//            boolean result = validator.containsBanword(message);
//            assertFalse(result, "정상 메시지가 금지어로 판정됨: " + message);
//            System.out.println("✅ 정상: \"" + message + "\"");
//        }
//    }
//
//    @Test
//    public void 금지어_포함_메시지_테스트() {
//        // Given: 금지어가 포함된 메시지들
//        String[] badMessages = {
//                "너는 바보야",
//                "이 제품으로 암완치 가능",
//                "100%치료 된다고 들었어요",
//                "010-1234-5678 연락주세요"
//        };
//
//        // When & Then: 모두 금지어로 검출되어야 함
//        for (String message : badMessages) {
//            boolean result = validator.containsBanword(message);
//            assertTrue(result, "금지어 메시지가 통과됨: " + message);
//            System.out.println("❌ 금지어: \"" + message + "\"");
//        }
//    }
//
//    @Test
//    public void 우회_표현_차단_테스트() {
//        // Given: 우회 표현들
//        String[] bypassMessages = {
//                "바 1 보",          // 숫자 + 공백으로 우회
//                "바  보",           // 공백으로 우회
//                "암 완 치",         // 공백으로 우회
//                "0 1 0 연락주세요"  // 숫자 + 공백 조합
//        };
//
//        // Given: 시니어 친화적 정책 (숫자, 공백 제거)
//        Set<BanwordFilterPolicy> policies = Set.of(
//                BanwordFilterPolicy.NUMBERS,
//                BanwordFilterPolicy.WHITESPACES
//        );
//
//        // When & Then: 필터링 후 금지어로 검출되어야 함
//        for (String message : bypassMessages) {
//            boolean result = validator.containsBanword(message, policies);
//            assertTrue(result, "우회 표현이 통과됨: " + message);
//            System.out.println("🚫 우회차단: \"" + message + "\"");
//        }
//    }
//
//}