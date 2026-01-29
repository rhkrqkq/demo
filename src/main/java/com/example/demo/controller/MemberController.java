package com.example.demo.controller;

import com.example.demo.config.JwtProvider;
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
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/board")
public class MemberController {

    private final MemberService memberService;
    private final MemberRepository memberRepository;
    private final BCryptPasswordEncoder passwordEncoder;
    private final BoardService boardService;
    private final BookmarkService bookmarkService;
    private final JwtProvider jwtProvider;

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
    @ResponseBody // 토큰 데이터를 반환하기 위해 필수
    public ResponseEntity<?> login(@RequestBody MemberRequestDTO loginDto) {
        Member loginMember = memberService.login(loginDto.getLoginId(), loginDto.getPassword());

        if (loginMember != null) {
            // 토큰 생성 (사용자 이름을 기반으로 생성)
            String token = jwtProvider.createToken(loginMember.getName());
            return ResponseEntity.ok(token); // 성공 시 200 OK와 함께 토큰 전송
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("아이디 또는 비밀번호가 틀렸습니다.");
    }

    @GetMapping("/logout")
    public String logout() {
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