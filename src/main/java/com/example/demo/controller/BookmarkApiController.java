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
        if (auth == null) {
            throw new RuntimeException("로그인이 필요합니다."); // 토큰이 없으면 여기서 에러 발생
        }

        String name = auth.getName(); // JwtAuthenticationFilter에서 저장한 Subject(이름)
        Member member = memberRepository.findByName(name)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        return bookmarkService.toggleBookmark(boardId, member.getLoginId());
    }
}
