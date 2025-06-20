package com.example.livecommerce_server.adminDashboard.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AnnualRevenueDTO {
	private Integer totalRevenue;
	private Integer revenueChangeRate;
}
