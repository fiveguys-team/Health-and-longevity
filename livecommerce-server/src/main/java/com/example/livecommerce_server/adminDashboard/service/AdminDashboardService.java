package com.example.livecommerce_server.adminDashboard.service;

import com.example.livecommerce_server.adminDashboard.dto.AnnualRevenueDTO;
import com.example.livecommerce_server.adminDashboard.dto.CategoryRevenueDTO;
import com.example.livecommerce_server.adminDashboard.dto.MonthOrdersDTO;
import com.example.livecommerce_server.adminDashboard.dto.MonthlyRevenueDTO;
import com.example.livecommerce_server.adminDashboard.dto.VendorMaxViewersDTO;

import java.util.List;

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

	/**
	 * 카테고리별 매출
	 * @return List<CategoryRevenueDTO>
	 */
	List<CategoryRevenueDTO> findCategoryRevenue();

	/**
	 * 이번달 입점업체별 라이브 방송 최고 시청자 수
	 * @return List<VendorMaxViewersDTO>
	 */
	List<VendorMaxViewersDTO> findVendorMaxViewers();

}
