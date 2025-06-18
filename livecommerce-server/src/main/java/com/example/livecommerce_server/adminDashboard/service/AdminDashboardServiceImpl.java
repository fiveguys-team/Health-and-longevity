package com.example.livecommerce_server.adminDashboard.service;

import com.example.livecommerce_server.adminDashboard.dto.MonthOrdersDTO;
import com.example.livecommerce_server.adminDashboard.mapper.AdminDashboardMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class AdminDashboardServiceImpl implements AdminDashboardService {

	private final AdminDashboardMapper adminDashboardMapper;
	@Override
	public MonthOrdersDTO findMonthOrders() {
		int monthOrders = adminDashboardMapper.selectMonthOrders();
		int previousMonthOrders = adminDashboardMapper.selectPreviousMonthOrders();
		log.info(String.valueOf(monthOrders));
		log.info(String.valueOf(previousMonthOrders));

		int orderRate = 0;
		if(previousMonthOrders!=0) {
			orderRate = (monthOrders - previousMonthOrders) / previousMonthOrders * 100;
		}

		return MonthOrdersDTO.builder()
				.orderCount(monthOrders)
				.orderCountChangeRate(orderRate)
				.build();
	}

	@Override
	public int findVendorCount() {
		return adminDashboardMapper.selectVendorCount();
	}


}
