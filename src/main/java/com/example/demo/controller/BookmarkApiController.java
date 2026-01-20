package com.example.demo.controller;

import com.example.demo.domain.Member;
import com.example.demo.service.BookmarkService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/bookmark")
@RequiredArgsConstructor
public class BookmarkApiController {
    private final BookmarkService bookmarkService;

    @PostMapping("/{boardId}")
    public boolean toggleBookmark(@PathVariable Long boardId, HttpSession httpSession) {
        Member loginMember = (Member) httpSession.getAttribute("loginMember");
        if (loginMember == null) {
            throw new RuntimeException("로그인이 필요합니다.");
        }
        return bookmarkService.toggleBookmark(boardId, loginMember.getLoginId());
    }
}
