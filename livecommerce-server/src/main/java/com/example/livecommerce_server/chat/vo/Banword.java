package com.example.livecommerce_server.chat.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 금지어/허용어 정보를 담는 VO 클래스
 * BANWORD_M 테이블과 매핑됩니다.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Banword {

    /**
     * 단어 ID (PK)
     */
    private Long wordId;

    /**
     * 단어 내용
     */
    private String word;

    /**
     * 타입 코드 (금칙어/허용어)
     */
    private String typeCd;

    /**
     * 카테고리명
     */
    private String categoryNm;

    /**
     * 사용 여부
     */
    private Boolean useYn;

    /**
     * 생성일시
     */
    private LocalDateTime createdAt;
}
