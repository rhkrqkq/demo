package com.example.demo.controller;

import com.example.demo.dto.BoardRequestDTO;
import com.example.demo.dto.BoardResponseDTO;
import com.example.demo.service.BoardService;
import com.example.demo.domain.Member;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/board")
@RequiredArgsConstructor
public class BoardApiController {

    private final BoardService boardService;

    @PostMapping
    public Long create(@RequestBody BoardRequestDTO requestDTO) {
        return boardService.savePost(requestDTO);
    }

    @GetMapping
    public List<BoardResponseDTO> list() {
        return boardService.findAllPost();
    }

    @PatchMapping("/{id}")
    public Long update(@PathVariable Long id, @RequestBody BoardRequestDTO requestDTO, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Member loginMember = (Member) session.getAttribute("loginMember");

        BoardResponseDTO existBoard = boardService.findPostById(id);

        if (!existBoard.getWriter().equals(loginMember.getName())) {
            throw new RuntimeException("수정 권한이 없습니다.");
        }
        return boardService.update(id, requestDTO);
    }

    @DeleteMapping("/{id}")
    public Long delete(@PathVariable Long id) {
        return boardService.delete(id);
    }
}
