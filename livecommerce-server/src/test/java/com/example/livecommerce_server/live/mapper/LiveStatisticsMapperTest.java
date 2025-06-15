package com.example.livecommerce_server.live.mapper;

import static org.junit.jupiter.api.Assertions.*;

import com.example.livecommerce_server.live.dto.LiveViewerStatsDTO;
import com.example.livecommerce_server.live.vo.LiveStatisticsVO;
import java.util.List;
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

	@Test
	@DisplayName("현재 시청자 수 조회")
	void selectCurrentViewerCount() {
		int viewerCount = liveStatisticsMapper.selectCurrentViewerCount(
				"cccccccc-cccc-cccc-cccc-cccccccccccc");
		log.info(String.valueOf(viewerCount));
	}

	// 라이브 방송 통계 대시보드 저장 테스트


	@Test
	@DisplayName("총 시청자 수 조회")
	void selectTotalViewers() {
		int selectTotalViewers = liveStatisticsMapper.selectTotalViewers("cccccccc-cccc-cccc-cccc-cccccccccccc");
		log.info(String.valueOf(selectTotalViewers));
	}

	//  최대 동시 시청자 수 조회


	@Test
	@DisplayName("평균 시청 시간 조회 (초 단위)")
	void selectAverageWatchDuration() {
		int watchDuration = liveStatisticsMapper.selectAverageWatchDuration(
				"cccccccc-cccc-cccc-cccc-cccccccccccc");
		log.info(String.valueOf(watchDuration));
	}

	@Test
	@DisplayName("라이브 통계 조회")
	void selectLiveStatisticsList() {
		List<LiveStatisticsVO> list = liveStatisticsMapper.selectLiveStatisticsList("1");
		list.forEach(System.out::println);
	}


}