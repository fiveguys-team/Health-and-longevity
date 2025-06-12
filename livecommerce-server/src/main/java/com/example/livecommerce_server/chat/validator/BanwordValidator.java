package com.example.livecommerce_server.chat.validator;


import com.example.livecommerce_server.chat.enums.BanwordFilterPolicy;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.ahocorasick.trie.Emit;
import org.ahocorasick.trie.Trie;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

/**
 * 아호코라식 알고리즘을 사용한 금지어 검증 클래스
 * 시니어 친화적인 건강기능식품 라이브 커머스 환경에 특화된 필터링을 제공합니다.
 */
@Component
@Slf4j
public class BanwordValidator {

    private Trie banwordTrie;
    private Set<String> banwords;

    @PostConstruct
    public void init() {
        // 일단 하드코딩된 금지어로 시작 (나중에 DB 연동 예정)
        this.banwords = new HashSet<>(Arrays.asList(
                // 일반 욕설
                "욕설", "바보", "멍청이",

                // 건강 관련 허위정보
                "암완치", "100%치료", "기적의효과", "즉시완치",

                // 연락처 관련
                "전화번호", "카톡", "연락처", "010"
        ));

        buildTrie();
        log.info("BanwordValidator 초기화 완료 - 금지어 {}개 로드됨", banwords.size());
    }

    /**
     * 금지어 Trie 구조를 구축합니다.
     */
    private void buildTrie() {
        Trie.TrieBuilder builder = Trie.builder().ignoreCase();
        banwords.forEach(builder::addKeyword);
        this.banwordTrie = builder.build();
    }

    /**
     * 메시지에 금지어가 포함되어 있는지 간단히 검사합니다.
     */
    public boolean containsBanword(String message) {
        if (message == null || message.trim().isEmpty()) {
            return false;
        }

        Collection<Emit> matches = banwordTrie.parseText(message);

        if (!matches.isEmpty()) {
            log.warn("금지어 탐지됨 - 메시지: '{}', 금지어: {}",
                    message, matches.iterator().next().getKeyword());
            return true;
        }

        return false;
    }

    /**
     * 필터링 정책을 적용한 후 금지어 검사를 합니다.
     */
    public boolean containsBanword(String message, Set<BanwordFilterPolicy> policies) {
        if (message == null || message.trim().isEmpty()) {
            return false;
        }

        // 필터링 정책들을 순서대로 적용
        String filteredMessage = message;
        for (BanwordFilterPolicy policy : policies) {
            filteredMessage = policy.apply(filteredMessage);
        }

        log.debug("필터링 전: '{}' → 후: '{}'", message, filteredMessage);

        // 필터링된 메시지로 금지어 검사
        return containsBanword(filteredMessage);
    }
}
