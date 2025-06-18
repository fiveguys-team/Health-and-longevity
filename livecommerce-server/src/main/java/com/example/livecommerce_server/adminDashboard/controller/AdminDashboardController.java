package com.example.livecommerce_server.adminDashboard.controller;

import com.example.livecommerce_server.adminDashboard.dto.AnnualRevenueDTO;
import com.example.livecommerce_server.adminDashboard.dto.MonthOrdersDTO;
import com.example.livecommerce_server.adminDashboard.service.AdminDashboardService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@CrossOrigin(origins = {"http://localhost:5174", "http://localhost:5173",
		"http://localhost:3000"}, allowedHeaders = "*", methods = {RequestMethod.GET,
		RequestMethod.POST, RequestMethod.PUT, RequestMethod.DELETE, RequestMethod.OPTIONS})

@Slf4j
@RestController
@RequiredArgsConstructor
public class AdminDashboardController {

	private final AdminDashboardService adminDashboardService;

	/**
	 * 관리자 대시보드의 이번달 주문 건 수와 지난달 대비 상승율을 반환합니다.
	 *
	 * @return MonthOrdersDTO
	 */
	@GetMapping("/api/admin/monthOrders")
	public ResponseEntity<MonthOrdersDTO> getMonthOrdersDetail() {
		MonthOrdersDTO monthOrders = adminDashboardService.findMonthOrders();
		return new ResponseEntity<>(monthOrders, HttpStatus.OK);
	}

	@GetMapping("/api/admin/vendors/count")
	public ResponseEntity<?> getVendorCount() {
		int vendorCount = adminDashboardService.findVendorCount();
		return new ResponseEntity<>(vendorCount, HttpStatus.OK);
	}

	@GetMapping("/api/admin/revenues/annual")
	public ResponseEntity<AnnualRevenueDTO> getAnnualRevenue() {
		log.info("매출액 호출");
		AnnualRevenueDTO annualRevenue = adminDashboardService.findAnnualRevenue();
		return new ResponseEntity<>(annualRevenue, HttpStatus.OK);
	}
}
