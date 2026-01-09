package com.example.demo.service;

import com.example.demo.domain.Member;
import com.example.demo.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MemberService {
    private final MemberRepository memberRepository;

    public Member login(String loginId, String password) {
        Optional<Member> member = memberRepository.findByLoginId(loginId);
        if (member.isEmpty()) {
            throw new RuntimeException("존재하지 않는 아이디");
        }

        Member m = member.get();
        if (!m.getPassword().equals(password)) {
            throw new RuntimeException("비밀번호 오류");
        }
        return m;
    }
}
