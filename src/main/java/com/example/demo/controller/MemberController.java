package com.example.demo.controller;

import com.example.demo.domain.Member;
import com.example.demo.repository.MemberRepository;
import com.example.demo.dto.MemberRequestDTO;
import com.example.demo.service.BoardService;
import com.example.demo.service.BookmarkService;
import com.example.demo.service.MemberService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping
public class MemberController {
    @Autowired
    private final MemberService memberService;
    private final MemberRepository memberRepository;
    private final BCryptPasswordEncoder passwordEncoder;
    private final BoardService boardService;
    private final BookmarkService bookmarkService;

    // 회원가입 페이지 이동
    @GetMapping("/signup")
    public String signupForm() {
        return "signup";
    }

    // 회원가입 처리
    @PostMapping("/signup")
    public String signup(@ModelAttribute MemberRequestDTO memberRequestDTO) {
        // 엔티티를 DTO로 변환
        Member member = memberRequestDTO.toEntity();

        // 비밀번호 암호화
        String encodedPassword = passwordEncoder.encode(member.getPassword());

        // 암호화된 비밀번호를 엔티티에 세팅
        member.encodePassword(encodedPassword);

        // 저장
        memberRepository.save(member);
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String loginForm() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String loginId, @RequestParam String password, HttpServletRequest request) {
        Member loginMember = memberService.login(loginId, password);

        if (loginMember == null) {
            return "login";
        }

        HttpSession session = request.getSession();
        session.setAttribute("loginMember", loginMember);

        return "redirect:/board/list";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/board/list";
    }

    @GetMapping("/mypage")
    public String myPage (HttpSession httpSession, Model model) {
        Member loginMember = (Member) httpSession.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/login";
        }

        String writer = loginMember.getName();
        model.addAttribute("myPosts", boardService.findMyPosts(writer));
        model.addAttribute("myComments", boardService.findMyComments(writer));
        model.addAttribute("myBookmarks", bookmarkService.findMyBookmarks(loginMember.getLoginId()));

        return "mypage";
    }

}