package com.example.demo.config;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Component
public class JwtProvider {
    private final SecretKey key;
    private final long validateTime;

    public JwtProvider(@Value("${jwt.secret}") String secretString,
                       @Value("${jwt.expiration}") long validateTime) {
        this.key = Keys.hmacShaKeyFor(secretString.getBytes(StandardCharsets.UTF_8));
        this.validateTime = validateTime;
    }

    // 사용자 이름 기반 JWT 토큰 생성
    public String createToken(String name) {
        Date now = new Date();
        Date validity = new Date(now.getTime() + validateTime);

        return Jwts.builder()
                .subject(name)
                .issuedAt(now)
                .expiration(validity)
                .signWith(key)
                .compact();
    }

    // 토큰에서 사용자 이름 추출
    public String getName(String token) {
        return Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload()
                .getSubject();
    }

    // 토큰의 유효성 검사
    public boolean validateToken(String token) {
        try {
            Jwts.parser()
                    .verifyWith(key)
                    .build()
                    .parseSignedClaims(token);
                    return true;
        } catch (Exception e) {
            // 만료 혹은 서명 불일치
            return false;
        }
    }
}
