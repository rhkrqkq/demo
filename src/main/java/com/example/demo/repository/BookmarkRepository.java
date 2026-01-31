package com.example.demo.repository;

import com.example.demo.domain.Board;
import com.example.demo.domain.Bookmark;
import com.example.demo.domain.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BookmarkRepository extends JpaRepository<Bookmark, Long> {
    List<Bookmark> findAllByMember_LoginId(String loginId);

    // 토글 시 필요한 메서드
    Optional<Bookmark> findByMemberAndBoard(Member member, Board board);
}
