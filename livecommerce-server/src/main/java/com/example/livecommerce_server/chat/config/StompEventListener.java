package com.example.livecommerce_server.chat.config;

import com.example.livecommerce_server.chat.dto.ChatMessageReqDto;
import com.example.livecommerce_server.chat.service.ChatRecentMessageService;
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

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * STOMP WebSocket 연결/해제 이벤트를 감지하여
 * 세션 수 추적, 채팅방 참여자 수 관리, 최근 메시지 제공을 합니다.
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

    // 🆕 최근 메시지 조회 서비스 추가
    private final ChatRecentMessageService chatRecentMessageService;

    /**
     * 채팅방 구독 (참여자 수 증가 + 최근 메시지 전송)
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

                // 1. sessionId → roomId 매핑 저장
                sessionRoomMap.put(sessionId, roomId);

                // 2. 참여자 수 증가 처리
                int updatedCount = chatService.increaseParticipantCount(roomId);
                log.info("참여자 수 증가 처리 완료 - roomId: {}, count: {}", roomId, updatedCount);

                // 3. 참여자 수 브로드캐스트
                messagingTemplate.convertAndSend("/topic/room." + roomId + ".participants", updatedCount);

                // 4. 🆕 최근 메시지 전송 (새로 입장한 사용자에게만)
                sendRecentMessagesToUser(sessionId, roomId);

            } else {
                log.warn("roomId 헤더가 없어서 참여자 수 증가 및 최근 메시지 전송 생략 - 세션 ID: {}", sessionId);
            }
        } catch (Exception e) {
            log.error("구독 시 처리 중 오류 발생", e);
        }
    }

    /**
     * 🆕 새로 입장한 사용자에게 최근 메시지 전송
     *
     * @param sessionId 사용자 세션 ID
     * @param roomId 채팅방 ID
     */
    private void sendRecentMessagesToUser(String sessionId, Long roomId) {
        try {
            // 1. 최근 메시지 조회
            List<ChatMessageReqDto> recentMessages = chatRecentMessageService.getRecentMessagesAsDto(roomId);

            if (recentMessages.isEmpty()) {
                log.info(" 전송할 최근 메시지 없음 - sessionId: {}, roomId: {}", sessionId, roomId);
                return;
            }

            // 2. 해당 사용자에게만 개별 전송 (다른 사용자들에게는 보내지 않음)
            for (ChatMessageReqDto message : recentMessages) {
                messagingTemplate.convertAndSendToUser(
                        sessionId,                    // 특정 세션에게만
                        "/queue/recent-messages",     // 최근 메시지 전용 큐
                        message
                );
            }

            log.info("📋 최근 메시지 전송 완료");
            log.info("    대상: sessionId {}", sessionId);
            log.info("    채팅방: {}", roomId);
            log.info("    전송 메시지 수: {}개", recentMessages.size());

        } catch (Exception e) {
            log.error("최근 메시지 전송 실패 - sessionId: {}, roomId: {}", sessionId, roomId, e);
            // 최근 메시지 전송 실패해도 채팅방 입장은 성공으로 처리
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