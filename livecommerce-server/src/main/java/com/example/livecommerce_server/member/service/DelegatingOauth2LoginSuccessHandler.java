package com.example.livecommerce_server.member.service;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public class DelegatingOauth2LoginSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {
    private final GoogleOauth2LoginSuccess googleHandler;
    private final KakaoOauth2LoginSuccess kakaoHandler;

    public DelegatingOauth2LoginSuccessHandler(GoogleOauth2LoginSuccess googleHandler, KakaoOauth2LoginSuccess kakaoHandler) {
        this.googleHandler = googleHandler;
        this.kakaoHandler = kakaoHandler;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        String registrationId = ((OAuth2AuthenticationToken) authentication).getAuthorizedClientRegistrationId();

        if ("google".equals(registrationId)) {
            googleHandler.onAuthenticationSuccess(request, response, authentication);
        } else if ("kakao".equals(registrationId)) {
            kakaoHandler.onAuthenticationSuccess(request, response, authentication);
        } else {
            super.onAuthenticationSuccess(request, response, authentication);
        }
    }
}
