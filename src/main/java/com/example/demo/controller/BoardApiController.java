package com.example.demo.controller;

import com.example.demo.dto.BoardRequestDTO;
import com.example.demo.dto.BoardResponseDTO;
import com.example.demo.dto.CommentRequestDTO;
import com.example.demo.dto.CommentResponseDTO;
import com.example.demo.service.BoardService;
import com.example.demo.domain.Member;
import com.example.demo.service.CommentService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/board")
@RequiredArgsConstructor
public class BoardApiController {

    private final BoardService boardService;
    private final CommentService commentService;


    @PostMapping
    public Long create(@RequestBody BoardRequestDTO requestDTO) {
        return boardService.savePost(requestDTO);
    }

    @GetMapping
    public Page<BoardResponseDTO> list(
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "category", required = false) String category) {
        Pageable pageable = PageRequest.of(page, 10, Sort.by("id").descending());
        return boardService.findAllPost(keyword, category, pageable);
    }

    @PatchMapping("/{id}")
    public Long update(@PathVariable Long id, @RequestBody BoardRequestDTO requestDTO, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Member loginMember = (Member) session.getAttribute("loginMember");

        BoardResponseDTO existBoard = boardService.findPostById(id);

        if (!existBoard.getWriter().equals(loginMember.getName())) {
            throw new RuntimeException("수정 권한이 없습니다.");
        }

        // 서비스 단으로 로그인 정보와 함께 수정 요청
        return boardService.update(id, requestDTO, loginMember.getName());
    }

    @DeleteMapping("/{id}")
    public Long delete(@PathVariable Long id) {
        return boardService.delete(id);
    }

    @PostMapping("/{id}/comments")
    public Long saveComment(@PathVariable Long id, @RequestBody CommentRequestDTO requestDTO) {
        return commentService.saveComment(id, requestDTO);
    }

    @DeleteMapping("/comments/{commentId}")
    public void deleteComment(@PathVariable Long commentId, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Member loginMember = (Member) session.getAttribute("loginMember");

        CommentResponseDTO comment = commentService.findByCommentId(commentId);

        if (loginMember == null || !comment.getWriter().equals(loginMember.getName())) {
            throw new RuntimeException("본인 댓글만 삭제할 수 있습니다.");
        }

        commentService.deleteComment(commentId);
    }

    @PatchMapping("/comments/{commentId}")
    public void updateComment(@PathVariable Long commentId, @RequestBody CommentRequestDTO commentRequestDTO) {
        commentService.updateComment(commentId, commentRequestDTO);
    }
}
