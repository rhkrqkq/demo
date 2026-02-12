package com.example.demo.controller;

import com.example.demo.dto.MemberRequestDTO;
import com.example.demo.dto.TokenDTO;
import com.example.demo.repository.MemberRepository;
import com.example.demo.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/member")
@RequiredArgsConstructor
public class MemberApiController {

    private final MemberService memberService;
    private final MemberRepository memberRepository;

    @PostMapping("/join")
    public ResponseEntity<String> join(@RequestBody MemberRequestDTO.MemberJoinRequestDTO memberJoinRequestDTO) {
        System.out.println("회원가입 요청 도달: " + memberJoinRequestDTO.getLoginId());
        try {
            memberService.join(memberJoinRequestDTO);
            return ResponseEntity.ok("회원가입이 완료되었습니다.");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/login")
    public ResponseEntity<TokenDTO> login(@RequestBody MemberRequestDTO loginDto) {
        TokenDTO tokenDTO = memberService.login(loginDto.getLoginId(), loginDto.getPassword());

        return ResponseEntity.ok(tokenDTO);
    }

    @GetMapping("/checkId")
    public ResponseEntity<Boolean> checkID(@RequestParam String loginId) {
        boolean isAvailable = memberRepository.findByLoginId(loginId).isEmpty();
        return ResponseEntity.ok(isAvailable);
    }
}