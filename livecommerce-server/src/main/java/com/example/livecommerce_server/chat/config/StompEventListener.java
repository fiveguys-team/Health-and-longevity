package com.example.livecommerce_server.chat.config;

import com.example.livecommerce_server.chat.service.ChatService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;
import org.springframework.web.socket.messaging.SessionSubscribeEvent;
import org.springframework.web.socket.messaging.SessionUnsubscribeEvent;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * STOMP WebSocket 연결/해제 이벤트를 감지하여
 * 세션 수 추적 및 채팅방 참여자 수를 관리합니다.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class StompEventListener {

    private final Set<String> sessions = ConcurrentHashMap.newKeySet();

    private final ChatService chatService;

    /**
     * 클라이언트가 채팅방을 구독할 때 호출됨 (참여자 수 증가)
     */
    @EventListener
    public void handleSessionSubscribe(SessionSubscribeEvent event) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = accessor.getSessionId();
        sessions.add(sessionId);
        log.info("채팅방 구독 - 세션 ID: {}, 현재 총 세션 수: {}", sessionId, sessions.size());

        try {
            String roomIdHeader = accessor.getFirstNativeHeader("roomId");
            if (roomIdHeader != null) {
                Long roomId = Long.parseLong(roomIdHeader);
                chatService.increaseParticipantCount(roomId);
                log.info("참여자 수 증가 처리 완료 - roomId: {}", roomId);
            } else {
                log.warn("roomId 헤더가 없어서 참여자 수 증가 처리 생략 - 세션 ID: {}", sessionId);
            }
        } catch (Exception e) {
            log.error("구독 시 참여자 수 증가 중 오류 발생", e);
        }
    }

    /**
     * 클라이언트가 채팅방 구독 해제할 때 호출됨 (참여자 수 감소)
     */
    @EventListener
    public void handleSessionUnsubscribe(SessionUnsubscribeEvent event) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = accessor.getSessionId();
        sessions.remove(sessionId);
        log.info("채팅방 구독 해제 - 세션 ID: {}, 현재 총 세션 수: {}", sessionId, sessions.size());

        try {
            String roomIdHeader = accessor.getFirstNativeHeader("roomId");
            if (roomIdHeader != null) {
                Long roomId = Long.parseLong(roomIdHeader);
                chatService.decreaseParticipantCount(roomId);
                log.info("참여자 수 감소 처리 완료 - roomId: {}", roomId);
            } else {
                log.warn("roomId 헤더가 없어 참여자 수 감소 처리 생략 - 세션 ID: {}", sessionId);
            }
        } catch (Exception e) {
            log.error("구독 해제 시 참여자 수 감소 중 오류 발생", e);
        }
    }
}




