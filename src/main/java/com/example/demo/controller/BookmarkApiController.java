package com.example.demo.controller;

import com.example.demo.domain.Member;
import com.example.demo.repository.MemberRepository;
import com.example.demo.service.BookmarkService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/bookmark")
@RequiredArgsConstructor
public class BookmarkApiController {
    private final BookmarkService bookmarkService;
    private final MemberRepository memberRepository;

    @PostMapping("/{boardId}")
    public boolean toggleBookmark(@PathVariable Long boardId, Authentication auth) {
        String loginId = auth.getName();

        // DB 조회 전후로 로그를 찍어 확실히 확인
        Member member = memberRepository.findByLoginId(loginId)
                .orElseThrow(() -> {
                    System.out.println("에러 발생: DB에 " + loginId + " 회원이 없습니다.");
                    return new RuntimeException("사용자 찾기 실패");
                });

        System.out.println("회원 찾기 성공: " + member.getName());
        return bookmarkService.toggleBookmark(boardId, member.getLoginId());
    }

}