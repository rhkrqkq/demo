package com.example.demo.service;

import com.example.demo.domain.Board;
import com.example.demo.domain.Bookmark;
import com.example.demo.domain.Member;
import com.example.demo.repository.BoardRepository;
import com.example.demo.repository.BookmarkRepository;
import com.example.demo.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BookmarkService {
    private final BookmarkRepository bookmarkRepository;
    private final BoardRepository boardRepository;
    private final MemberRepository memberRepository;

    @Transactional
    public boolean toggleBookmark(Long boardId, String loginId) {
        Member member = memberRepository.findByLoginId(loginId)
                .orElseThrow(() -> new RuntimeException("사용자 없음"));
        Board board = boardRepository.findById(boardId)
                .orElseThrow(() -> new RuntimeException("게시물 없음"));

        // 기존 북마크 확인
        Optional<Bookmark> existing = bookmarkRepository.findByMemberAndBoard(member, board);

        if (existing.isPresent()) {
            bookmarkRepository.delete(existing.get());
            return false;
        } else {
            Bookmark bookmark = Bookmark.builder()
                    .member(member) // 이 member 객체가 DB의 PK(숫자)와 연결됩니다.
                    .board(board)
                    .build();
            bookmarkRepository.save(bookmark);
            return true;
        }
    }

    @Transactional(readOnly = true)
    public List<Bookmark> findMyBookmarks(String loginId) {
        return bookmarkRepository.findAllByMember_LoginId(loginId);
    }

    @Transactional(readOnly = true)
    public boolean isBookmarked(Long boardId, String loginId) {
        if (loginId == null) {
            return false;
        }
        Member member = memberRepository.findByLoginId(loginId).orElse(null);
        Board board = boardRepository.findById(boardId).orElse(null);
        if (member == null || board == null) {
            return false;
        }
        return bookmarkRepository.findByMemberAndBoard(member, board).isPresent();
    }
}
