package com.example.demo.service;

import com.example.demo.domain.Member;
import com.example.demo.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MemberService {
    private final MemberRepository memberRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public Member login(String loginId, String rawPassword) {
        Member m = memberRepository.findByLoginId(loginId)
                .orElseThrow(() -> new RuntimeException("아이디 없음"));
        // 암호화된 비밀번호와 입력받은 비밀번호 비교
        if (!passwordEncoder.matches(rawPassword, m.getPassword())) {
            throw new RuntimeException("비밀번호 오류");
        }
        return m;
    }
}
