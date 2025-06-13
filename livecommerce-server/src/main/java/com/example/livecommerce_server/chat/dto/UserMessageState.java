package com.example.livecommerce_server.chat.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 사용자별 메시지 상태를 관리하는 DTO
 * 중복 메시지 도배 방지를 위한 상태 정보를 담습니다.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserMessageState {

    /**
     * 마지막으로 전송한 메시지 내용
     */
    private String lastMessage;

    /**
     * 연속으로 동일한 메시지를 전송한 횟수
     */
    private int consecutiveCount;

    /**
     * 채팅 차단이 해제되는 시간
     * null이면 차단되지 않은 상태
     */
    private LocalDateTime blockedUntil;

    /**
     * 마지막 메시지 전송 시간
     */
    private LocalDateTime lastSentTime;


    /**
     * 차단 상태인지 확인
     *
     * @return 현재 시간이 차단 해제 시간 이전이면 true
     */
    public boolean isBlocked() {
        return blockedUntil != null && LocalDateTime.now().isBefore(blockedUntil);
    }
    /**
     * 연속 카운트 증가
     */
    public void incrementCount() {
        this.consecutiveCount++;
    }


    /**
     * 상태 초기화 (다른 메시지를 보낸 경우)
     *
     * @param newMessage 새로운 메시지 내용
     */
    public void reset(String newMessage) {
        this.lastMessage = newMessage;
        this.consecutiveCount = 1;
        this.lastSentTime = LocalDateTime.now();
    }

    /**
     * 차단 설정
     *
     * @param seconds 차단할 시간(초)
     */
    public void block(int seconds) {
        this.blockedUntil = LocalDateTime.now().plusSeconds(seconds);
    }








}

