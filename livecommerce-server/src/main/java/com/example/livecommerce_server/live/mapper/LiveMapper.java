package com.example.livecommerce_server.live.mapper;

import com.example.livecommerce_server.live.dto.LiveEndRequestDto;
import com.example.livecommerce_server.live.vo.LiveInfoVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LiveMapper {

	/**
	 * 라이브 시작 시 정보를 저장하는 메서드
	 * @param liveInfoVO
	 */
	void insertLiveInfo(LiveInfoVO liveInfoVO);

	/**
	 * 라이브 종료 시 정보를 저장하는 메서드
	 * @param liveEndRequestDto
	 */

	void updateLiveInfo(LiveEndRequestDto liveEndRequestDto);

	/**
	 * 입점업체 Id를 통해 입점업체명을 반환하는 메서드
	 * @param vendorId
	 * @return
	 */
	String selectVendorName(String vendorId);

}
