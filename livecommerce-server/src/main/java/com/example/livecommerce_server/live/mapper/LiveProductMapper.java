package com.example.livecommerce_server.live.mapper;

import com.example.livecommerce_server.live.vo.LiveProductVO;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface LiveProductMapper {
	void insertLiveProduct(@Param("list")List<LiveProductVO> list);
}
