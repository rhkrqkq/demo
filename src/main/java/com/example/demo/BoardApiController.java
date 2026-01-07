package com.example.demo;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/board")
@RequiredArgsConstructor
public class BoardApiController {

    private final BoardService boardService;

    @PostMapping
    public Long create(@RequestBody BoardRequestDTO requestDTO) {
        return boardService.savePost(requestDTO);
    }

    @GetMapping
    public List<BoardResponseDTO> list() {
        return boardService.findAllPost();
    }

    @PatchMapping("/{id}")
    public Long update(@PathVariable Long id, @RequestBody BoardRequestDTO requestDTO) {
        return boardService.update(id, requestDTO);
    }

    @DeleteMapping("/{id}")
    public Long delete(@PathVariable Long id) {
        return boardService.delete(id);
    }
}
