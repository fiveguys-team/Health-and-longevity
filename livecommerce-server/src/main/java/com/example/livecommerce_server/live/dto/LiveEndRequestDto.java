package com.example.livecommerce_server.live.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LiveEndRequestDto {
	private String sessionId;
	private String endTime;
}
