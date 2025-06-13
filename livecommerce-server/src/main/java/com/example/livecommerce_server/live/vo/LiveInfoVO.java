package com.example.livecommerce_server.live.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LiveInfoVO {
	private String live_id;
	private String vendor_id;
	private String session_id;
	private String title;
	private String start_time;
	//private String end_time;
	//private String thumbnail;
	private String status;
	private String announcement;
	private String category;
}
