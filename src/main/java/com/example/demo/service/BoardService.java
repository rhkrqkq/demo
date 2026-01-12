package com.example.demo.service;

import com.example.demo.domain.Board;
import com.example.demo.dto.BoardRequestDTO;
import com.example.demo.dto.BoardResponseDTO;
import com.example.demo.repository.BoardRepository;
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

    @Transactional
    public Long savePost(BoardRequestDTO requestDTO) {
        return boardRepository.save(requestDTO.toEntity()).getId();
    }

    public List<BoardResponseDTO> findAllPost() {
        return boardRepository.findAll().stream()
                .map(BoardResponseDTO::new)
                .collect(Collectors.toList());
    }

    @Transactional
    public Long update(Long id, BoardRequestDTO requestDTO) {
        Board board = boardRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 게시글이 없습니다"));

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

}
