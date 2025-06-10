package com.example.livecommerce_server.chat.mapper;


import com.example.livecommerce_server.chat.vo.ChatRoom;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ChatRoomMapper {

    void insertChatRoom(ChatRoom room);
}
