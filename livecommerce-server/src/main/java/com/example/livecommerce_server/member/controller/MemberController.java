package com.example.livecommerce_server.member.controller;

import com.example.livecommerce_server.common.auth.JwtTokenProvider;
import com.example.livecommerce_server.member.domain.Member;
import com.example.livecommerce_server.member.dto.*;
import com.example.livecommerce_server.member.service.MemberService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/member")
public class MemberController {
    private final MemberService memberService;
    private final JwtTokenProvider jwtTokenProvider;

    public MemberController(MemberService memberService, JwtTokenProvider jwtTokenProvider) {
        this.memberService = memberService;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @PostMapping("/create")
    public ResponseEntity<?> memberCreate(@RequestBody MemberCreateDto memberCreateDto) {
        Member member = memberService.create(memberCreateDto);
        return new ResponseEntity<>(member.getUserId(), HttpStatus.CREATED);
    }

    @PostMapping("/doLogin")
    public ResponseEntity<?> doLogin(@RequestBody MemberLoginDto memberLoginDto, HttpServletResponse response) {
        // email, password 일치한지 검증
        Member member = memberService.login(memberLoginDto);

        // 일치할 경우 jwt accesstoken 생성
        String jwtToken = jwtTokenProvider.createToken(member.getEmail(), member.getRole().toString(), member.getName(), member.getUserId().toString());

        Cookie tokenCookie = new Cookie("token", jwtToken);
//        tokenCookie.setHttpOnly(false);
        tokenCookie.setPath("/");
        tokenCookie.setMaxAge(60 * 60); // 1시간

        // 쿠키로 역할 저장 (선택 사항)
        Cookie roleCookie = new Cookie("role", member.getRole().name());
//        roleCookie.setHttpOnly(true);
        roleCookie.setPath("/");
        roleCookie.setMaxAge(60 * 60);

        Cookie nameCookie = new Cookie("name", member.getName());
//        nameCookie.setHttpOnly(true);
        nameCookie.setPath("/");
        nameCookie.setMaxAge(60 * 60);

        Cookie idCookie = new Cookie("id", member.getUserId().toString());
//        idCookie.setHttpOnly(true);
        idCookie.setPath("/");
        idCookie.setMaxAge(60 * 60);

        // 응답에 쿠키 추가
        response.addCookie(tokenCookie);
        response.addCookie(roleCookie);
        response.addCookie(nameCookie);
        response.addCookie(idCookie);

        return ResponseEntity.ok(Map.of("success", true));
    }
}
