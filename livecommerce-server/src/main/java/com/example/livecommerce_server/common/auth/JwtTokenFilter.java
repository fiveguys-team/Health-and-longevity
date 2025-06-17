package com.example.livecommerce_server.common.auth;

import com.example.livecommerce_server.common.config.CustomUserDetails;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Component
public class JwtTokenFilter extends OncePerRequestFilter {
    @Value("${jwt.secret}")
    private String secretKey;

//    @Override
//    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException {
//        HttpServletRequest httpServletRequest = (HttpServletRequest) servletRequest;
//        HttpServletResponse httpServletResponse = (HttpServletResponse) servletResponse;
//        String token = httpServletRequest.getHeader("Authorization");
//
//        try {
//            if (token != null) {
//                if (!token.substring(0, 7).equals("Bearer ")) {
//                    throw new AuthenticationServiceException("Bearer 형식이 아닙니다.");
//                }
//                String jwtToken = token.substring(7);
//                // token 검증 및 claims(payload) 추출
//                Claims claims = Jwts.parserBuilder()
//                        .setSigningKey(secretKey)
//                        .build()
//                        .parseClaimsJws(jwtToken)
//                        .getBody();
//
//                // Authentication 객체 생성
//                List<GrantedAuthority> authorities = new ArrayList<>();
//                authorities.add(new SimpleGrantedAuthority("ROLE_" + claims.get("role")));
//                CustomUserDetails customUserDetails = new CustomUserDetails(
//                        claims.getSubject(),
//                        (String) claims.get("name"),
//                        (String) claims.get("email"),
//                        (String) claims.get("role"),
//                        authorities
//                );
//                Authentication authentication = new UsernamePasswordAuthenticationToken(customUserDetails, jwtToken, customUserDetails.getAuthorities());
//                SecurityContextHolder.getContext().setAuthentication(authentication);
//            }
//
//            filterChain.doFilter(servletRequest, servletResponse);
//        } catch (Exception e) {
//            e.printStackTrace();
//            httpServletResponse.setStatus(HttpStatus.UNAUTHORIZED.value());
//            httpServletResponse.setContentType("application/json");
//            httpServletResponse.getWriter().write("invalid token");
//        }
//    }

    @Override
    protected void doFilterInternal(HttpServletRequest servletRequest, HttpServletResponse servletResponse, FilterChain filterChain) throws ServletException, IOException {
        HttpServletRequest httpRequest = (HttpServletRequest) servletRequest;
        HttpServletResponse httpResponse = (HttpServletResponse) servletResponse;

        String token = null;

        if (httpRequest.getCookies() != null) {
            for (var cookie : httpRequest.getCookies()) {
                if ("token".equals(cookie.getName())) {
                    token = cookie.getValue();
                    break;
                }
            }
        }

        try {
            if (token != null) {
                // token 검증 및 claims(payload) 추출
                Claims claims = Jwts.parserBuilder()
                        .setSigningKey(secretKey)
                        .build()
                        .parseClaimsJws(token)
                        .getBody();

                // Authentication 객체 생성
                List<GrantedAuthority> authorities = new ArrayList<>();
                authorities.add(new SimpleGrantedAuthority("ROLE_" + claims.get("role")));

                CustomUserDetails customUserDetails = new CustomUserDetails(
                        claims.getSubject(),
                        (String) claims.get("name"),
                        (String) claims.get("email"),
                        (String) claims.get("role"),
                        authorities
                );

                Authentication authentication = new UsernamePasswordAuthenticationToken(
                        customUserDetails,
                        null,
                        customUserDetails.getAuthorities()
                );

                SecurityContextHolder.getContext().setAuthentication(authentication);
            }

            filterChain.doFilter(servletRequest, servletResponse);

        } catch (Exception e) {
            e.printStackTrace();
            httpResponse.setStatus(HttpStatus.UNAUTHORIZED.value());
            httpResponse.setContentType("application/json");
            httpResponse.getWriter().write("invalid token");
        }
    }
}
