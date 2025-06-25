package com.example.livecommerce_server.chat.service;


import com.example.livecommerce_server.chat.dto.ChatMessageReqDto;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

/**
 * 채팅 메시지 구독자 (Phase 2-3)
 *
 * 기능:
 * - Redis 채널에서 JSON 메시지 수신
 * - JSON → ChatMessageReqDto 변환
 * - WebSocket으로 클라이언트들에게 브로드캐스트
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ChatSubscriber implements MessageListener {

    // WebSocket 메시지 전송용
    private final SimpMessagingTemplate messagingTemplate;

    // JSON 역직렬화용
    private final ObjectMapper objectMapper;

    /**
     * Redis에서 메시지를 수신했을 때 호출되는 메소드
     *
     * @param message Redis에서 받은 메시지 (바이트 배열)
     * @param pattern 구독한 채널 패턴 (현재는 사용 안함)
     */
    @Override
    public void onMessage(Message message, byte[] pattern) {
        try {
            // 1. 바이트 배열을 문자열로 변환
            String channel = new String(message.getChannel());
            String jsonMessage = new String(message.getBody());

            log.info(" Redis 메시지 수신");
            log.info("   채널: {}", channel);
            log.info("    JSON: {}", jsonMessage);

            // 2. 채널명에서 roomId 추출
            Long roomId = extractRoomIdFromChannel(channel);

            if (roomId != null) {
                // 3. JSON → ChatMessageReqDto 변환
                ChatMessageReqDto messageDto = objectMapper.readValue(jsonMessage, ChatMessageReqDto.class);

                // 4. WebSocket으로 해당 채팅방 구독자들에게 전송
                sendToWebSocket(roomId, messageDto);

            } else {
                log.warn(" 채널명에서 roomId 추출 실패: {}", channel);
            }

        } catch (Exception e) {
            log.error(" Redis 메시지 처리 중 오류 발생", e);
        }
    }

    /**
     * WebSocket으로 메시지 전송
     *
     * @param roomId 채팅방 ID
     * @param messageDto 전송할 메시지 DTO
     */
    private void sendToWebSocket(Long roomId, ChatMessageReqDto messageDto) {
        try {
            // WebSocket 목적지: "/topic/{roomId}"
            String destination = "/topic/" + roomId;

            // 해당 채팅방을 구독 중인 모든 클라이언트에게 전송
            messagingTemplate.convertAndSend(destination, messageDto);

            log.info(" WebSocket 메시지 전송 완료");
            log.info("    목적지: {}", destination);
            log.info("    사용자: {} ({})", messageDto.getUserName(), messageDto.getUserId());
            log.info("    내용: {}", messageDto.getContent());

        } catch (Exception e) {
            log.error(" WebSocket 메시지 전송 실패 - roomId: {}, messageDto: {}", roomId, messageDto, e);
        }
    }

    /**
     * 채널명에서 roomId 추출
     * "chat:room:123" → 123
     *
     * @param channel Redis 채널명
     * @return 추출된 roomId (실패시 null)
     */
    private Long extractRoomIdFromChannel(String channel) {
        try {
            // "chat:room:123" → ["chat", "room", "123"]로 분할
            String[] parts = channel.split(":");

            // 형식 확인: chat:room:숫자 형태인지 검증
            if (parts.length >= 3 && "chat".equals(parts[0]) && "room".equals(parts[1])) {
                return Long.parseLong(parts[2]);
            }

        } catch (NumberFormatException e) {
            log.error(" roomId 파싱 실패: {}", channel, e);
        }

        return null;
    }



}
