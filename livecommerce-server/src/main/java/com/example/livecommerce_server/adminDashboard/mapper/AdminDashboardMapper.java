package com.example.livecommerce_server.adminDashboard.mapper;

import com.example.livecommerce_server.adminDashboard.dto.CategoryRevenueDTO;
import com.example.livecommerce_server.adminDashboard.dto.MonthOrdersDTO;
import com.example.livecommerce_server.adminDashboard.dto.VendorMaxViewersDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface AdminDashboardMapper {

	// 이번달 주문수
	int selectMonthOrders();

	// 저번달 주문수
	int selectPreviousMonthOrders();

	// 입점업체 수
	int selectVendorCount();

	// 금년 누적 매출
	int selectTotalRevenue();

	// 작년 누적 매출
	int selectPreviousRevenue();

	// 이번달 누적 매출
	int selectCurrentMonthRevenue();

	// 저번달 누적 매출
	int selectPreviousMonthRevenue();

	// 카테고리별 매출
	List<CategoryRevenueDTO> selectCategoryRevenue();

	// 이번달 입점업체별 라이브 방송 최고 시청자 수
	List<VendorMaxViewersDTO> selectVendorMaxViewers();

}
