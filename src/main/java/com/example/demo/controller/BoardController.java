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
    public String list(Model model,
                       @RequestParam(value = "page", defaultValue = "0") int page,
                       @RequestParam(value = "keyword", required = false) String keyword,
                       @RequestParam(value = "category", required = false) String category) {
        // 페이징 설정 객체 (페이지 번호, 한 페이지 당 개수, 정렬 순서)
        Pageable pageable = PageRequest.of(page, 10, Sort.by("id").descending());

        // Service에 findAllPost 를 통해 데이터 요청
        Page<BoardResponseDTO> boards = boardService.findAllPost(keyword, category, pageable);

        // view로 데이터 전달
        model.addAttribute("boards", boards);
        model.addAttribute("keyword", keyword);
        model.addAttribute("category", category);

        // list.jsp 실행
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

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model) {
        // 1. 수정할 게시글 데이터를 조회합니다.
        BoardResponseDTO board = boardService.findPostById(id);

        // 2. 모델에 데이터를 담아 JSP로 전달합니다.
        model.addAttribute("board", board);

        // 3. board/edit.jsp 파일로 이동합니다.
        return "board/edit";
    }

}
