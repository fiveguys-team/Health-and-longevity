package com.example.livecommerce_server.adminDashboard.mapper;

import com.example.livecommerce_server.adminDashboard.dto.MonthOrdersDTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AdminDashboardMapper {

//	이번달 주문수
	int selectMonthOrders();

//	저번달 주문수
	int selectPreviousMonthOrders();

//	입점업체 수
	int selectVendorCount();

	// 금년 누적 매출
	int selectTotalRevenue();

	// 작년 누적 매출
	int selectPreviousRevenue();
}
