package com.example.demo.dto;

import com.example.demo.domain.Comment;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class CommentResponseDTO {
    private Long id;
    private String content;
    private String writer;
    private LocalDateTime createdAt;

    public CommentResponseDTO(Comment entity) {
        this.id = entity.getId();
        this.content = entity.getContent();
        this.writer = entity.getWriter();
        this.createdAt = entity.getCreatedAt();
    }
}
