package com.example.demo.domain;

import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor
public class Comment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String content;

    private String writer;

    private LocalDateTime createdAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "board_id")
    private Board board;

    @Builder
    public Comment (String content, String writer, Board board) {
        this.content = content;
        this.writer = writer;
        this.board = board;
        this.createdAt = LocalDateTime.now();
    }

    public void update (String content) {
        this.content = content;
    }
}
