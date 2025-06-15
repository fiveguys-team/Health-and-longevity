package com.example.livecommerce_server.chat.mapper;


import com.example.livecommerce_server.chat.vo.ChatRoom;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Optional;

@Mapper
public interface ChatRoomMapper {

    void insertChatRoom(ChatRoom room);

    /**
     * 채팅방 참여자 수 조회
     *
     * @param roomId 채팅방 ID
     * @return 현재 참여자 수 (채팅방이 없으면 Optional.empty())
     */
    Optional<Integer> selectParticipantCount(@Param("roomId") Long roomId);

    /**
     * 채팅방 참여자 수 업데이트
     *
     * @param roomId 채팅방 ID
     * @param count 증감할 수 (+1: 입장, -1: 퇴장)
     * @return 업데이트된 행 수
     */
    int updateParticipantCount(@Param("roomId") Long roomId,
                               @Param("count") int count);
}
