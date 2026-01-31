package com.example.demo.service;

import com.example.demo.config.JwtProvider;
import com.example.demo.domain.Member;
import com.example.demo.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MemberService {
    private final MemberRepository memberRepository;
    private final BCryptPasswordEncoder passwordEncoder;
    private final JwtProvider jwtProvider;

    public String login(String loginId, String rawPassword) {
        Member m = memberRepository.findByLoginId(loginId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        if (!passwordEncoder.matches(rawPassword, m.getPassword())) {
            throw new RuntimeException("비밀번호가 일치하지 않습니다.");
        }

        // Member 객체가 아닌, 생성된 '토큰 문자열'을 리턴해야 합니다.
        return jwtProvider.createToken(m.getLoginId());
    }

    @Transactional
    public String findPassword(String loginId) {
        // 1. 아이디 존재 여부 확인
        Member member = memberRepository.findByLoginId(loginId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));

        // 2. 임시 비밀번호 생성 (8자리 랜덤)
        String tempPassword = UUID.randomUUID().toString().substring(0, 8);

        // 3. 비밀번호 암호화 후 DB 업데이트
        member.setPassword(passwordEncoder.encode(tempPassword));

        return tempPassword; // 실제 서비스라면 이메일 전송
    }
}
