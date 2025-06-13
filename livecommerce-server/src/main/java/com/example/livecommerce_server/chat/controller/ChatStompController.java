package com.example.livecommerce_server.chat.controller;

import com.example.livecommerce_server.chat.dto.ChatMessageReqDto;
import com.example.livecommerce_server.chat.enums.BanwordFilterPolicy;
import com.example.livecommerce_server.chat.service.ChatMessageService;
import com.example.livecommerce_server.chat.validator.BanwordValidator;
import com.example.livecommerce_server.chat.validator.DuplicateMessageValidator;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.time.LocalDateTime;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

/**
 * 실시간 채팅 메시지 처리를 위한 STOMP 컨트롤러
 * 이 클래스는 WebSocket을 통한 실시간 채팅 메시지 송수신을 처리하고,
 * 메시지를 데이터베이스에 저장하는 기능을 제공합니다.
 */
@Controller
@RequiredArgsConstructor
@Slf4j
public class ChatStompController {

    private final SimpMessagingTemplate messageTemplate;
    private final ChatMessageService chatMessageService;
    private final BanwordValidator banwordValidator;
    private final DuplicateMessageValidator duplicateMessageValidator;



    /**
     * 채팅 메시지 전송 및 저장 처리
     * 클라이언트로부터 받은 메시지를 DB에 저장하고 해당 채팅방의
     * 모든 구독자에게 실시간으로 전송합니다.
     *
     * @param roomId 채팅방 ID
     * @param messageDto 전송할 메시지 정보 (내용, 사용자 ID 등)
     */
    @MessageMapping("/chat/send/{roomId}")
    public void sendMessage(@DestinationVariable Long roomId, ChatMessageReqDto messageDto) {
        try {
            log.info("채팅 메시지 수신 - 채팅방 ID: {}, 사용자 ID: {}, 메시지: {}",
                    roomId, messageDto.getUserId(), messageDto.getContent());

            // 1. 중복 메시지 도배 검증
            DuplicateMessageValidator.ValidationResult validationResult =
                    duplicateMessageValidator.validate(messageDto.getUserId(), roomId, messageDto.getContent());

            // 1-1. 차단된 경우 → 개인 경고 메시지 전송
            if (!validationResult.isAllowed()) {
                sendWarningToUser(messageDto.getUserId(), validationResult.getMessage());
                return;
            }

            // 1-2. 딜레이가 필요한 경우 → 지연 후 처리
            if (validationResult.isDelayed()) {
                log.info("메시지 딜레이 적용 - 사용자 ID: {}, 딜레이: {}초",
                        messageDto.getUserId(), validationResult.getDelaySeconds());

                // 비동기로 딜레이 처리 (메인 스레드 블로킹 방지)
                CompletableFuture.delayedExecutor(
                        validationResult.getDelaySeconds(), TimeUnit.SECONDS
                ).execute(() -> {
                    processMessage(roomId, messageDto);
                });
                return;
            }

            // 2. 딜레이 없이 즉시 처리
            processMessage(roomId, messageDto);

        } catch (Exception e) {
            log.error("메시지 처리중 오류 발생", e);
        }
    }

    /**
     * 실제 메시지 처리 로직 (금칙어 검사, 저장, 전송)
     */
    private void processMessage(Long roomId, ChatMessageReqDto messageDto) {
        // 1. 기본 금칙어 검사
        boolean hasBanword = banwordValidator.containsBanword(messageDto.getContent());

        // 2. 우회 단어 검사 (기본 검사에서 안 걸린 경우에만)
        if (!hasBanword) {
            hasBanword = banwordValidator.containsBanword(
                    messageDto.getContent(),
                    Set.of(
                            BanwordFilterPolicy.NUMBERS,      // 숫자 제거
                            BanwordFilterPolicy.WHITESPACES,  // 공백 제거
                            BanwordFilterPolicy.ENGLISH,       // 영어 제거
                            BanwordFilterPolicy.SPECIAL_CHARACTERS //특수 문자 제거
                    )
            );
        }

        // 3. 금칙어가 있으면 경고 메시지 전송
        if (hasBanword) {
            log.warn("부적절한 메시지 차단 - 사용자 ID: {}, 메시지: {}",
                    messageDto.getUserId(), messageDto.getContent());

            sendWarningToUser(messageDto.getUserId(), "부적절한 표현이 감지되었습니다.");
            return;
        }

        // 4. 메시지에 시간 추가
        messageDto.setCreatedAt(LocalDateTime.now());
        messageDto.setRoomId(roomId);

        // 5. 메시지를 데이터베이스에 저장
        chatMessageService.addMessage(messageDto);

        // 6. 모든 구독자에게 메시지 전송
        messageTemplate.convertAndSend("/topic/" + roomId, messageDto);

        log.info("메시지 전송 완료 - 채팅방 ID: {}, 사용자 ID: {}", roomId, messageDto.getUserId());
    }

    /**
     * 개별 사용자에게 경고 메시지 전송
     */
    private void sendWarningToUser(Long userId, String warningMessage) {
        ChatMessageReqDto warning = ChatMessageReqDto.createWarningMessage(
                warningMessage, null
        );

        try {
            messageTemplate.convertAndSendToUser(
                    userId.toString(),
                    "/queue/warning",
                    warning
            );
            log.info("경고 메시지 전송 - 사용자 ID: {}, 내용: {}", userId, warningMessage);
        } catch (Exception e) {
            log.error("경고 메시지 전송 실패 - 사용자 ID: {}", userId, e);
        }
    }

}
