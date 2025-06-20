package com.example.livecommerce_server.adminDashboard.service;

import com.example.livecommerce_server.adminDashboard.dto.AnnualRevenueDTO;
import com.example.livecommerce_server.adminDashboard.dto.CategoryRevenueDTO;
import com.example.livecommerce_server.adminDashboard.dto.MonthOrdersDTO;
import com.example.livecommerce_server.adminDashboard.dto.MonthlyRevenueDTO;
import com.example.livecommerce_server.adminDashboard.dto.VendorMaxViewersDTO;
import com.example.livecommerce_server.adminDashboard.mapper.AdminDashboardMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

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

	@Override
	public AnnualRevenueDTO findAnnualRevenue() {
		int yearRevenue = adminDashboardMapper.selectTotalRevenue();
		int previousRevenue = adminDashboardMapper.selectPreviousRevenue();
		log.info(String.valueOf(yearRevenue));
		log.info(String.valueOf(previousRevenue));

		int revenueRate = 0;
		if(previousRevenue!=0) {
			revenueRate = (yearRevenue - previousRevenue) / previousRevenue * 100;
		}
		return AnnualRevenueDTO.builder()
				.totalRevenue(yearRevenue)
				.revenueChangeRate(revenueRate)
				.build();
	}

	@Override
	public MonthlyRevenueDTO findMonthRevenue() {
		int monthRevenue = adminDashboardMapper.selectCurrentMonthRevenue();
		int previousRevenue = adminDashboardMapper.selectPreviousMonthRevenue();
		log.info(String.valueOf(monthRevenue));
		log.info(String.valueOf(previousRevenue));

		int revenueRate = 0;
		if(previousRevenue!=0) {
			revenueRate = (monthRevenue - previousRevenue) / previousRevenue * 100;
		}
		return MonthlyRevenueDTO.builder()
				.totalRevenue(monthRevenue)
				.revenueChangeRate(revenueRate)
				.build();
	}

	@Override
	public List<CategoryRevenueDTO> findCategoryRevenue() {
		return adminDashboardMapper.selectCategoryRevenue();
	}

	@Override
	public List<VendorMaxViewersDTO> findVendorMaxViewers() {
		return adminDashboardMapper.selectVendorMaxViewers();
	}

}
