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
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/board")
@RequiredArgsConstructor
public class BoardApiController {

    private final BoardService boardService;
    private final CommentService commentService;

    @PostMapping
    public Long create(@RequestBody BoardRequestDTO requestDTO, Authentication authentication) {
        if (authentication == null) throw new RuntimeException("로그인이 필요합니다.");

        // [핵심] 로그인한 사람의 이름을 작성자로 강제 설정
        requestDTO.setWriter(authentication.getName());

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
    @PatchMapping("/{id}")
    public ResponseEntity<Long> update(@PathVariable Long id,
                                       @RequestBody BoardRequestDTO requestDTO,
                                       Authentication authentication) {
        if (authentication == null) throw new RuntimeException("로그인이 필요합니다.");
        Long updatedId = boardService.update(id, requestDTO, authentication.getName());
        return ResponseEntity.ok(updatedId);
    }

    @DeleteMapping("/{id}")
    public Long delete(@PathVariable Long id, org.springframework.security.core.Authentication authentication) {
        if (authentication == null) throw new RuntimeException("로그인이 필요합니다.");
        return boardService.delete(id, authentication.getName());
    }

    @PostMapping("/comments")
    public ResponseEntity<Long> saveComment(@RequestBody CommentRequestDTO requestDTO, Authentication authentication) {
        if (authentication == null) return ResponseEntity.status(401).build();

        // 1. 작성자 이름 추출 (abc 등)
        String writer = authentication.getName();

        // 2. [수정] 서비스 정의에 맞게 (DTO, String) 순서로 호출
        // 기존에 에러가 났던 requestDTO.getBoardId() 인자를 제거합니다.
        Long commentId = commentService.saveComment(requestDTO, writer);

        return ResponseEntity.ok(commentId);
    }

    @DeleteMapping("/comments/{commentId}")
    public void deleteComment(@PathVariable Long commentId, org.springframework.security.core.Authentication authentication) {
        if (authentication == null) throw new RuntimeException("로그인이 필요합니다.");

        String loginName = authentication.getName();
        CommentResponseDTO comment = commentService.findByCommentId(commentId);

        if (!comment.getWriter().equals(loginName)) {
            throw new RuntimeException("본인 댓글만 삭제할 수 있습니다.");
        }

        commentService.deleteComment(commentId, loginName);
    }

    // 댓글 수정 로직에 권한 확인 추가
    @PatchMapping("/comments/{commentId}")
    public void updateComment(@PathVariable Long commentId,
                              @RequestBody CommentRequestDTO commentRequestDTO,
                              org.springframework.security.core.Authentication authentication) {
        if (authentication == null) throw new RuntimeException("로그인이 필요합니다.");

        String loginName = authentication.getName();
        CommentResponseDTO comment = commentService.findByCommentId(commentId);

        if (!comment.getWriter().equals(loginName)) {
            throw new RuntimeException("본인 댓글만 수정할 수 있습니다.");
        }

        commentService.updateComment(commentId, commentRequestDTO, loginName);
    }
}