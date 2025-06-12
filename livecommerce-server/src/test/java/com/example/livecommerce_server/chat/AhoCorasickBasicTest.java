package com.example.livecommerce_server.chat;

import com.example.livecommerce_server.chat.enums.BanwordFilterPolicy;
import org.ahocorasick.trie.Emit;
import org.ahocorasick.trie.Trie;
import org.junit.jupiter.api.Test;

import java.util.Collection;

/**
 * 아호코라식 알고리즘 기본 동작 테스트
 */
public class AhoCorasickBasicTest {
    @Test
    public void 아호코라식_기본_동작_테스트() {
        System.out.println("=== 아호코라식 기본 동작 테스트 ===");

        // 1. 금지어 목록 설정
        String[] banwords = {"욕설", "바보", "멍청이"};

        // 2. Trie 구조 생성
        Trie trie = Trie.builder()
                .ignoreCase()  // 대소문자 무시
                .addKeywords(banwords)
                .build();

        // 3. 테스트 메시지들
        String[] testMessages = {
                "안녕하세요",           // 금지어 없음
                "너는 바보야",          // 금지어 있음: "바보"
                "욕설하지마",           // 금지어 있음: "욕설"
                "바보멍청이야",         // 금지어 2개: "바보", "멍청이"
                "BAABO",              // 영어로 우회 시도
        };

        // 4. 각 메시지 검사
        for (String message : testMessages) {
            System.out.println("\n검사 메시지: \"" + message + "\"");

            Collection<Emit> matches = trie.parseText(message);

            if (matches.isEmpty()) {
                System.out.println("✅ 금지어 없음");
            } else {
                System.out.println("❌ 금지어 발견:");
                for (Emit match : matches) {
                    System.out.println("  - '" + match.getKeyword() +
                            "' (위치: " + match.getStart() + "-" + match.getEnd() + ")");
                }
            }
        }
    }

    @Test
    public void 여러_금지어_동시_검출_테스트() {
        System.out.println("\n=== 여러 금지어 동시 검출 테스트 ===");

        // 설계 문서 예시와 동일하게 테스트
        String[] banwords = {"ab", "bab", "bc"};
        String testMessage = "ababc";

        Trie trie = Trie.builder()
                .addKeywords(banwords)
                .build();

        System.out.println("금지어 목록: " + String.join(", ", banwords));
        System.out.println("검사 메시지: \"" + testMessage + "\"");

        Collection<Emit> matches = trie.parseText(testMessage);

        System.out.println("검출된 금지어:");
        for (Emit match : matches) {
            System.out.println("  - '" + match.getKeyword() +
                    "' (위치: " + match.getStart() + "-" + match.getEnd() + ")");
        }

        // 예상 결과: "ab"(0-1), "bab"(1-3), "bc"(3-4)
    }

    @Test
    public void enum_기본_동작_이해() {
        System.out.println("=== Enum 기본 동작 이해 ===");

        // 1. enum 상수들 확인
        System.out.println("모든 BanwordFilterPolicy 상수들:");
        for (BanwordFilterPolicy policy : BanwordFilterPolicy.values()) {
            System.out.println("- " + policy.name() + ": " + policy.getDescription());
        }

        System.out.println();

        // 2. 각 상수는 독립적인 객체
        BanwordFilterPolicy numbers = BanwordFilterPolicy.NUMBERS;
        BanwordFilterPolicy whitespaces = BanwordFilterPolicy.WHITESPACES;

        System.out.println("NUMBERS의 regex: " + numbers.getRegex());
        System.out.println("WHITESPACES의 regex: " + whitespaces.getRegex());

        System.out.println();

        // 3. 같은 상수는 항상 같은 객체 (싱글톤)
        System.out.println("같은 상수 비교:");
        System.out.println("numbers == BanwordFilterPolicy.NUMBERS: " +
                (numbers == BanwordFilterPolicy.NUMBERS));
    }

    @Test
    public void enum_메서드_동작_이해() {
        System.out.println("=== Enum 메서드 동작 이해 ===");

        String testText = "계좌1번2호";

        // 1. apply() 메서드가 어떻게 동작하는지
        System.out.println("원본 텍스트: \"" + testText + "\"");

        // NUMBERS 상수의 apply() 메서드 호출
        // 내부적으로 this.regex ("[\\p{N}]")를 사용해서 replaceAll 실행
        String result = BanwordFilterPolicy.NUMBERS.apply(testText);
        System.out.println("NUMBERS.apply() 결과: \"" + result + "\"");

        // 2. 메서드 체이닝
        String chainResult = BanwordFilterPolicy.WHITESPACES.apply(
                BanwordFilterPolicy.NUMBERS.apply("계좌 1 번 2 호")
        );
        System.out.println("체이닝 결과: \"계좌 1 번 2 호\" → \"" + chainResult + "\"");
    }

    @Test
    public void 실제_사용_시나리오() {
        System.out.println("=== 실제 사용 시나리오 ===");

        String[] testMessages = {
                "계좌1번호",
                "계좌 번호",
                "바BAABO보",
                "멍@청#이"
        };

        for (String message : testMessages) {
            System.out.println("\n원본: \"" + message + "\"");

            // 단계적으로 필터링 적용
            String step1 = BanwordFilterPolicy.NUMBERS.apply(message);
            String step2 = BanwordFilterPolicy.WHITESPACES.apply(step1);
            String step3 = BanwordFilterPolicy.ENGLISH.apply(step2);
            String step4 = BanwordFilterPolicy.SPECIAL_CHARACTERS.apply(step3);

            System.out.println("최종: \"" + step4 + "\"");
        }
    }
}
