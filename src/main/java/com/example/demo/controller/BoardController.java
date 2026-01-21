package com.example.demo.controller;

import com.example.demo.domain.Member;
import com.example.demo.dto.BoardResponseDTO;
import com.example.demo.dto.CommentResponseDTO;
import com.example.demo.service.BoardService;
import com.example.demo.service.BookmarkService;
import com.example.demo.service.CommentService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/board")
public class BoardController {

    private final BoardService boardService;
    private final CommentService commentService;
    private final BookmarkService bookmarkService;

    @GetMapping("/list")
    public String list(Model model, @RequestParam(value = "page", defaultValue = "0") int page,
                       @RequestParam(value = "keyword", required = false) String keyword,
                       @RequestParam(value = "category", required = false) String category) {
        Pageable pageable = PageRequest.of(page, 10, Sort.by("id").descending());
        Page<BoardResponseDTO> boards = boardService.findAllPost(keyword, category, pageable);

        model.addAttribute("boards", boards);
        model.addAttribute("keyword", keyword);
        model.addAttribute("category", category);

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
    public String view(@PathVariable Long id, HttpSession httpSession, Model model) {
        BoardResponseDTO board = boardService.findPostById(id);
        List<CommentResponseDTO> comments = commentService.findAllByBoard(id);

        model.addAttribute("board", board);
        model.addAttribute("comments", comments);

        Member loginMember = (Member) httpSession.getAttribute("loginMember");
        if (loginMember != null) {
            model.addAttribute("isBookmarked", bookmarkService.isBookmarked(id, loginMember.getLoginId()));
        }
        return "board/view";
    }

}
