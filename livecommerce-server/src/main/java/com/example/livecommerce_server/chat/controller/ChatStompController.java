package com.example.livecommerce_server.chat.controller;

import com.example.livecommerce_server.chat.dto.ChatMessageReqDto;
import com.example.livecommerce_server.chat.enums.BanwordFilterPolicy;
import com.example.livecommerce_server.chat.service.ChatMessageService;
import com.example.livecommerce_server.chat.service.ChatService;
import com.example.livecommerce_server.chat.validator.BanwordValidator;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.time.LocalDateTime;
import java.util.Set;

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


        log.info("채팅 메시지 수신 - 채팅방 ID: {}, 사용자 ID: {}, 메시지: {},  messageDto.getUserName()",
                roomId, messageDto.getUserId(), messageDto.getContent());

            // 1단계: 기본 금칙어 검사
            boolean hasBanword = banwordValidator.containsBanword(messageDto.getContent());

            // 2단계: 우회 단어 검사 (기본 검사에서 안 걸린 경우에만)
            if (!hasBanword) {
                hasBanword = banwordValidator.containsBanword(
                        messageDto.getContent(),
                        Set.of(
                                BanwordFilterPolicy.NUMBERS,      // 숫자 제거
                                BanwordFilterPolicy.WHITESPACES,  // 공백 제거
                                BanwordFilterPolicy.ENGLISH       // 영어 제거
                        )
                );
            }
            if (hasBanword) {
                log.warn("부적절한 메시지 차단 - 사용자 ID: {}, 메시지: {}",
                        messageDto.getUserId(), messageDto.getContent());

                // 경고 메시지 생성
                ChatMessageReqDto warningMessage = ChatMessageReqDto.createWarningMessage(
                        "부적절한 표현이 감지되었습니다.", roomId
                );

                // 디버깅 로그 추가
                log.info("경고 메시지 생성 완료: {}", warningMessage.getContent());
                log.info("경고 메시지 전송 시도 - 사용자 ID: {}", messageDto.getUserId());

                try {
                    messageTemplate.convertAndSendToUser(
                            messageDto.getUserId().toString(),
                            "/queue/warning",
                            warningMessage
                    );
                    log.info("경고 메시지 전송 성공!");
                } catch (Exception e) {
                    log.error("경고 메시지 전송 실패", e);
                }

                return;
            }


                // 메시지에 시간 추가
        messageDto.setCreatedAt(LocalDateTime.now());
        messageDto.setRoomId(roomId);

        //1. 메세지를 데이터베이스에 저장
        chatMessageService.addMessage(messageDto);

        // 모든 구독자에게 메시지 전송
        messageTemplate.convertAndSend("/topic/" + roomId, messageDto);
    }
        catch (Exception e) {
            log.error("메세지 처리중 오류 발생", e);
        }
    }

}
