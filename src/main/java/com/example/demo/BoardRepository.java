package com.example.demo;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BoardRepository extends JpaRepository<Board, Long> {

    // 제목에 키워드 포함된 글 페이징해서 가져오기
    Page<Board> findByTitleContaining(String keyword, Pageable pageable);
}
