package com.example.livecommerce_server.live.mapper;

import com.example.livecommerce_server.live.dto.LiveEndRequestDto;
import com.example.livecommerce_server.live.vo.LiveInfoVO;
import java.time.Instant;
import java.util.UUID;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
@Transactional
@ActiveProfiles("test")

class LiveMapperTest {

	@Autowired(required = false)
	private LiveMapper liveMapper;

	@Test
	@DisplayName("라이브 정보를 저장하는 메서드")
	void insertLiveInfoTest() {
		LiveInfoVO liveInfoVO = LiveInfoVO.builder()
				.live_id(UUID.randomUUID().toString())
				.vendor_id(String.valueOf(1))
				.session_id("세션ID값")
				.title("라이브 제목")
				.start_time("2025-06-10-11-51")
				.status("ON")
				.announcement("라이브 공지사항")
				.build();
		liveMapper.insertLiveInfo(liveInfoVO);
	}

	@Test
	@DisplayName("라이브 종료 정보를 저장하는 메서드")
	void updateLiveInfo() {
		String isoNow = Instant.now().toString();
		LiveEndRequestDto liveEndRequestDto = LiveEndRequestDto.builder()
				.sessionId("8879f4ba-1cf1-401a-a8b7-7ef9942b50af")
				.endTime(isoNow)
				.build();
		liveMapper.updateLiveInfo(liveEndRequestDto);
	}

	@Test
	@DisplayName("vendorId -> vendorName 반환하는 메서드")
	void selectVendorName() {
		String vendorName = liveMapper.selectVendorName("1");

		Assertions.assertThat(vendorName).isEqualTo("정관장");

	}

}