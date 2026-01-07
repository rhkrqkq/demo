package com.example.demo;

import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
public class BoardRequestDTO {

    private String title;
    private String content;
    private String writer;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Board toEntity() {
        return Board.builder()
                .title(this.title)
                .content(this.content)
                .writer(this.writer)
                .build();
    }
}
