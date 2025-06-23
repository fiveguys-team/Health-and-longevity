package com.example.livecommerce_server.chat.service;


import com.example.livecommerce_server.chat.dto.ChatMessageReqDto;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * 최근 채팅 메시지 조회 서비스
 *
 * 기능:
 * - Redis List에서 최근 메시지 조회
 * - JSON → ChatMessageReqDto 변환
 * - 사용자 입장 시 이전 대화 내역 제공
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ChatRecentMessageService {

    private final ChatPublisher chatPublisher;
    private final ObjectMapper objectMapper;


    /**
     * 최근 메시지를 DTO 리스트로 조회
     *
     * @param roomId 채팅방 ID
     * @return 최근 메시지 DTO 리스트 (시간순 정렬: 오래된 것부터)
     */
    public List<ChatMessageReqDto> getRecentMessagesAsDto(Long roomId) {
        try {
            // 1. Redis List에서 JSON 메시지들 조회 (최신순)
            List<String> jsonMessages = chatPublisher.getRecentMessages(roomId);

            if (jsonMessages == null || jsonMessages.isEmpty()) {
                log.info(" 최근 메시지 없음 - roomId: {}", roomId);
                return List.of();
            }

            // 2. JSON → DTO 변환
            List<ChatMessageReqDto> messageDtos = new ArrayList<>();

            for (String jsonMessage : jsonMessages) {
                try {
                    ChatMessageReqDto dto = objectMapper.readValue(jsonMessage, ChatMessageReqDto.class);
                    messageDtos.add(dto);

                } catch (Exception e) {
                    log.warn("JSON 파싱 실패, 해당 메시지 스킵 - roomId: {}, json: {}",
                            roomId, jsonMessage, e);
                    // 하나 실패해도 나머지는 계속 처리
                }
            }

            // 3. 시간순 정렬 (오래된 것부터)
            // Redis List: [최신, 이전, 더이전] → 클라이언트: [더이전, 이전, 최신]
            Collections.reverse(messageDtos);

            log.info(" 최근 메시지 DTO 변환 완료 - roomId: {}, 성공: {}개, 전체: {}개",
                    roomId, messageDtos.size(), jsonMessages.size());

            return messageDtos;

        } catch (Exception e) {
            log.error("최근 메시지 조회 실패 - roomId: {}", roomId, e);
            return List.of(); // 빈 리스트 반환
        }
    }
}
