package com.example.livecommerce_server.chat.validator;


import com.example.livecommerce_server.chat.enums.BanwordFilterPolicy;
import com.example.livecommerce_server.chat.service.BanwordService;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
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
@RequiredArgsConstructor
@Slf4j
public class BanwordValidator {

    private final BanwordService banwordService;

    private Trie banwordTrie;
    private Trie allowwordTrie;



    @PostConstruct
    public void init() {
        refreshTries();
        log.info("BanwordValidator 초기화 완료");
    }

    /**
     * 데이터베이스에서 최신 금지어/허용어를 가져와 Trie 재구성
     */
    public void refreshTries() {
        Set<String> banwords = banwordService.findActiveBanwords();
        Set<String> allowwords = banwordService.findActiveAllowwords();

        buildTries(banwords, allowwords);

        log.info("Trie 재구성 완료 - 금지어: {}개, 허용어: {}개",
                banwords.size(), allowwords.size());
    }

    /**
     * 금지어/허용어 Trie 구조를 구축합니다.
     */
    private void buildTries(Set<String> banwords, Set<String> allowwords) {
        // 금지어 Trie 구성
        Trie.TrieBuilder banBuilder = Trie.builder().ignoreCase();
        banwords.forEach(banBuilder::addKeyword);
        this.banwordTrie = banBuilder.build();

        // 허용어 Trie 구성
        Trie.TrieBuilder allowBuilder = Trie.builder().ignoreCase();
        allowwords.forEach(allowBuilder::addKeyword);
        this.allowwordTrie = allowBuilder.build();
    }


    /**
     * 허용어를 고려한 금지어 검사
     */
    public boolean containsBanword(String message) {
        // 1. 메시지가 null이거나 빈 문자열이면 차단 사유 없음 → 통과
        if (message == null || message.trim().isEmpty()) {
            return false;
        }

        // 2. 금지어 Trie로 메시지 전체 탐색
        Collection<Emit> banMatches = banwordTrie.parseText(message);
        // 2-1. 금지어가 전혀 없으면 통과
        if (banMatches.isEmpty()) {
            return false;
        }

        // 3. 허용어 Trie로 메시지 탐색 (오탐 방지용)
        Collection<Emit> allowMatches = allowwordTrie.parseText(message);

        // 4. 발견된 각 금지어에 대해
        for (Emit banMatch : banMatches) {
            boolean isAllowed = false;

            // 5. 허용어 목록 중 이 금지어가 포함된 예외 단어가 있는지 검사
            for (Emit allowMatch : allowMatches) {
                if (banMatch.getStart() >= allowMatch.getStart() &&
                        banMatch.getEnd()   <= allowMatch.getEnd()) {
                    isAllowed = true;
                    break;
                }
            }

            // 6. 예외 처리되지 않은 금지어가 하나라도 있으면 차단
            if (!isAllowed) {
                log.warn("금지어 탐지됨 - 메시지: '{}', 금지어: '{}'",
                        message, banMatch.getKeyword());
                return true;
            }
        }

        // 7. 모든 금지어가 허용어에 포함되었거나 금지어가 없으면 통과
        return false;
    }

    /**
     * 주어진 필터링 정책을 적용한 뒤, 금지어 포함 여부를 검사합니다.
     */
    public boolean containsBanword(String message, Set<BanwordFilterPolicy> policies) {
        // 메시지가 null이거나 빈 문자열이면 차단할 이유 없음 → 통과
        if (message == null || message.trim().isEmpty()) {
            return false;
        }

        // 1. 원본 메시지를 기반으로, 각 정책을 순서대로 적용하여 전처리
        String filteredMessage = message;
        for (BanwordFilterPolicy policy : policies) {
            filteredMessage = policy.apply(filteredMessage);
        }

        // 2. 전처리 전후 비교용 로깅
        log.debug("필터링 전: '{}' → 후: '{}'", message, filteredMessage);

        // 3. 전처리된 메시지를 다시 금지어 검사 로직으로 전달
        return containsBanword(filteredMessage);
    }


}
