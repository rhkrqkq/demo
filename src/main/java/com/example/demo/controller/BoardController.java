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
import org.springframework.security.core.Authentication;
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

    private void setLoginInfo(Model model, Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated()) {
            model.addAttribute("loginMemberName", authentication.getName());
        }
    }

    @GetMapping("/list")
    public String list(Model model,
                       Authentication authentication,
                       @RequestParam(value = "page", defaultValue = "0") int page,
                       @RequestParam(value = "keyword", required = false) String keyword,
                       @RequestParam(value = "category", required = false) String category) {
        setLoginInfo(model, authentication);

        // 페이징 설정 객체 (페이지 번호, 한 페이지 당 개수, 정렬 순서)
        Pageable pageable = PageRequest.of(page, 10, Sort.by("id").descending());

        // Service에 findAllPost 를 통해 데이터 요청
        Page<BoardResponseDTO> boards = boardService.findAllPost(keyword, category, pageable);

        // view로 데이터 전달
        model.addAttribute("boards", boards);
        model.addAttribute("keyword", keyword);
        model.addAttribute("category", category);

        // list.jsp 실행
        return "list";
    }

    @GetMapping("/write")
    public String write(@RequestParam(value = "id", required = false) Long id, Model model, Authentication authentication) {
        setLoginInfo(model, authentication);

        if (id != null) {
            BoardResponseDTO board = boardService.findPostById(id);
            model.addAttribute("board", board);
        } else {
            model.addAttribute("board", new BoardResponseDTO());
        }
        return "write";
    }

    @GetMapping("/view/{id}")
    public String view(@PathVariable Long id, Model model, Authentication auth) {
        if (auth != null) {
            model.addAttribute("loginMemberName", auth.getName());
            model.addAttribute("isBookmarked", bookmarkService.isBookmarked(id, auth.getName()));
        }

        BoardResponseDTO board = boardService.findPostById(id);
        List<CommentResponseDTO> comments = commentService.findAllByBoard(id); // 이 부분 필수

        model.addAttribute("board", board);
        model.addAttribute("comments", comments); // JSP의 items="${comments}"와 일치해야 함

        return "view";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model, Authentication authentication) {
        setLoginInfo(model, authentication); // 로그인 정보 주입

        BoardResponseDTO board = boardService.findPostById(id);
        model.addAttribute("board", board);

        return "edit";
    }

}
