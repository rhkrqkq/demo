package com.example.demo.repository;

import com.example.demo.domain.Board;
import com.example.demo.domain.Bookmark;
import com.example.demo.domain.Member;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface BookmarkRepository extends JpaRepository<Bookmark, Long> {
    Optional<Bookmark> findByMemberAndBoard(Member member, Board board);

    List<Bookmark> findByMemberOrderByIdDesc(Optional<Member> member);
}
