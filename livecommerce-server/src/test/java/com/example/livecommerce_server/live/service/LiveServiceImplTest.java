package com.example.livecommerce_server.live.service;

import static org.junit.jupiter.api.Assertions.*;

import com.example.livecommerce_server.live.dto.LiveDTO;
import java.util.UUID;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
@Transactional
@ActiveProfiles("test")
class LiveServiceImplTest {

	@Autowired(required = false)
	private LiveService liveService;

	@Test
	@DisplayName("라이브 정보 저장 서비스 메서드")
	void addLiveInfo() {
		LiveDTO liveDTO = LiveDTO.builder()
				.sessionId(UUID.randomUUID().toString())
				.title("방송 제목!")
				.announcement("공지!")
				.startTime("23232")
				.vendorId("1")
				.build();
		liveService.addLiveInfo(liveDTO);
	}

}