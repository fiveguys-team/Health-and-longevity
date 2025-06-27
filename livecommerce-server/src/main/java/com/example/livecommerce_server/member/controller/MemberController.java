package com.example.livecommerce_server.member.controller;

import com.example.livecommerce_server.common.auth.JwtTokenProvider;
import com.example.livecommerce_server.member.domain.Member;
import com.example.livecommerce_server.member.dto.*;
import com.example.livecommerce_server.member.service.MemberService;
import com.example.livecommerce_server.member.service.RefreshTokenService;
import com.example.livecommerce_server.vendor.dto.VendorInfoDto;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/member")
@RequiredArgsConstructor
public class MemberController {
    private final MemberService memberService;
    private final JwtTokenProvider jwtTokenProvider;
    private final RefreshTokenService refreshTokenService;

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

        // Refresh Token 생성 및 Redis에 저장
        String refreshToken = jwtTokenProvider.createRefreshToken(member.getUserId().toString());
        refreshTokenService.saveRefreshToken(member.getUserId().toString(), refreshToken);

        Cookie tokenCookie = new Cookie("token", jwtToken);
        tokenCookie.setHttpOnly(true);
//        tokenCookie.setSecure(true);
        tokenCookie.setPath("/");
        tokenCookie.setMaxAge(60 * 60);

        // Refresh token 쿠키
        Cookie refreshTokenCookie = new Cookie("refresh_token", refreshToken);
        refreshTokenCookie.setHttpOnly(true);
        refreshTokenCookie.setPath("/");
        refreshTokenCookie.setMaxAge(60 * 60 * 24 * 7);

        response.addCookie(tokenCookie);
        response.addCookie(refreshTokenCookie);

        return ResponseEntity.ok(Map.of("success", true));
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout(HttpServletRequest request, HttpServletResponse response) {
        Cookie tokenCookie = new Cookie("token", null);
        tokenCookie.setPath("/");
        tokenCookie.setHttpOnly(true);
        tokenCookie.setMaxAge(0); // 즉시 만료

        // Refresh token 쿠키도 만료 처리
        Cookie refreshTokenCookie = new Cookie("refresh_token", null);
        refreshTokenCookie.setPath("/");
        refreshTokenCookie.setHttpOnly(true);
        refreshTokenCookie.setMaxAge(0); // 즉시 만료

        // 다른 쿠키들도 필요하면 여기에 추가
        response.addCookie(tokenCookie);
        response.addCookie(refreshTokenCookie);

        // 현재 사용자 ID 가져오기
        String token = getTokenFromCookie(request, "token");
        if (token != null) {
            try {
                String userId = jwtTokenProvider.getUserIdFromToken(token);
                // Redis에서 Refresh Token 삭제
                refreshTokenService.deleteRefreshToken(userId);
            } catch (Exception e) {
                // 토큰이 이미 만료되었거나 유효하지 않은 경우 처리
            }
        }

        return ResponseEntity.ok().body("로그아웃 완료");
    }

    @PostMapping("/token/refresh")
    public ResponseEntity<?> refreshToken(HttpServletRequest request, HttpServletResponse response) {
        // Refresh Token 쿠키에서 추출
        String refreshToken = getTokenFromCookie(request, "refresh_token");
        if (refreshToken == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                "success", false,
                "message", "리프레시 토큰이 없습니다."
            ));
        }

        try {
            // Refresh Token 검증
            if (!jwtTokenProvider.validateToken(refreshToken)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                    "success", false,
                    "message", "리프레시 토큰이 만료되었습니다."
                ));
            }

            // 사용자 ID 추출
            String userId = jwtTokenProvider.getUserIdFromToken(refreshToken);

            // Redis에 저장된 토큰과 비교
            if (!refreshTokenService.validateRefreshToken(userId, refreshToken)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                    "success", false,
                    "message", "유효하지 않은 리프레시 토큰입니다."
                ));
            }

            // 사용자 정보 조회
            Member member = memberService.findById(userId);

            // 새 Access Token 발급
            String newAccessToken = jwtTokenProvider.createToken(
                    member.getEmail(),
                    member.getRole().toString(),
                    member.getName(),
                    userId
            );

            // Access Token 쿠키 새로 설정
            Cookie accessTokenCookie = new Cookie("token", newAccessToken);
            accessTokenCookie.setHttpOnly(true);
            accessTokenCookie.setPath("/");
            accessTokenCookie.setMaxAge(60 * 60);
            response.addCookie(accessTokenCookie);

            // 응답에 새 토큰 정보 포함
            return ResponseEntity.ok(Map.of(
                "success", true,
                "tokenRefreshed", true
            ));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                "success", false,
                "message", "토큰 갱신에 실패했습니다: " + e.getMessage()
            ));
        }
    }

    // 쿠키에서 토큰 추출 유틸리티 메소드
    private String getTokenFromCookie(HttpServletRequest request, String cookieName) {
        return Arrays.stream(Optional.ofNullable(request.getCookies()).orElse(new Cookie[0]))
                .filter(c -> c.getName().equals(cookieName))
                .map(Cookie::getValue)
                .findFirst()
                .orElse(null);
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

    @PostMapping("/vendor-registration")
    public ResponseEntity<?> createVendor(@RequestBody VendorRegistrationDto vendorRegistrationDto) {
        System.out.println(vendorRegistrationDto.toString());
        memberService.createVendor(vendorRegistrationDto);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/vendor-status")
    public ResponseEntity<?> getVendorStatus(@RequestParam String userId) {
        Optional<String> status = memberService.getVendorStatus(userId);
        return ResponseEntity.ok(status.orElse(null));
    }

    @GetMapping("/vendor-info")
    public ResponseEntity<?> getVendorInfo(@RequestParam String userId) {
        try {
            VendorInfoDto vendorInfo = memberService.getVendorInfo(userId);
            return ResponseEntity.ok(vendorInfo);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("입점업체 정보 조회 실패: " + e.getMessage());
        }
    }
}