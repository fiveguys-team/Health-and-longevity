package com.example.livecommerce_server.service.controller;

import com.example.livecommerce_server.service.dto.ServiceRequestDTO;
import com.example.livecommerce_server.service.service.ServiceService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/service")
@RequiredArgsConstructor
public class ServiceController {

    private final ServiceService serviceService;

    /**
     * 교환/환불 요청 등록
     * @param requestDTO 사용자 요청 정보 (orderItemId, userId, serviceCode, reason, img)
     * @return 성공 메시지
     */
    @PostMapping("/request")
    public ResponseEntity<String> serviceRequestAdd(@RequestBody ServiceRequestDTO requestDTO) {
        serviceService.addServiceRequest(requestDTO);
        return ResponseEntity.ok("요청이 정상적으로 등록되었습니다.");
    }

    /**
     * 교환/환불 요청 승인 또는 반려 처리 API
     * @param orderItemId 주문 상세 항목 ID
     * @param statusCode  변경할 상태 코드 ('COMP' = 승인, 'RJCT' = 반려)
     */
    @PutMapping("/status")
    public void updateServiceStatus(@RequestParam("orderItemId") String orderItemId,
                                    @RequestParam("statusCode") String statusCode) {
        serviceService.updateServiceStatus(orderItemId, statusCode);
    }
}