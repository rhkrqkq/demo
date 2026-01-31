package com.example.demo.service;

import com.example.demo.domain.Board;
import com.example.demo.domain.Comment;
import com.example.demo.dto.CommentRequestDTO;
import com.example.demo.dto.CommentResponseDTO;
import com.example.demo.repository.BoardRepository;
import com.example.demo.repository.CommentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CommentService {
    private final CommentRepository commentRepository;
    private final BoardRepository boardRepository;

    @Transactional
    public Long saveComment(CommentRequestDTO dto, String writer) {
        Board board = boardRepository.findById(dto.getBoardId())
                .orElseThrow(() -> new RuntimeException("게시글을 찾을 수 없습니다."));

        Comment comment = Comment.builder()
                .board(board)
                .content(dto.getContent())
                .writer(writer)
                .build();
        System.out.println("전달된 게시글 ID: " + dto.getBoardId());

        return commentRepository.save(comment).getId();
    }

    @Transactional(readOnly = true)
    public List<CommentResponseDTO> findAllByBoard(Long boardId) {
        return commentRepository.findByBoardIdOrderByCreatedAtDesc(boardId).stream()
                .map(CommentResponseDTO::new)
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteComment(Long commentId, String loginName) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(()-> new RuntimeException("해당 댓글이 없습니다"));

        if (!comment.getWriter().equals(loginName)) {
            throw new RuntimeException("본인 댓글만 삭제할 수 있습니다.");
        }
        commentRepository.delete(comment);
    }

    @Transactional(readOnly = true)
    public CommentResponseDTO findByCommentId(Long commentId) {
        Comment entity = commentRepository.findById(commentId)
                .orElseThrow(() -> new IllegalArgumentException("해당 댓글이 없습니다."));
        return new CommentResponseDTO(entity);
    }

    @Transactional
    public void updateComment (Long commentId, CommentRequestDTO commentRequestDTO, String loginName) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(()-> new IllegalArgumentException("해당 댓글이 없습니다."));

        if (!comment.getWriter().equals(loginName)) {
            throw new RuntimeException("본인 댓글만 수정할 수 있습니다.");
        }
        comment.update(commentRequestDTO.getContent());
    }

    @Transactional(readOnly = true)
    public List<CommentResponseDTO> findMyComments(String writer) {
        List<Comment> comments = commentRepository.findByWriterOrderByCreatedAtDesc(writer);

        return commentRepository.findByWriterOrderByCreatedAtDesc(writer).stream()
                .map(CommentResponseDTO::new)
                .collect(Collectors.toList());
    }
}
