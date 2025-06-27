package com.example.livecommerce_server.chat.config;

import com.example.livecommerce_server.chat.service.ChatService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;
import org.springframework.web.socket.messaging.SessionSubscribeEvent;
import org.springframework.web.socket.messaging.SessionUnsubscribeEvent;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 🆕 세션 추적 기반 STOMP WebSocket 이벤트 처리
 * Redis에 사용자별 세션을 추적하여 정확한 실제 사용자 수를 관리합니다.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class StompEventListener {

    // 세션ID → roomId 매핑 저장소
    private final Map<String, Long> sessionRoomMap = new ConcurrentHashMap<>();

    // 세션ID → userId 매핑 저장소
    private final Map<String, Long> sessionUserMap = new ConcurrentHashMap<>();

    private final ChatService chatService;
    private final SimpMessagingTemplate messagingTemplate;

    /**
     * 🆕 세션 추적 기반 채팅방 구독 이벤트 처리
     */
    @EventListener
    public void handleSessionSubscribe(SessionSubscribeEvent event) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = accessor.getSessionId();

        try {
            // 1. 사용자 정보 추출
            Long userId = extractUserId(accessor);
            if (userId == null) {
                log.debug("사용자 정보 없음 - sessionId: {}", sessionId);
                return;
            }

            // 2. roomId 추출
            String roomIdHeader = accessor.getFirstNativeHeader("roomId");
            if (roomIdHeader == null) {
                log.debug("roomId 없음 - sessionId: {}", sessionId);
                return;
            }

            Long roomId = Long.parseLong(roomIdHeader);

            // 3. 매핑 정보 저장
            sessionRoomMap.put(sessionId, roomId);
            sessionUserMap.put(sessionId, userId);

            // 4. 🆕 세션 추적 기반 참여자 수 증가 처리
            int updatedCount = chatService.increaseParticipantCount(roomId, userId, sessionId);
            if (updatedCount == -1) {
                log.error("❌ 참여자 수 증가 실패 - roomId: {}, userId: {}, sessionId: {}",
                        roomId, userId, sessionId);
                return;
            }

            // 🎯 세션 추적 성공 로그
            log.info("🔥 세션 추적 참여 - roomId: {}, userId: {}, sessionId: {}, 실제 사용자: {}명",
                    roomId, userId, sessionId, updatedCount);

            // 5. 참여자 수 브로드캐스트
            messagingTemplate.convertAndSend("/topic/room." + roomId + ".participants", updatedCount);

        } catch (NumberFormatException e) {
            log.error("❌ roomId 파싱 실패 - sessionId: {}", sessionId);
        } catch (Exception e) {
            log.error("❌ 구독 처리 오류 - sessionId: {}", sessionId, e);
        }
    }

    /**
     * 사용자 ID 추출
     */
    private Long extractUserId(StompHeaderAccessor accessor) {
        try {
            String userIdHeader = accessor.getFirstNativeHeader("userId");

            if (userIdHeader != null && !userIdHeader.trim().isEmpty()) {
                return Long.parseLong(userIdHeader);
            }

            return null;

        } catch (NumberFormatException e) {
            log.warn("userId 파싱 실패: {}", accessor.getFirstNativeHeader("userId"));
            return null;
        } catch (Exception e) {
            log.error("사용자 ID 추출 오류", e);
            return null;
        }
    }

    /**
     * 채팅방 구독 해제
     */
    @EventListener
    public void handleSessionUnsubscribe(SessionUnsubscribeEvent event) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = accessor.getSessionId();

        log.info("📤 구독 해제 - sessionId: {}", sessionId);
        processLeave(sessionId);
    }

    /**
     * WebSocket 연결 해제
     */
    @EventListener
    public void handleSessionDisconnect(SessionDisconnectEvent event) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = accessor.getSessionId();

        log.info("🔌 연결 해제 - sessionId: {}", sessionId);
        processLeave(sessionId);
    }

    /**
     * 🆕 세션 추적 기반 참여자 수 감소 처리 (공통 로직)
     */
    private void processLeave(String sessionId) {
        Long roomId = sessionRoomMap.remove(sessionId);
        Long userId = sessionUserMap.remove(sessionId);

        if (roomId == null || userId == null) {
            log.debug("매핑 정보 없음 - sessionId: {}", sessionId);
            return;
        }

        try {
            // 세션 추적 기반 참여자 수 감소 처리
            int updatedCount = chatService.decreaseParticipantCount(roomId, userId, sessionId);

            //  세션 추적 퇴장 로그
            log.info("🔥 세션 추적 퇴장 - roomId: {}, userId: {}, sessionId: {}, 실제 사용자: {}명",
                    roomId, userId, sessionId, updatedCount);

            messagingTemplate.convertAndSend("/topic/room." + roomId + ".participants", updatedCount);

        } catch (Exception e) {
            log.error(" 퇴장 처리 오류 - roomId: {}, userId: {}, sessionId: {}",
                    roomId, userId, sessionId, e);
        }
    }
}