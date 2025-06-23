package com.example.livecommerce_server.vendor.mapper;

import com.example.livecommerce_server.vendor.dto.VendorInfoDto;
import com.example.livecommerce_server.vendor.dto.VendorUpdateDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AdminVendorManagementMapper {
    List<VendorInfoDto> readAllVendor();
    List<VendorInfoDto> readVendorByStatus(@Param("status") String status);
    void updateInfo(VendorUpdateDto vendorUpdateDto);
}
