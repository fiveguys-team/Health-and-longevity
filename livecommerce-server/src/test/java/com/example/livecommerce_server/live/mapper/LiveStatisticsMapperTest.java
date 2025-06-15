package com.example.livecommerce_server.live.mapper;

import static org.junit.jupiter.api.Assertions.*;

import com.example.livecommerce_server.live.dto.LiveViewerStatsDTO;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
@Slf4j
@Transactional
@ActiveProfiles("test")
class LiveStatisticsMapperTest {

	@Autowired(required = false)
	private LiveStatisticsMapper liveStatisticsMapper;

	@Test
	@DisplayName("시청자 입장 정보 저장")
	void insertViewerJoin() {
		LiveViewerStatsDTO viewer = LiveViewerStatsDTO.builder()
				.viewerLogId(null)
				.liveId("cccccccc-cccc-cccc-cccc-cccccccccccc")
				.userId("1")
				.joinAt("2025-06-14T11:38:50.805866300Z")
				.build();
		liveStatisticsMapper.insertViewerJoin(viewer);
	}

	@Test
	@DisplayName("시청자 퇴장 정보 저장")
	void updateViewerLeave() {
		liveStatisticsMapper.updateViewerLeave("cccccccc-cccc-cccc-cccc-cccccccccccc", "1", "2025-06-14T11:38:50.805866300Z");
	}


}