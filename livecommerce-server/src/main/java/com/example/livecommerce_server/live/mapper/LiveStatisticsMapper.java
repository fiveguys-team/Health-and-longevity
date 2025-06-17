package com.example.livecommerce_server.live.mapper;

import com.example.livecommerce_server.live.dto.LiveStatisticsDTO;
import com.example.livecommerce_server.live.dto.LiveViewerStatsDTO;
import com.example.livecommerce_server.live.vo.LiveStatisticsVO;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 라이브 통계 자료 Mapper
 */
@Mapper
public interface LiveStatisticsMapper {
    // 시청자 입장 정보 저장
    void insertViewerJoin(LiveViewerStatsDTO viewerLog);
    
    // 시청자 퇴장 정보 저장
    void updateViewerLeave(@Param("liveId") String liveId, @Param("userId") String userId, @Param("leaveAt") String leaveAt);
    
    // 라이브 대시보드 통계 저장
    void insertLiveDashboard(LiveStatisticsVO dashboard);
    
    // 현재 시청자 수 조회
    int selectCurrentViewerCount(@Param("liveId") String liveId);
    
    // 최대 동시 시청자 수 조회
    int selectMaxConcurrentViewers(@Param("liveId") String liveId);
    
    // 총 시청자 수 조회
    int selectTotalViewers(@Param("liveId") String liveId);
    
    // 평균 시청 시간 조회 (초 단위)
    int selectAverageWatchDuration(@Param("liveId") String liveId);

    // 라이브 통계 조회
    List<LiveStatisticsDTO> selectLiveStatisticsList(@Param("vendorId") String vendorId);

    // 총 매출액
    int selectTotalRevenue(@Param("liveId") String liveId);

    // 주문 건 수
    int selectTotalOrders(@Param("liveId") String liveId);

    // 구매 전환율
    double selectPurchaseRatio(@Param("liveId") String liveId);
} 