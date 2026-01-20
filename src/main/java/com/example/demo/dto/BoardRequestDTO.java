package com.example.demo.dto;

import com.example.demo.domain.Board;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
public class BoardRequestDTO {

    @NotBlank(message = "제목은 필수 입력 값입니다.")
    @Size(max = 100, message = "제목은 100자 이내로 입력해주세요.")
    private String title;

    @NotBlank(message = "내용은 필수 입력 값입니다.")
    private String content;
    private String writer;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String category;

    public Board toEntity() {
        return Board.builder()
                .category(this.category)
                .title(this.title)
                .content(this.content)
                .writer(this.writer)
                .build();
    }
}
