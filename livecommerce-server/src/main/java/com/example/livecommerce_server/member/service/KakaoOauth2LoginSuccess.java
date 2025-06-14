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
import java.util.Map;

@Service
public class KakaoOauth2LoginSuccess extends SimpleUrlAuthenticationSuccessHandler {
    private final MemberRepository memberRepository;
    private final JwtTokenProvider jwtTokenProvider;

    public KakaoOauth2LoginSuccess(MemberRepository memberRepository, JwtTokenProvider jwtTokenProvider) {
        this.memberRepository = memberRepository;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        // oauth 프로필 추출
        OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
        System.out.println("profile JSON " + oAuth2User.getAttributes());
        String openId = oAuth2User.getAttribute("id").toString();
        Map<String, Object> kakaoAccount = oAuth2User.getAttribute("kakao_account");
        String email = kakaoAccount != null ? (String) kakaoAccount.get("email") : null;
        // 회원가입 여부 확인
//        Member member = memberRepository.findBySocialId(openId).orElse(null);
        Member member = memberRepository.findByEmail(email).orElse(null);
        if (member == null) {
            member = Member.builder()
                    .socialId(openId)
                    .email(email)
                    .socialType(SocialType.KAKAO)
                    .role(Role.USER)
                    .build();
            memberRepository.create(member);
        } else {
            member.setSocialId(openId);
            member.setSocialType(SocialType.KAKAO);
            memberRepository.update(member);
        }
        // jwt 토큰 생성
        String jwtToken = jwtTokenProvider.createToken(member.getEmail(), member.getRole().toString(),  member.getUserId().toString(), member.getName());
        // 클라이언트 redirect 방식으로 token 전달
//        response.sendRedirect("http://localhost:3000?token=" + jwtToken);
        Cookie jwtCookie = new Cookie("token", jwtToken);
        jwtCookie.setPath("/"); // 모든 경로에서 쿠키 사용가능
        response.addCookie(jwtCookie);

        Cookie roleCookie = new Cookie("role", member.getRole().toString());
        roleCookie.setPath("/");
        response.addCookie(roleCookie);

        Cookie nameCookie = new Cookie("name", member.getName());
        nameCookie.setPath("/");
        response.addCookie(nameCookie);

        Cookie idCookie = new Cookie("id", member.getUserId().toString());
        idCookie.setPath("/");
        response.addCookie(idCookie);

        response.sendRedirect("http://localhost:3000");
    }
}
