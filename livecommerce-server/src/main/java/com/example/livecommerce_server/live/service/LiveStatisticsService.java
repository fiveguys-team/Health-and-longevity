package com.example.livecommerce_server.live.service;

import com.example.livecommerce_server.live.dto.LiveStatisticsDTO;
import com.example.livecommerce_server.live.dto.LiveViewerStatsDTO;
import com.example.livecommerce_server.live.vo.LiveStatisticsVO;
import java.util.List;

public interface LiveStatisticsService {

    /**
     * 시청자 입장 처리
     * @param liveId 라이브 ID
     * @param userId 유저 ID
     */
    void addViewerJoin(String liveId, String userId);

    /**
     * 시청자 퇴장 처리
     * @param liveId 라이브 ID
     * @param userId 유저 ID
     */
    void saveViewerLeave(String liveId, String userId);

    /**
     * 라이브 종료 시 통계 데이터 계산 및 저장
     * @param liveId 라이브 아이디
     * @return 통계 VO
     */
    LiveStatisticsVO calculateAndSaveStatistics(String liveId);

    /**
     *  현재 시청자 수 조회
     * @param liveId 라이브 ID
     * @return 현재 시청자 수
     */
    int selectCurrentViewerCount(String liveId);

    /**
     * 입점업체의 라이브 방송 통계 데이터 반환
     * @param vendorId 입점업체 ID
     * @return 통계 리스트
     */
    List<LiveStatisticsDTO> findLiveStatisticsList(String vendorId);
} 