package com.example.livecommerce_server.member.service;

import com.example.livecommerce_server.common.config.CustomUserDetails;
import com.example.livecommerce_server.member.domain.Member;
import com.example.livecommerce_server.member.domain.Role;
import com.example.livecommerce_server.member.dto.MemberCreateDto;
import com.example.livecommerce_server.member.dto.MemberLoginDto;
import com.example.livecommerce_server.member.dto.VendorRegistrationDto;
import com.example.livecommerce_server.member.repository.MemberRepository;
import jakarta.transaction.Transactional;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@Transactional
public class MemberService {
    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;

    public MemberService(MemberRepository memberRepository, PasswordEncoder passwordEncoder) {
        this.memberRepository = memberRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public Member create(MemberCreateDto memberCreateDto) {
        String rawPassword = memberCreateDto.getPassword();
        String encodedPassword = passwordEncoder.encode(rawPassword);
        System.out.println("[DEBUG] 입력된 비밀번호(평문): " + rawPassword);
        System.out.println("[DEBUG] 암호화된 비밀번호: " + encodedPassword);

        Member member = Member.builder()
                .email(memberCreateDto.getEmail())
                .name(memberCreateDto.getName())
                .password(encodedPassword)
                .build();
        memberRepository.create(member);
        return member;
    }

    public Member login(MemberLoginDto memberLoginDto) {
        Optional<Member> optMember = memberRepository.findByEmail(memberLoginDto.getEmail());
        if (!optMember.isPresent()) {
            throw new IllegalArgumentException("email이 존재하지 않습니다.");
        }

        Member member = optMember.get();
        String inputPassword = memberLoginDto.getPassword();
        String savedEncodedPassword = member.getPassword();
        if (!passwordEncoder.matches(inputPassword, savedEncodedPassword)) {
            System.out.println("[DEBUG] 입력된 비밀번호(평문): " + inputPassword);
            System.out.println("[DEBUG] 저장된 비밀번호(암호화): " + savedEncodedPassword);
            System.out.println("[DEBUG] matches 결과: false");
            throw new IllegalArgumentException("password가 일치하지 않습니다.");
        } else {
            return member;
        }
    }

    public void createVendor(VendorRegistrationDto vendorRegistrationDto) {
        memberRepository.createVendor(vendorRegistrationDto);
    }

    public Optional<String> getVendorStatus(String userId) {
        return memberRepository.findVendorStatusByUserId(userId);
    }
}
