package com.example.livecommerce_server.common.config;

import com.example.livecommerce_server.common.auth.JwtTokenFilter;
import com.example.livecommerce_server.member.service.DelegatingOauth2LoginSuccessHandler;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
public class SecurityConfig {
    private final JwtTokenFilter jwtTokenFilter;
    private final DelegatingOauth2LoginSuccessHandler delegatingOauth2LoginSuccessHandler;

    public SecurityConfig(JwtTokenFilter jwtTokenFilter, DelegatingOauth2LoginSuccessHandler delegatingOauth2LoginSuccessHandler) {
        this.jwtTokenFilter = jwtTokenFilter;
        this.delegatingOauth2LoginSuccessHandler = delegatingOauth2LoginSuccessHandler;
    }

    @Bean
    public PasswordEncoder makePassword() {
        return PasswordEncoderFactories.createDelegatingPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain myFilter(HttpSecurity httpSecurity) throws Exception {
        return httpSecurity
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .csrf(AbstractHttpConfigurer::disable) // csrf 비활성화
                // Basic 인증 방식 비활성화
                // Basic 인증은 사용자 이름과 비밀번호를 Base64로 인코딩하여 인증값으로 활용하는 방식
                .httpBasic(AbstractHttpConfigurer::disable)
                // session 방식 비활성화
                .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                // 특정 url 패턴에 대해서는 인증처리(Authentication 객체 생성) 제외
                .authorizeHttpRequests(a ->
                        a
                                // 모든 경로를 인증 없이 열기
                                .requestMatchers("/test/ping").hasRole("ADMIN")
                                .anyRequest().permitAll()
                )
//                .authorizeHttpRequests(a -> {
//                    a
//                            .requestMatchers("/member/create", "/member/doLogin", "/oauth2/**", "/**/*").permitAll()
//                            .requestMatchers("/admin/**").hasRole("ADMIN")
//                            .requestMatchers("/vendor/**").hasRole("VENDOR")
//                            .anyRequest().authenticated();
//                })
                // UsernamePasswordAuthenticationFilter 이 클래스에서 폼 로그인 처리
                .addFilterBefore(jwtTokenFilter, UsernamePasswordAuthenticationFilter.class)
                // oauth 로그인이 성공했을 경우 실행할 클래스 정의
//                .oauth2Login(o -> o.successHandler(googleOauth2LoginSuccess))
                .oauth2Login(o -> o.successHandler(delegatingOauth2LoginSuccessHandler))
                .build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration corsConfiguration = new CorsConfiguration();
        corsConfiguration.setAllowedOrigins(Arrays.asList("http://localhost:3000"));
        corsConfiguration.setAllowedMethods(Arrays.asList("*")); // 모든 http 메서드 허용
        corsConfiguration.setAllowedHeaders(Arrays.asList("*")); // 모든 header 값 허용
        corsConfiguration.setAllowCredentials(true); // 자격증명허용

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        // 모든 url 패턴에 대해서 cors 허용 설정
        source.registerCorsConfiguration("/**", corsConfiguration);
        return source;
    }
}
