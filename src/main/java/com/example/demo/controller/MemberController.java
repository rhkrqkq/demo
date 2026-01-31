package com.example.demo.controller;

import com.example.demo.domain.Board;
import com.example.demo.domain.Bookmark;
import com.example.demo.dto.BoardResponseDTO;
import com.example.demo.repository.BookmarkRepository;
import com.example.demo.service.BoardService;
import com.example.demo.service.BookmarkService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class MemberController {
    private final BookmarkService bookmarkService;
    private final BoardService boardService;

    @GetMapping("/board/login")
    public String loginPage() {
        return "login"; // views/login.jsp 호출
    }

    @GetMapping("/board/signup")
    public String signup() {
        return "signup";
    }

    @GetMapping("/board/mypage")
    public String myPage(Authentication auth, Model model) {
        if (auth == null) return "redirect:/board/login";

        String loginId = auth.getName(); // "abc"

        // 데이터 조회
        List<Bookmark> bookmarks = bookmarkService.findMyBookmarks(loginId);
        List<Board> myBoards = boardService.findAllByWriter(loginId);

        model.addAttribute("bookmarks", bookmarks);
        model.addAttribute("myBoards", myBoards);
        model.addAttribute("loginMemberName", loginId);

        return "mypage";
    }
}