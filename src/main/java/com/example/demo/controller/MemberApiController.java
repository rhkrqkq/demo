package com.example.demo.controller;

import com.example.demo.dto.MemberRequestDTO;
import com.example.demo.service.MemberService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/member")
@RequiredArgsConstructor
public class MemberApiController {

    private final MemberService memberService;

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody MemberRequestDTO loginDto) {
        // 이제 서비스는 String 타입의 토큰을 반환합니다.
        String token = memberService.login(loginDto.getLoginId(), loginDto.getPassword());

        // 토큰 문자열을 응답 바디에 담아 반환합니다.
        return ResponseEntity.ok(token);
    }
}