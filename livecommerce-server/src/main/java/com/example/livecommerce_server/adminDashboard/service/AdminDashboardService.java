package com.example.livecommerce_server.adminDashboard.service;

import com.example.livecommerce_server.adminDashboard.dto.AnnualRevenueDTO;
import com.example.livecommerce_server.adminDashboard.dto.MonthOrdersDTO;

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

	AnnualRevenueDTO findAnnualRevenue();

}
