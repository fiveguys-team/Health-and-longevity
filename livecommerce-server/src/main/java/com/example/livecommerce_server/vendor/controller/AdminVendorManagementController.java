package com.example.livecommerce_server.vendor.controller;

import com.example.livecommerce_server.vendor.dto.VendorUpdateDto;
import com.example.livecommerce_server.vendor.service.AdminVendorManagementService;
import com.example.livecommerce_server.vendor.service.AdminVendorManagementServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminVendorManagementController {

    private final AdminVendorManagementService adminVendorManagementService;
    private final AdminVendorManagementServiceImpl adminVendorManagementServiceImpl;

    @GetMapping("/vendor-all")
    public ResponseEntity<?> getAllVendors() {
        return ResponseEntity.ok(adminVendorManagementService.readAllVendor());
    }

    @PostMapping("/vendor-update")
    public ResponseEntity<?> updateVendorInfo(@RequestBody VendorUpdateDto vendorUpdateDto) {
        adminVendorManagementServiceImpl.updateInfo(vendorUpdateDto);
        return ResponseEntity.ok().build();
    }
}
