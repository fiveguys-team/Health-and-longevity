package com.example.livecommerce_server.member.controller;

import com.example.livecommerce_server.common.auth.JwtTokenProvider;
import com.example.livecommerce_server.member.domain.Member;
import com.example.livecommerce_server.member.dto.*;
import com.example.livecommerce_server.member.service.MemberService;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

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
        tokenCookie.setHttpOnly(true);
//        tokenCookie.setSecure(true);
        tokenCookie.setPath("/");
        tokenCookie.setMaxAge(60 * 60);

        response.addCookie(tokenCookie);

        return ResponseEntity.ok(Map.of("success", true));
    }

    @GetMapping("/info")
    public ResponseEntity<?> getMe(HttpServletRequest request) {
        String token = Arrays.stream(Optional.ofNullable(request.getCookies()).orElse(new Cookie[0]))
                .filter(c -> c.getName().equals("token"))
                .map(Cookie::getValue)
                .findFirst()
                .orElseThrow(() -> new RuntimeException("토큰이 존재하지 않습니다."));

        Claims claims = jwtTokenProvider.parseToken(token);

        // Map.of(...)는 value가 null이면 NPE를 발생시킨다.
        // HashMap을 사용해 null‑safe 하게 응답 바디를 구성한다.
        java.util.Map<String, Object> body = new HashMap<>();
        body.put("email", claims.get("email"));
        body.put("name", claims.get("name"));
        body.put("role", claims.get("role"));
        body.put("id", claims.getSubject());

        return ResponseEntity.ok(body);
    }
}

