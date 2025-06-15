package com.example.livecommerce_server.live.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LiveStatisticsDTO {
	private String liveDashboardId;
	private String liveId;
	private String title;
	private String StreamDate;
	private int totalViewers;
	private int maxConcurrentViewers;
	private int averageWatchDuration;
	private int totalChats;
	private int totalOrders;
	private long totalReve;
}
