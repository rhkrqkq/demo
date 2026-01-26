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
@Transactional(readOnly = true)  // 성능 최적화 위해 기본적으로 읽기 전용 (readOnly=true)
@RequiredArgsConstructor  // final이 붙은 필드를 생성자 주입 방식으로 가져옴
public class BoardService {

    private final BoardRepository boardRepository;
    private final CommentRepository commentRepository;

    @Transactional
    public Long savePost(BoardRequestDTO requestDTO) {
        return boardRepository.save(requestDTO.toEntity()).getId();
    }

    // 게시글 통합 조회
    public Page<BoardResponseDTO> findAllPost(String keyword, String category, Pageable pageable) {
        Page<Board> boardPage;

        // 카테고리가 비어있지 않거나 ALL이 아닐때만 특정 카테고리로 검색
        boolean hasCategory = (category != null && !category.isEmpty() && !category.equals("ALL"));
        // 검색어가 비어있지 않거나 공백을 제외한 문자열이 없을때 키워드로 검색
        boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());

        // 카테고리로 검색하면서, 키워드로 검색
        if (hasCategory && hasKeyword) {
            // 특정 주제 내에서 검색어 필터링
            boardPage = boardRepository.findByCategoryAndTitleContaining(category, keyword, pageable);
        } else if (hasCategory) {
            // 특정 주제만 필터링
            boardPage = boardRepository.findByCategory(category, pageable);
        } else if (hasKeyword) {
            // 전체 카테고리에서 검색어 필터링
            boardPage = boardRepository.findByTitleContaining(keyword, pageable);
        } else {
            // 아무 조건이 없거나 카테고리가 "ALL"인 경우 전체 조회
            boardPage = boardRepository.findAll(pageable);
        }

        // Entity를 DTO로 변환
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
