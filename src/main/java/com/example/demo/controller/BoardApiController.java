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
import org.springframework.http.ResponseEntity; // [필수 추가] ResponseEntity를 위해 추가
import org.springframework.web.bind.annotation.*;

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

    // 게시글 수정 로직 보완
    @PutMapping("/{id}")
    public ResponseEntity<Long> update(@PathVariable Long id,
                                       @RequestBody BoardRequestDTO requestDTO,
                                       HttpSession session) {
        // 1. 세션에서 로그인 정보 가져오기
        Member loginMember = (Member) session.getAttribute("loginMember");

        if (loginMember == null) {
            // 이 메시지는 GlobalExceptionHandler를 통해 JSON으로 반환됩니다.
            throw new RuntimeException("로그인이 필요합니다.");
        }

        // 2. 서비스 호출 시 사용자 이름(name)을 함께 전달하여 본인 확인 수행
        Long updatedId = boardService.update(id, requestDTO, loginMember.getName());
        return ResponseEntity.ok(updatedId);
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

    // 댓글 수정 로직에 권한 확인 추가
    @PatchMapping("/comments/{commentId}")
    public void updateComment(@PathVariable Long commentId,
                              @RequestBody CommentRequestDTO commentRequestDTO,
                              HttpSession session) {
        Member loginMember = (Member) session.getAttribute("loginMember");
        CommentResponseDTO comment = commentService.findByCommentId(commentId);

        if (loginMember == null || !comment.getWriter().equals(loginMember.getName())) {
            throw new RuntimeException("본인 댓글만 수정할 수 있습니다.");
        }

        commentService.updateComment(commentId, commentRequestDTO);
    }
}