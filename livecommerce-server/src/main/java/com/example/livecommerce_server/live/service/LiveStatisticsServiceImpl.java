package com.example.livecommerce_server.live.service;

import com.example.livecommerce_server.chat.service.ChatParticipantRedisService;
import com.example.livecommerce_server.live.dto.LiveStatisticsDTO;
import com.example.livecommerce_server.live.dto.LiveViewerStatsDTO;
import com.example.livecommerce_server.live.mapper.LiveStatisticsMapper;
import com.example.livecommerce_server.live.vo.LiveStatisticsVO;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.format.DateTimeFormatter;

@Slf4j
@Service
@RequiredArgsConstructor
public class LiveStatisticsServiceImpl implements LiveStatisticsService {

    private final LiveStatisticsMapper liveStatisticsMapper;
    private final ChatParticipantRedisService chatParticipantRedisService;

    private String nowCompactString() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }

    @Override
    @Transactional
    public void addViewerJoin(String liveId, String userId) {
        LiveViewerStatsDTO viewerLog = LiveViewerStatsDTO.builder()
                .liveId(liveId)
                .userId(userId)
                .joinAt(nowCompactString())
                .isAnonymous(false) // 익명 여부 확인 필요
                .build();
        liveStatisticsMapper.insertViewerJoin(viewerLog);
    }

    @Override
    @Transactional
    public void saveViewerLeave(String liveId, String userId) {
        liveStatisticsMapper.updateViewerLeave(liveId, userId, nowCompactString());
    }

    @Override
    @Transactional
    public LiveStatisticsVO calculateAndSaveStatistics(String liveId) {
        String uuid = UUID.randomUUID().toString();
        int totalViewers = chatParticipantRedisService.getFinalTotalViewers(liveId);
        int maxConcurrentViewers = liveStatisticsMapper.selectMaxConcurrentViewers(liveId);
        int averageWatchDuration = liveStatisticsMapper.selectAverageWatchDuration(liveId);
        long totalReve = liveStatisticsMapper.selectTotalRevenue(liveId);
        int totalOrders = liveStatisticsMapper.selectTotalOrders(liveId);
        int purchaseRatio = liveStatisticsMapper.selectPurchaseRatio(liveId);

        LiveStatisticsVO dashboard = LiveStatisticsVO.builder()
                .liveDashboardId(uuid) 
                .liveId(liveId)
                .totalViewers(totalViewers)
                .maxConcurrentViewers(maxConcurrentViewers)
                .averageWatchDuration(averageWatchDuration)
                .totalReve(totalReve)
                .totalOrders(totalOrders)
                .purchaseRatio(purchaseRatio)
                .build();

        liveStatisticsMapper.insertLiveDashboard(dashboard);
        return dashboard;
    }

    @Override
    public int selectCurrentViewerCount(String liveId) {
        return liveStatisticsMapper.selectCurrentViewerCount(liveId);
    }

    @Override
    public List<LiveStatisticsDTO> findLiveStatisticsList(String vendorId) {
        return liveStatisticsMapper.selectLiveStatisticsList(vendorId);

    }
} 