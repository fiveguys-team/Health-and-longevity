package com.example.livecommerce_server.live.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LiveProductVO {
	private Integer live_product_id;
	private String live_id;
	private String product_id;
	private Integer discountRate;
}
