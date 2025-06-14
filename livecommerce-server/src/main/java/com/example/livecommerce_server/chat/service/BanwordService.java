package com.example.livecommerce_server.chat.service;

import java.util.Set;

/**
 * 금지어 관리 서비스 인터페이스
 * 데이터베이스에서 금지어/허용어를 조회하는 기능을 정의합니다.
 */
public interface BanwordService {

    /**
     * 활성화된 금지어 목록 조회
     *
     * @return 활성화된 금지어 Set (단어만)
     */
    Set<String> findActiveBanwords();

    /**
     * 활성화된 허용어 목록 조회
     *
     * @return 활성화된 허용어 Set (단어만)
     */
    Set<String> findActiveAllowwords();
}
