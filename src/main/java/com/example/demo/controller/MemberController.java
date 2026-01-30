package com.example.demo.controller;

import com.example.demo.domain.Bookmark;
import com.example.demo.repository.BookmarkRepository;
import com.example.demo.service.BookmarkService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class MemberController {
    private final BookmarkService bookmarkService;

    @GetMapping("/board/login")
    public String loginPage() {
        return "login"; // views/login.jsp 호출
    }

    @GetMapping("/board/mypage")
    public String myPage(Authentication auth, Model model) {
        if (auth == null) return "redirect:/board/login";

        // 1. 토큰에서 추출한 사용자 ID(auth.getName())로 북마크 조회
        // 만약 auth.getName()이 실명이면 repository의 메서드명을 그에 맞게 수정해야 합니다.
        List<Bookmark> bookmarks = bookmarkService.findMyBookmarks(auth.getName());

        // 2. 모델에 담기
        model.addAttribute("bookmarks", bookmarks);
        model.addAttribute("loginMemberName", auth.getName());

        // 3. views/mypage.jsp 호출
        return "mypage";
    }
}