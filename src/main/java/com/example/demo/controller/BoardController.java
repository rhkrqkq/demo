package com.example.demo.controller;

import com.example.demo.dto.BoardResponseDTO;
import com.example.demo.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/board")
public class BoardController {

    private final BoardService boardService;

    @GetMapping("/list")
    public String list(Model model, @RequestParam(value = "page", defaultValue = "0") int page,
                       @RequestParam(value = "keyword", required = false) String keyword) {
        Pageable pageable = PageRequest.of(page, 10, Sort.by("id").descending());
        Page<BoardResponseDTO> boards = boardService.findAllPost(keyword, pageable);

        model.addAttribute("boards", boards);
        model.addAttribute("keyword", keyword);
        return "board/list";
    }

    @GetMapping("/write")
    public String write(@RequestParam(value = "id", required = false) Long id, Model model) {
        if (id != null) {
            BoardResponseDTO board = boardService.findPostById(id);
            model.addAttribute("board", board);
        } else {
            model.addAttribute("board", new BoardResponseDTO());
        }
        return "board/write";
    }

    @GetMapping("/view/{id}")
    public String view(@PathVariable Long id, Model model) {
        BoardResponseDTO board = boardService.findPostById(id);
        model.addAttribute("board", board);

        return "board/view";
    }

}
