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
                .orElseThrow(() -> new RuntimeException("회원을 찾을 수 없습니다."));
        Board board = boardRepository.findById(boardId)
                .orElseThrow(() -> new RuntimeException("게시글을 찾을 수 없습니다."));

        Optional<Bookmark> bookmark = bookmarkRepository.findByMemberAndBoard(member, board);

        if (bookmark.isPresent()) {
            bookmarkRepository.delete(bookmark.get());
            return false;
        } else {
            bookmarkRepository.save(Bookmark.builder().member(member).board(board).build());
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
