package com.example.demo.config;

import io.jsonwebtoken.ExpiredJwtException;
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
    private final long accessTokenTime;
    private final long refreshTokenTime;

    public JwtProvider(@Value("${jwt.secret}") String secretString,
                       @Value("${jwt.expiration}") long accessTokenTime) {
        this.key = Keys.hmacShaKeyFor(secretString.getBytes(StandardCharsets.UTF_8));
        this.accessTokenTime = accessTokenTime;
        this.refreshTokenTime = accessTokenTime * 2 * 24 * 7;
    }

    // 사용자 이름 기반 JWT 토큰 생성
    private String createToken(String name, long validateTime) {
        Date now = new Date();
        Date validity = new Date(now.getTime() + validateTime);

        return Jwts.builder()
                .subject(name)
                .issuedAt(now)
                .expiration(validity)
                .signWith(key)
                .compact();
    }

    // Access Token 생성
    public String createAccessToken(String name) {
        return createToken(name, accessTokenTime);
    }

    // Refresh Token 생성
    public String createRefreshToken(String name) {
        return createToken(name, refreshTokenTime);
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

    // Refresh Token 만료 시간 반환 (Redis 저장용)
    public long getRefreshTokenTime() {
        return refreshTokenTime;
    }


    // 만료된 토큰에서 정보 추출
    public String getNameFromExpiredToken(String token) {
        try {
            return Jwts.parser().verifyWith(key).build().parseSignedClaims(token).getPayload().getSubject();
        } catch (ExpiredJwtException e) {
            return e.getClaims().getSubject();
        }
    }
}
