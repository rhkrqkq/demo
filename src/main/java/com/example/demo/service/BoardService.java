package com.example.demo.service;

import com.example.demo.domain.Board;
import com.example.demo.domain.Comment;
import com.example.demo.dto.BoardRequestDTO;
import com.example.demo.dto.BoardResponseDTO;
import com.example.demo.dto.CommentResponseDTO;
import com.example.demo.repository.BoardRepository;
import com.example.demo.repository.CommentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class BoardService {

    private final BoardRepository boardRepository;
    private final CommentRepository commentRepository;

    @Transactional
    public Long savePost(BoardRequestDTO requestDTO) {
        return boardRepository.save(requestDTO.toEntity()).getId();
    }

    public Page<BoardResponseDTO> findAllPost(String keyword, String category, Pageable pageable) {
        Page<Board> boardPage;

        // ALL이거나 비어있을땐 전체 검색으로 생각
        boolean hasCategory = (category != null && !category.isEmpty() && category.equals("ALL"));
        // 검색어 존재 여부 확인
        boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());

        if (hasCategory && hasKeyword) {
            boardPage = boardRepository.findByCategoryAndTitleContaining(category, keyword, pageable);
        } else if (hasCategory) {
            boardPage = boardRepository.findByCategory(category, pageable);
        } else if (hasKeyword) {
            boardPage = boardRepository.findByTitleContaining(keyword, pageable);
        } else {
            boardPage = boardRepository.findAll(pageable);
        }
        return boardPage.map(BoardResponseDTO::new);
    }

    @Transactional
    public Long update(Long id, BoardRequestDTO requestDTO, String loginName) {
        // 수정할 엔티티 조회
        Board board = boardRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 게시글이 없습니다"));

        // 작성자 검증 로직을 서비스 레이어에 배치
        if (!board.getWriter().equals(loginName)) {
            throw new RuntimeException("작성자만 수정할 수 있습니다.");
        }

        board.update(requestDTO.getTitle(), requestDTO.getContent());
        return id;
    }

    @Transactional
    public Long delete(Long id) {
        Board board = boardRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 게시글이 없습니다."));

        boardRepository.delete(board);
        return id;
    }

    @Transactional
    public BoardResponseDTO findPostById(Long id) {
        Board entity = boardRepository.findById(id)
                .orElseThrow(()-> new IllegalArgumentException("해당 게시글이 없습니다."));

        // 상세보기 시 조회수 증가
        entity.increaseHits();
        return new BoardResponseDTO(entity);
    }

    @Transactional(readOnly = true)
    public Page<BoardResponseDTO> findAllPost(String keyword, Pageable pageable) {
        Page<Board> page;
        if (keyword == null || keyword.trim().isEmpty()) {
            page = boardRepository.findAll(pageable);
        } else {
            page = boardRepository.findByTitleContaining(keyword, pageable);
        }
        return page.map(BoardResponseDTO::new);
    }

    public List<BoardResponseDTO> findMyPosts(String writer) {
        return boardRepository.findByWriterOrderByIdDesc(writer).stream()
                .map(BoardResponseDTO::new)
                .collect(Collectors.toList());
    }

    public List<CommentResponseDTO> findMyComments(String writer) {
        return commentRepository.findByWriterOrderByCreatedAtDesc(writer).stream()
                .map(CommentResponseDTO::new)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public Page<BoardResponseDTO> getPostsByCategory(String category, Pageable pageable) {
        // 카테고리 값이 있으면 검색
        if (category == null || category.isEmpty() || category.equals("ALL")) {
            return boardRepository.findAll(pageable).map(BoardResponseDTO::new);
        }
        return boardRepository.findByCategory(category, pageable).map(BoardResponseDTO::new);
    }
}
