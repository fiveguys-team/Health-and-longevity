package com.example.livecommerce_server.member.repository;

import com.example.livecommerce_server.member.domain.Member;
import com.example.livecommerce_server.member.domain.Role;
import com.example.livecommerce_server.member.dto.VendorRegistrationDto;
import com.example.livecommerce_server.vendor.dto.VendorInfoDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Optional;

@Mapper
public interface MemberRepository {
    void create(Member member);
    Optional<Member> findByEmail(@Param("email") String email);
    Optional<Member> findById(@Param("userId") String userId);
    void update(Member member);
    void createVendor(VendorRegistrationDto vendorRegistrationDto);
    void updateUserRole(@Param("userId") String userId, @Param("role") Role role);
    Optional<String> findVendorStatusByUserId(@Param("userId") String userId);
    VendorInfoDto findVendorInfoByUserId(@Param("userId") String userId);
}