package com.example.livecommerce_server.member.repository;

import com.example.livecommerce_server.member.domain.Member;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Optional;

@Mapper
public interface MemberRepository {
    void create(Member member);
    Optional<Member> findByEmail(@Param("email") String email);
    Optional<Member> findBySocialId(@Param("socialId") String socialId);
    void update(Member member);
}
