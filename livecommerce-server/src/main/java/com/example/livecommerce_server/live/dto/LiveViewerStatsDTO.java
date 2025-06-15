package com.example.livecommerce_server.live.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * 라이브 시청자 입장, 퇴장 정보 저장 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LiveViewerStatsDTO {
    private Integer viewerLogId;
    private String liveId;
    private String userId;
    private String joinAt;
    private String leaveAt;
    private Boolean isAnonymous;
} 