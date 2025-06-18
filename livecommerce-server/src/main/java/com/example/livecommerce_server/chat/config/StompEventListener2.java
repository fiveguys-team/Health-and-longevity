//package com.example.livecommerce_server.chat.config;
//
//import com.example.livecommerce_server.chat.service.ChatService;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.context.event.EventListener;
//import org.springframework.messaging.simp.SimpMessagingTemplate;
//import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
//import org.springframework.stereotype.Component;
//import org.springframework.web.socket.messaging.SessionDisconnectEvent;
//import org.springframework.web.socket.messaging.SessionSubscribeEvent;
//import org.springframework.web.socket.messaging.SessionUnsubscribeEvent;
//
//import java.util.Map;
//import java.util.Set;
//import java.util.concurrent.ConcurrentHashMap;
//
///**
// * STOMP WebSocket 이벤트 처리로 채팅방 참여자 수를 관리합니다.
// * Redis 기반으로 사용자별 참여자 수를 추적합니다.
// */
//@Component
//@RequiredArgsConstructor
//@Slf4j
//public class StompEventListener2 {
//
//    // 전체 세션 목록
//    private final Set<String> sessions = ConcurrentHashMap.newKeySet();
//
//    // 세션ID → roomId 매핑 저장소
//    private final Map<String, Long> sessionRoomMap = new ConcurrentHashMap<>();
//
//    // 🆕 세션ID → userId 매핑 저장소 (Redis 방식에 필요)
//    private final Map<String, Long> sessionUserMap = new ConcurrentHashMap<>();
//
//    private final ChatService chatService;
//    private final SimpMessagingTemplate messagingTemplate;
//
//    /**
//     * 채팅방 구독 (참여자 수 증가 + 최근 메시지 전송)
//     */
//    @EventListener
//    public void handleSessionSubscribe(SessionSubscribeEvent event) {
//        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
//        String sessionId = accessor.getSessionId();
//        sessions.add(sessionId);
//        log.info("채팅방 구독 - 세션 ID: {}, 현재 총 세션 수: {}", sessionId, sessions.size());
//
//        try {
//            // 1. 사용자 정보 추출
//            Long userId = extractUserId(accessor);
//            if (userId == null) {
//                log.warn("❌ 사용자 정보를 추출할 수 없습니다 - sessionId: {}", sessionId);
//                return;
//            }
//
//            // 2. roomId 추출
//            String roomIdHeader = accessor.getFirstNativeHeader("roomId");
//            if (roomIdHeader == null) {
//                log.warn("❌ roomId 헤더가 없어서 참여자 수 증가 및 최근 메시지 전송 생략 - sessionId: {}", sessionId);
//                return;
//            }
//
//            Long roomId = Long.parseLong(roomIdHeader);
//
//            // 3. 매핑 정보 저장
//            sessionRoomMap.put(sessionId, roomId);
//            sessionUserMap.put(sessionId, userId);
//
//            // 4. 🆕 Redis 기반 참여자 수 증가 처리 (userId 포함)
//            int updatedCount = chatService.increaseParticipantCount(roomId, userId);
//            if (updatedCount == -1) {
//                log.error("❌ 참여자 수 증가 실패 - roomId: {}, userId: {}", roomId, userId);
//                return;
//            }
//
//            log.info("✅ 참여자 수 증가 처리 완료 - roomId: {}, userId: {}, count: {}",
//                    roomId, userId, updatedCount);
//
//            // 5. 참여자 수 브로드캐스트
//            messagingTemplate.convertAndSend("/topic/room." + roomId + ".participants", updatedCount);
//
//
//        } catch (NumberFormatException e) {
//            log.error("❌ roomId 파싱 실패 - sessionId: {}", sessionId, e);
//        } catch (Exception e) {
//            log.error("❌ 구독 시 처리 중 오류 발생 - sessionId: {}", sessionId, e);
//        }
//    }
//
//    /**
//     * 🆕 WebSocket 헤더에서 사용자 ID 추출 (간소화 버전)
//     *
//     * @param accessor STOMP 헤더 접근자
//     * @return 사용자 ID (추출 실패 시 null)
//     */
//    private Long extractUserId(StompHeaderAccessor accessor) {
//        try {
//            // Vue에서 전송한 userId 헤더에서 추출
//            String userIdHeader = accessor.getFirstNativeHeader("userId");
//
//            if (userIdHeader != null && !userIdHeader.trim().isEmpty()) {
//                Long userId = Long.parseLong(userIdHeader);
//                log.info("✅ 헤더에서 사용자 ID 추출 성공 - userId: {}", userId);
//                return userId;
//            }
//
//            log.warn("❌ userId 헤더가 없거나 비어있음");
//            log.warn("   Vue에서 구독 시 userId 헤더를 전송해주세요!");
//            log.warn("   예시: stompClient.subscribe(topic, callback, {{ roomId: '123', userId: '100' }})");
//
//            return null;
//
//        } catch (NumberFormatException e) {
//            log.error("❌ userId 헤더 파싱 실패 - userIdHeader: {}",
//                    accessor.getFirstNativeHeader("userId"), e);
//            return null;
//        } catch (Exception e) {
//            log.error("❌ 사용자 ID 추출 중 오류 발생", e);
//            return null;
//        }
//    }
//
//
//
//    /**
//     * 채팅방 구독 해제 (참여자 수 감소)
//     */
//    @EventListener
//    public void handleSessionUnsubscribe(SessionUnsubscribeEvent event) {
//        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
//        String sessionId = accessor.getSessionId();
//        sessions.remove(sessionId);
//        log.info("채팅방 구독 해제 - 세션 ID: {}, 현재 총 세션 수: {}", sessionId, sessions.size());
//
//        processLeave(sessionId);
//    }
//
//    /**
//     * WebSocket 연결 해제 (세션 종료 시 참여자 수 감소)
//     */
//    @EventListener
//    public void handleSessionDisconnect(SessionDisconnectEvent event) {
//        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
//        String sessionId = accessor.getSessionId();
//        sessions.remove(sessionId);
//        log.info("WebSocket 연결 해제 - 세션 ID: {}, 현재 총 세션 수: {}", sessionId, sessions.size());
//
//        processLeave(sessionId);
//    }
//
//    /**
//     * 참여자 수 감소 처리 (공통 로직) - Redis 기반
//     */
//    private void processLeave(String sessionId) {
//        Long roomId = sessionRoomMap.remove(sessionId);
//        Long userId = sessionUserMap.remove(sessionId); // 🆕 userId도 함께 제거
//
//        if (roomId == null || userId == null) {
//            log.warn("⚠️ 세션에 해당하는 매핑 정보 없음 - sessionId: {}, roomId: {}, userId: {}",
//                    sessionId, roomId, userId);
//            return;
//        }
//
//        try {
//            // 🆕 Redis 기반 참여자 수 감소 처리 (userId 포함)
//            int updatedCount = chatService.decreaseParticipantCount(roomId, userId);
//
//            log.info("✅ 참여자 수 감소 처리 완료 - roomId: {}, userId: {}, count: {}",
//                    roomId, userId, updatedCount);
//
//            messagingTemplate.convertAndSend("/topic/room." + roomId + ".participants", updatedCount);
//
//        } catch (Exception e) {
//            log.error("❌ 참여자 수 감소 처리 중 오류 발생 - sessionId: {}, roomId: {}, userId: {}",
//                    sessionId, roomId, userId, e);
//        }
//    }
//}