package com.example.livecommerce_server.common.auth;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.spec.SecretKeySpec;
import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
public class JwtTokenProvider {
    @Value("${jwt.secret}")
    private String secretKey;
    @Value("${jwt.expiration}")
    private int expiration;
    private Key SECRET_KEY;

    @PostConstruct
    public void init() {
        this.SECRET_KEY = new SecretKeySpec(
                java.util.Base64.getDecoder().decode(secretKey),
                SignatureAlgorithm.HS512.getJcaName()
        );
    }

    public String createToken(String email, String role, String name, String id) {
        Date now = new Date();
        Map<String, Object> claims = new HashMap<>();
        if (email != null) claims.put("email", email);
        if (role != null) claims.put("role", role);
        if (name != null) claims.put("name", name);
        return Jwts.builder()
                .setSubject(id)
                .addClaims(claims)
                .setIssuedAt(now)
                .setExpiration(new Date(now.getTime() + expiration * 60 * 1000L)) // 분 → 밀리초
                .signWith(SECRET_KEY, SignatureAlgorithm.HS512)
                .compact();
    }

    public Claims parseToken(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(SECRET_KEY)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
}
