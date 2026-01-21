package com.example.demo.dto;

import com.example.demo.domain.Board;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@NoArgsConstructor
public class BoardResponseDTO {
    private Long id;
    private String title;
    private String content;
    private String writer;
    private int hits;
    private String category;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private int commentCount;
    private List<CommentResponseDTO> comments;

    public BoardResponseDTO(Board entity) {
        this.id = entity.getId();
        this.title = entity.getTitle();
        this.content = entity.getContent();
        this.writer = entity.getWriter();
        this.hits = entity.getHits();
        this.category = entity.getCategory();
        this.createdAt = entity.getCreatedAt();
        this.updatedAt = entity.getUpdatedAt();

        if (entity.getComments() != null) {
            this.comments = entity.getComments().stream()
                    .map(CommentResponseDTO::new)
                    .collect(Collectors.toList());
            this.commentCount = entity.getComments().size();
        }
    }

}
