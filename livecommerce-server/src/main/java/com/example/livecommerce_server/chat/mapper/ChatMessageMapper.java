package com.example.livecommerce_server.chat.mapper;


import com.example.livecommerce_server.chat.vo.ChatMessage;
import org.apache.ibatis.annotations.Mapper;

/**
 * 채팅 메시지 데이터 접근을 위한 Mapper 인터페이스
 * CHAT_MESSAGE_D 테이블에 대한 저장 작업을 정의합니다.
 */
@Mapper
public interface ChatMessageMapper {

    /**
     * 채팅 메시지 저장
     *
     * @param chatMessage 저장할 채팅 메시지 정보
     * @return 저장된 행의 수
     */
    int insertChatMessage(ChatMessage chatMessage);
}
