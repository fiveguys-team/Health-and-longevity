package com.example.livecommerce_server.adminDashboard.service;

import com.example.livecommerce_server.adminDashboard.dto.AnnualRevenueDTO;
import com.example.livecommerce_server.adminDashboard.dto.MonthOrdersDTO;
import com.example.livecommerce_server.adminDashboard.dto.MonthlyRevenueDTO;

public interface AdminDashboardService {

	/**
	 * 주문수 DTO
	 * @return MonthOrdersDTO
	 */
	MonthOrdersDTO findMonthOrders();

	/**
	 * 입점업체수 반환
	 * @return VendorCount
	 */
	int findVendorCount();

	/**
	 * 연간 누적 매출
	 * @return AnnualRevenueDTO
	 */
	AnnualRevenueDTO findAnnualRevenue();

	/**
	 * 이번 달 매출
	 * @return
	 */
	MonthlyRevenueDTO findMonthRevenue();

}
