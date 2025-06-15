package com.example.livecommerce_server.chat.config;

import com.example.livecommerce_server.chat.service.ChatService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;
import org.springframework.web.socket.messaging.SessionSubscribeEvent;
import org.springframework.web.socket.messaging.SessionUnsubscribeEvent;

import java.util.Map;
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

    // 전체 세션 목록
    private final Set<String> sessions = ConcurrentHashMap.newKeySet();

    // 세션ID → roomId 매핑 저장소
    private final Map<String, Long> sessionRoomMap = new ConcurrentHashMap<>();

    private final ChatService chatService;
    private final SimpMessagingTemplate messagingTemplate;

    /**
     * 채팅방 구독 (참여자 수 증가)
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

                // sessionId → roomId 매핑 저장
                sessionRoomMap.put(sessionId, roomId);

                int updatedCount = chatService.increaseParticipantCount(roomId);
                log.info("참여자 수 증가 처리 완료 - roomId: {}", roomId);

                messagingTemplate.convertAndSend("/topic/room." + roomId + ".participants", updatedCount);
            } else {
                log.warn("roomId 헤더가 없어서 참여자 수 증가 처리 생략 - 세션 ID: {}", sessionId);
            }
        } catch (Exception e) {
            log.error("구독 시 참여자 수 증가 중 오류 발생", e);
        }
    }

    /**
     * 채팅방 구독 해제 (참여자 수 감소)
     */
    @EventListener
    public void handleSessionUnsubscribe(SessionUnsubscribeEvent event) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = accessor.getSessionId();
        sessions.remove(sessionId);
        log.info("채팅방 구독 해제 - 세션 ID: {}, 현재 총 세션 수: {}", sessionId, sessions.size());

        processLeave(sessionId);
    }

    /**
     * WebSocket 연결 해제 (세션 종료 시 참여자 수 감소)
     */
    @EventListener
    public void handleSessionDisconnect(SessionDisconnectEvent event) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = accessor.getSessionId();
        sessions.remove(sessionId);
        log.info("WebSocket 연결 해제 - 세션 ID: {}, 현재 총 세션 수: {}", sessionId, sessions.size());

        processLeave(sessionId);
    }

    /**
     * 참여자 수 감소 처리 (공통 로직)
     */
    private void processLeave(String sessionId) {
        Long roomId = sessionRoomMap.remove(sessionId);
        if (roomId == null) {
            log.warn("세션에 해당하는 roomId 정보 없음 - sessionId: {}", sessionId);
            return;
        }

        try {
            int updatedCount = chatService.decreaseParticipantCount(roomId);
            log.info("참여자 수 감소 처리 완료 - roomId: {}, count: {}", roomId, updatedCount);

            messagingTemplate.convertAndSend("/topic/room." + roomId + ".participants", updatedCount);
        } catch (Exception e) {
            log.error("참여자 수 감소 처리 중 오류 발생 - sessionId: {}, roomId: {}", sessionId, roomId, e);
        }
    }
}




