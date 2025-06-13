package com.example.livecommerce_server.chat.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * 금지어 필터링 정책을 정의하는 enum
 * 우회 단어 처리를 위한 문자 제거 규칙을 제공합니다.
 */
@Getter
@RequiredArgsConstructor
public enum BanwordFilterPolicy {

    /**
     * 숫자 제거 정책
     * 예: "계좌1번호" → "계좌번호"
     */
    NUMBERS("[\\p{N}]", "숫자 제거"),

    /**
     * 공백 제거 정책
     * 예: "계좌 번호" → "계좌번호"
     */
    WHITESPACES("[\\s]", "공백 제거"),

    /**
     * 특수문자 제거 정책
     * 예: "계좌-번호" → "계좌번호"
     */
    SPECIAL_CHARACTERS("[^ㄱ-ㅎ가-힣ㅏ-ㅣa-zA-Z0-9]", "특수문자 제거"),

    /**
     * 영어 제거 정책
     * 예: "바BAABO보" → "바보"
     */
    ENGLISH("[a-zA-Z]", "영어 제거");

    private final String regex;
    private final String description;

    /**
     * 주어진 텍스트에서 정책에 해당하는 문자들을 제거합니다.
     *
     * @param text 원본 텍스트
     * @return 정책이 적용된 텍스트
     */
    public String apply(String text) {
        if (text == null || text.isEmpty()) {
            return text;
        }
        return text.replaceAll(this.regex, "");
    }
}
