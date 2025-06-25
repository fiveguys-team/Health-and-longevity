package com.example.livecommerce_server.chat.service;


import com.example.livecommerce_server.chat.dto.ChatMessageReqDto;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 채팅 메시지 발행자 (Phase 2-2: ChatMessageReqDto 적용)
 *
 * 기능:
 * - ChatMessageReqDto 객체를 JSON으로 변환
 * - Redis 채널에 메시지 발행
 * - 다중 서버 간 실시간 메시지 동기화
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ChatPublisher {
    // 문자열 기반 Redis Template (Pub/Sub 성능 최적화)
    private final StringRedisTemplate stringRedisTemplate;

    // JSON 직렬화를 위한 ObjectMapper
    private final ObjectMapper objectMapper;

    // Redis List 최대 저장 개수
    private static final int MAX_RECENT_MESSAGES = 50;

    /**
     * 채팅 메시지를 Redis 채널에 발행
     *
     * @param messageDto 발행할 채팅 메시지 DTO
     */
    public void publishMessage(ChatMessageReqDto messageDto) {
        try {
            // 1. 채널명 생성: "chat:room:123" 및 리스트 키 생성
            String channelName = createChannelName(messageDto.getRoomId());
            String listKey = createMessageListKey(messageDto.getRoomId());

            // 2. ChatMessageReqDto → JSON 문자열 변환
            String jsonMessage = objectMapper.writeValueAsString(messageDto);

            // 3. Redis 채널에 JSON 메시지 발행
            stringRedisTemplate.convertAndSend(channelName, jsonMessage);

            // 3-1  Redis List에 최근 메시지 저장
            saveToRecentMessagesList(listKey, jsonMessage, messageDto.getRoomId());


            // 4. 발행 성공 로그
            log.info(" 채팅 메시지 발행 완료");
            log.info("    채널: {}", channelName);
            log.info("   사용자: {} ({})", messageDto.getUserName(), messageDto.getUserId());
            log.info("   내용: {}", messageDto.getContent());
            log.info("   JSON 크기: {} bytes", jsonMessage.length());

        } catch (JsonProcessingException e) {
            log.error("JSON 직렬화 실패 - messageDto: {}", messageDto, e);
            throw new RuntimeException("메시지 발행 실패: JSON 변환 오류", e);

        } catch (Exception e) {
            log.error("Redis 메시지 발행 실패 - messageDto: {}", messageDto, e);
            throw new RuntimeException("메시지 발행 실패: Redis 오류", e);
        }
    }

    /**
     *  Redis List에 최근 메시지 저장 (최대 50개 유지)
     *
     * @param listKey Redis List 키
     * @param jsonMessage JSON 형태의 메시지
     * @param roomId 채팅방 ID (로깅용)
     */
    private void saveToRecentMessagesList(String listKey, String jsonMessage, Long roomId) {
        try {
            // 1. 리스트 맨 앞에 새 메시지 추가 (최신 메시지가 맨 앞)
            stringRedisTemplate.opsForList().leftPush(listKey, jsonMessage);

            // 2. 50개 넘으면 오래된 메시지 자동 삭제
            stringRedisTemplate.opsForList().trim(listKey, 0, MAX_RECENT_MESSAGES - 1);

            // 3. 현재 저장된 메시지 개수 확인 (로깅용)
            Long currentSize = stringRedisTemplate.opsForList().size(listKey);

            log.info("💾 최근 메시지 List 저장 완료");
            log.info("    Key: {}", listKey);
            log.info("    현재 저장 개수: {}/{}", currentSize, MAX_RECENT_MESSAGES);

        } catch (Exception e) {
            log.error("Redis List 저장 실패 - listKey: {}, roomId: {}", listKey, roomId, e);
            // List 저장 실패해도 Pub/Sub은 성공했으므로 예외를 다시 던지지 않음
        }
    }
    /**
     *  최근 메시지 조회 (테스트 및 디버깅용)
     *
     * @param roomId 채팅방 ID
     * @return 최근 메시지 JSON 리스트 (최신순)
     */
    public List<String> getRecentMessages(Long roomId) {
        try {
            String listKey = createMessageListKey(roomId);

            // Redis List에서 모든 메시지 조회 (0부터 -1까지 = 전체)
            List<String> messages = stringRedisTemplate.opsForList().range(listKey, 0, -1);

            log.info("📋 최근 메시지 조회 완료 - roomId: {}, 개수: {}", roomId,
                    messages != null ? messages.size() : 0);

            return messages;

        } catch (Exception e) {
            log.error("최근 메시지 조회 실패 - roomId: {}", roomId, e);
            return List.of(); // 빈 리스트 반환
        }
    }

    /**
     * 시스템 경고 메시지 발행
     *
     * @param roomId 채팅방 ID
     * @param warningContent 경고 메시지 내용
     */
    public void publishWarningMessage(Long roomId, String warningContent) {
        // ChatMessageReqDto의 정적 메소드 활용
        ChatMessageReqDto warningMessage = ChatMessageReqDto.createWarningMessage(warningContent, roomId);
        publishMessage(warningMessage);

        log.info("⚠ 시스템 경고 메시지 발행: {}", warningContent);
    }

    /**
     * 테스트용 메시지 발행
     *
     * @param roomId 채팅방 ID
     */
    public void publishTestMessage(Long roomId) {
        ChatMessageReqDto testMessage = new ChatMessageReqDto();
        testMessage.setRoomId(roomId);
        testMessage.setUserId(999L);
        testMessage.setUserName("테스트봇");
        testMessage.setContent("테스트 메시지 - " + System.currentTimeMillis());
        testMessage.setCreatedAt(java.time.LocalDateTime.now());

        publishMessage(testMessage);

        log.info("🧪 테스트 메시지 발행 완료");
    }

    /**
     * 채널명 생성 (일관성 있는 명명 규칙)
     *
     * @param roomId 채팅방 ID
     * @return "chat:room:{roomId}" 형태의 채널명
     */
    private String createChannelName(Long roomId) {
        return "chat:room:" + roomId;
    }
    /**
     *  Redis List 키 생성
     */
    private String createMessageListKey(Long roomId) {
        return "chat:messages:" + roomId;
    }


}
