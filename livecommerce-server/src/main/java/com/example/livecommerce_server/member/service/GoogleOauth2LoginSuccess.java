package com.example.livecommerce_server.member.service;

import com.example.livecommerce_server.common.auth.JwtTokenProvider;
import com.example.livecommerce_server.member.domain.Member;
import com.example.livecommerce_server.member.domain.Role;
import com.example.livecommerce_server.member.domain.SocialType;
import com.example.livecommerce_server.member.repository.MemberRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public class GoogleOauth2LoginSuccess extends SimpleUrlAuthenticationSuccessHandler {
    private final MemberRepository memberRepository;
    private final JwtTokenProvider jwtTokenProvider;

    public GoogleOauth2LoginSuccess(MemberRepository memberRepository, JwtTokenProvider jwtTokenProvider) {
        this.memberRepository = memberRepository;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        // oauth 프로필 추출
        OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
        String openId = oAuth2User.getAttribute("sub");
        String email = oAuth2User.getAttribute("email");
        String name = oAuth2User.getAttribute("name");
        // 회원가입 여부 확인
        Member member = memberRepository.findByEmail(email).orElse(null);
        if (member == null) {
            member = Member.builder()
                    .socialId(openId)
                    .email(email)
                    .name(name)
                    .socialType(SocialType.GOOGLE)
                    .role(Role.USER)
                    .build();
            memberRepository.create(member);
            member = memberRepository.findByEmail(email).orElse(null);
        } else {
            member.setSocialId(openId);
            member.setName(name);
            member.setSocialType(SocialType.GOOGLE);
            memberRepository.update(member);
            member = memberRepository.findByEmail(email).orElse(null);
        }
        // jwt 토큰 생성
        String jwtToken = jwtTokenProvider.createToken(member.getEmail(), member.getRole().toString(),  member.getUserId().toString(), member.getName());
        Cookie jwtCookie = new Cookie("token", jwtToken);
        jwtCookie.setHttpOnly(true);
//        jwtCookie.setSecure(true);
        jwtCookie.setPath("/"); // 모든 경로에서 쿠키 사용가능
        jwtCookie.setMaxAge(60 * 60);
        response.addCookie(jwtCookie);

        // 클라이언트 redirect 방식으로 token 전달
        response.sendRedirect("http://localhost:3000/oauth-success");
    }
}
