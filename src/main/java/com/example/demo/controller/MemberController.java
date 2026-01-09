package com.example.demo.controller;

import com.example.demo.domain.Member;
import com.example.demo.repository.MemberRepository;
import com.example.demo.dto.MemberRequestDTO;
import com.example.demo.service.MemberService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping
public class MemberController {
    @Autowired
    private final MemberService memberService;
    private final MemberRepository memberRepository;

    // 회원가입 페이지 이동
    @GetMapping("/signup")
    public String signupForm() {
        return "signup";
    }

    // 회원가입 처리
    @PostMapping("/signup")
    public String signup(@ModelAttribute MemberRequestDTO memberRequestDTO) {
        memberRepository.save(memberRequestDTO.toEntity());
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
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/board/list";
    }
}