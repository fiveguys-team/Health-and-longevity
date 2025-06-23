package com.example.livecommerce_server.vendor.service;

import com.example.livecommerce_server.member.domain.Role;
import com.example.livecommerce_server.member.repository.MemberRepository;
import com.example.livecommerce_server.vendor.common.Status;
import com.example.livecommerce_server.vendor.dto.VendorInfoDto;
import com.example.livecommerce_server.vendor.dto.VendorUpdateDto;
import com.example.livecommerce_server.vendor.mapper.AdminVendorManagementMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminVendorManagementServiceImpl implements AdminVendorManagementService {
    private final AdminVendorManagementMapper adminVendorManagementMapper;
    private final MemberRepository memberRepository;

    @Override
    public List<VendorInfoDto> readAllVendor() {
        return adminVendorManagementMapper.readAllVendor();
    }

    @Override
    public List<VendorInfoDto> readVendorByStatus(String status) {
        return adminVendorManagementMapper.readVendorByStatus(status);
    }

    @Override
    public void updateInfo(VendorUpdateDto vendorUpdateDto) {
        if (vendorUpdateDto.status == Status.APPROVED) {
            memberRepository.updateUserRole(vendorUpdateDto.getUserId(), Role.VENDOR);
        }
        adminVendorManagementMapper.updateInfo(vendorUpdateDto);
    }
}
