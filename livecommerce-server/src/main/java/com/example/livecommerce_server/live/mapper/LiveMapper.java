package com.example.livecommerce_server.live.mapper;

import com.example.livecommerce_server.live.dto.LiveEndRequestDto;
import com.example.livecommerce_server.live.vo.LiveInfoVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LiveMapper {
	void insertLiveInfo(LiveInfoVO liveInfoVO);

	void updateLiveInfo(LiveEndRequestDto liveEndRequestDto);

}
