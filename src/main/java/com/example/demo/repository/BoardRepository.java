package com.example.demo.repository;

import com.example.demo.domain.Board;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BoardRepository extends JpaRepository<Board, Long> {

    // 키워드 포함하는 제목 검색
    Page<Board> findByTitleContaining(String keyword, Pageable pageable);

    // 사용자 별로 게시글 최신순 조회
    List<Board> findByWriterOrderByIdDesc(String writer);

    // 카테고리 별 검색
    Page<Board> findByCategory(String category, Pageable pageable);

    // 카테고리 내 제목 검색
    Page<Board> findByCategoryAndTitleContaining(String category, String keyword, Pageable pageable);

    List<Board> findAllByWriter(String writer);
}
