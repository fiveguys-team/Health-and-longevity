package com.example.livecommerce_server.live.service;

import com.example.livecommerce_server.live.dto.LiveChatDTO;
import com.example.livecommerce_server.live.dto.LiveDTO;
import com.example.livecommerce_server.live.dto.LiveEndRequestDto;
import com.example.livecommerce_server.live.dto.LiveProductDTO;
import com.example.livecommerce_server.live.mapper.LiveMapper;
import com.example.livecommerce_server.live.mapper.LiveProductMapper;
import com.example.livecommerce_server.live.vo.LiveInfoVO;
import com.example.livecommerce_server.live.vo.LiveProductVO;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
public class LiveServiceImpl implements LiveService {

	private final LiveMapper liveMapper;
	private final LiveProductMapper liveProductMapper;

	/**
	 * 라이브 방송 정보 저장하는 메서드
	 * @param liveDTO
	 * @return 라이브 Id, Session Id DTO 반환
	 */
	@Override
	public LiveChatDTO addLiveInfo(LiveDTO liveDTO) {
		String liveId = UUID.randomUUID().toString();
		LiveInfoVO liveInfoVO = LiveInfoVO.builder()
				.live_id(liveId)
				.vendor_id(liveDTO.getVendorId())
				.session_id(liveDTO.getSessionId())
				.title(liveDTO.getTitle())
				.start_time(liveDTO.getStartTime())
				.status("ON") // 추후 변경
				.announcement(liveDTO.getAnnouncement())
				.build();
		liveMapper.insertLiveInfo(liveInfoVO);

		return LiveChatDTO.builder()
				.liveId(liveId)
				.sessionId(liveDTO.getSessionId())
				.build();
	}

	/**
	 * 라이브 방송 중 판매되는 할인 상품 저장하는 메서드
	 * @param liveProductList
	 */
	@Override
	public void addLiveProduct(List<LiveProductDTO> liveProductList) {
		List<LiveProductVO> list = liveProductList
				.stream()
				.map(dto -> LiveProductVO.builder()
						.live_id(dto.getLiveId())
						.product_id(dto.getProductId())
						.discountRate(dto.getDiscountRate())
				.build()).toList();

		liveProductMapper.insertLiveProduct(list);
	}

	/**
	 * 라이브 종료 후 종료 시간, 라이브 상태를 변경하는 메서드
	 * @param sessionId
	 */
	@Override
	public void saveLiveInfo(String sessionId) {
		LiveEndRequestDto liveEndRequestDto = LiveEndRequestDto.builder()
				.sessionId(sessionId)
				.endTime(Instant.now().toString())
				.build();

		liveMapper.updateLiveInfo(liveEndRequestDto);
	}
}
