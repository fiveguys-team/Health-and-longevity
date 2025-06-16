package com.example.livecommerce_server.chat.controller;


import com.example.livecommerce_server.chat.dto.ChatRoomReqDto;
import com.example.livecommerce_server.chat.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 채팅 관련 REST API를 처리하는 컨트롤러
 * 이 클래스는 채팅방 자동 생성, 메시지 조회 등 실시간 채팅 기능의
 * REST 엔드포인트를 제공합니다.
 */
@RestController
@RequestMapping("api/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;

    /**
     * 방송 시작 시 전달받은 liveId로 채팅방을 자동 생성하고,
     * 생성된 채팅방의 ID를 응답으로 반환합니다.
     *
     * @param reqDto liveId를 담은 요청 DTO
     * @return 생성된 chatRoomId를 담은 응답 DTO와 HTTP 201 상태
     */
    @PostMapping("/room/auto-create")
    public ResponseEntity<?> autoCreateRoom(@RequestBody ChatRoomReqDto reqDto) {
        ChatRoomReqDto response = chatService.createGroupRoom(reqDto.getLiveId());
        return ResponseEntity.ok().body(response);
    }


}
