package com.example.livecommerce_server.vendor.service;

import com.example.livecommerce_server.vendor.dto.VendorInfoDto;
import com.example.livecommerce_server.vendor.dto.VendorUpdateDto;

import java.util.List;

public interface AdminVendorManagementService {
    List<VendorInfoDto> readAllVendor();
    List<VendorInfoDto> readVendorByStatus(String status);
    void updateInfo(VendorUpdateDto vendorUpdateDto);
}
