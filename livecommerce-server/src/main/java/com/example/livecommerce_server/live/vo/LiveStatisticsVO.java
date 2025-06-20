package com.example.livecommerce_server.live.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class LiveStatisticsVO {
    private String liveDashboardId;
    private String liveId;
    private int totalViewers;
    private int maxConcurrentViewers;
    private int averageWatchDuration;
    private int purchaseRatio;
    private int totalOrders;
    private long totalReve;
} 