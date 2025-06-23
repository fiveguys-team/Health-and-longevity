package com.example.livecommerce_server.member.repository;

import com.example.livecommerce_server.member.domain.Member;
import com.example.livecommerce_server.member.domain.Role;
import com.example.livecommerce_server.member.dto.VendorRegistrationDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Optional;

@Mapper
public interface MemberRepository {
    void create(Member member);
    Optional<Member> findByEmail(@Param("email") String email);
    Optional<Member> findBySocialId(@Param("socialId") String socialId);
    void update(Member member);
    void createVendor(VendorRegistrationDto vendorRegistrationDto);
    void updateUserRole(@Param("userId") String userId, @Param("role") Role role);
    Optional<String> findVendorStatusByUserId(@Param("userId") String userId);
}