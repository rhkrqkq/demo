<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${board.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="header.jsp" %>
<div class="container py-5" style="max-width: 850px;">
    <div class="card p-5 shadow-sm border-0 mb-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="fw-bold m-0">${board.title}</h2>
            <button onclick="handleBookmark(${board.id})" class="btn btn-outline-warning">
                ${isBookmarked ? '⭐ 북마크 취소' : '☆ 북마크'}
            </button>
        </div>
        <div class="text-muted small border-bottom pb-3 mb-4">
            <%-- 조회수 변수 hits 적용 --%>
            작성자: <strong>${board.writer}</strong> | 작성일: ${board.createdAt} | 조회: ${board.hits}
        </div>
        <div style="min-height: 200px; white-space: pre-wrap;" class="text-dark">${board.content}</div>
    </div>

    <div class="card p-4 shadow-sm border-0">
        <h5 class="fw-bold mb-3">댓글 (${board.commentCount})</h5>
        <textarea id="commentContent" class="form-control mb-2" rows="3" placeholder="댓글을 남겨보세요"></textarea>
        <div class="text-end mb-4">
            <button onclick="saveComment(${board.id})" class="btn btn-primary px-4">등록</button>
        </div>
        <div id="commentList" class="mt-2">
            <c:forEach var="comment" items="${board.comments}">
                <div class="py-3 border-bottom">
                    <div class="d-flex justify-content-between small fw-bold mb-1">
                        <span>${comment.writer}</span><span class="text-muted">${comment.createdAt}</span>
                    </div>
                    <p class="mb-0 small text-secondary">${comment.content}</p>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script>
    async function handleBookmark(id) {
        const res = await fetch('/api/bookmark/' + id, { method: 'POST' });
        if (res.ok) {
            alert("처리가 완료되었습니다.");
            location.reload();
        } else {
            alert("로그인이 필요합니다.");
        }
    }

    async function saveComment(id) {
        const content = document.getElementById('commentContent').value;
        if (!content.trim()) return alert("내용을 입력하세요.");
        const res = await fetch('/api/board/' + id + '/comments', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ content })
        });
        if (res.ok) location.reload();
        else alert("댓글 등록 실패");
    }
</script>
</body>
</html>