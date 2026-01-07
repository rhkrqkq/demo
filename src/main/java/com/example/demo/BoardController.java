package com.example.demo;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/board")
public class BoardController {

    private final BoardService boardService;

    @GetMapping("/list")
    public String list(Model model) {
        List<BoardResponseDTO> boards = boardService.findAllPost();
        model.addAttribute("boards", boards);

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
