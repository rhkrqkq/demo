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
    public Long saveComment(Long boardId, CommentRequestDTO dto) {
        Board board = boardRepository.findById(boardId)
                .orElseThrow(() -> new IllegalArgumentException("게시글이 없습니다."));

        Comment comment = Comment.builder()
                .content(dto.getContent())
                .writer(dto.getWriter())
                .board(board)
                .build();

        return commentRepository.save(comment).getId();
    }

    @Transactional(readOnly = true)
    public List<CommentResponseDTO> findAllByBoard(Long boardId) {
        return commentRepository.findByBoardIdOrderByCreatedAtDesc(boardId).stream()
                .map(CommentResponseDTO::new)
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteComment(Long commentId) {
        commentRepository.deleteById(commentId);
    }

    @Transactional(readOnly = true)
    public CommentResponseDTO findByCommentId(Long commentId) {
        Comment entity = commentRepository.findById(commentId)
                .orElseThrow(() -> new IllegalArgumentException("해당 댓글이 없습니다."));
        return new CommentResponseDTO(entity);
    }

    @Transactional
    public void updateComment (Long id, CommentRequestDTO commentRequestDTO) {
        Comment comment = commentRepository.findById(id)
                .orElseThrow(()-> new IllegalArgumentException("해당 댓글이 없습니다."));
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
