package com.example.livecommerce_server.member.service;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
public class RefreshTokenService {
    private final StringRedisTemplate redisTemplate;
    private final static String REFRESH_TOKEN_PREFIX = "refresh_token:";
    private final static long REFRESH_TOKEN_TTL = 7;

    public RefreshTokenService(@Qualifier("refreshTokenRedisTemplate") StringRedisTemplate redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    public void saveRefreshToken(String userId, String refreshToken) {
        String key = REFRESH_TOKEN_PREFIX + userId;
        redisTemplate.opsForValue().set(key, refreshToken, REFRESH_TOKEN_TTL, TimeUnit.DAYS);
    }

    public String getRefreshToken(String userId) {
        String key = REFRESH_TOKEN_PREFIX + userId;
        return redisTemplate.opsForValue().get(key);
    }

    public void deleteRefreshToken(String userId) {
        String key = REFRESH_TOKEN_PREFIX + userId;
        redisTemplate.delete(key);
    }

    public boolean validateRefreshToken(String userId, String refreshToken) {
        String savedToken = getRefreshToken(userId);
        return savedToken != null && savedToken.equals(refreshToken);
    }
}