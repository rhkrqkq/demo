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
<div class="container py-5">
    <div class="card p-5 shadow-sm border-0 mb-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <span class="badge bg-primary mb-2">${board.category}</span>
                <h2 class="fw-bold">${board.title}</h2>
                <p class="text-muted mb-0">
                    작성자: ${board.writer} |
                    일시: <span class="time-text" data-time="${board.createdAt}">${board.createdAt}</span>
                </p>
            </div>
            <div>
                <c:if test="${loginMemberName eq board.writer}">
                    <button onclick="location.href='/board/edit/${board.id}'" class="btn btn-outline-secondary btn-sm me-1">수정</button>
                    <button onclick="deleteBoard(${board.id})" class="btn btn-outline-danger btn-sm me-3">삭제</button>
                </c:if>
                <button onclick="toggleBookmark(${board.id})" class="btn ${isBookmarked ? 'btn-warning' : 'btn-outline-warning'}">
                    ${isBookmarked ? '⭐ 북마크 취소' : '☆ 북마크'}
                </button>
            </div>
        </div>
        <hr>
        <div class="py-3" style="min-height: 200px; white-space: pre-wrap;">${board.content}</div>
    </div>

    <div class="card p-4 shadow-sm border-0">
        <h5 class="fw-bold mb-3">댓글 (${comments.size()})</h5>

        <div class="input-group mb-4">
            <input type="text" id="commentContent" class="form-control" placeholder="댓글을 입력하세요">
            <button class="btn btn-dark" onclick="saveComment(${board.id})">등록</button>
        </div>

        <div id="comment-list">
            <c:forEach var="comment" items="${comments}">
                <div class="border-bottom py-3">
                    <div class="d-flex justify-content-between">
                        <h6 class="fw-bold">${comment.writer}</h6>
                        <c:if test="${loginMemberName eq comment.writer}">
                            <button class="btn btn-sm text-danger" onclick="deleteComment(${comment.id})">삭제</button>
                        </c:if>
                    </div>
                    <p class="mb-1">${comment.content}</p>
                    <small class="text-muted time-text" data-time="${comment.createdAt}">${comment.createdAt}</small>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script>
    // 쿠키에서 토큰 꺼내기 유틸
    function getCookie(name) {
        let value = "; " + document.cookie;
        let parts = value.split("; " + name + "=");
        if (parts.length === 2) return parts.pop().split(";").shift();
    }

    // 상대 시간 변환 함수
    function timeForToday(value) {
        const today = new Date();
        const timeValue = new Date(value);
        const betweenTime = Math.floor((today.getTime() - timeValue.getTime()) / 1000 / 60);

        if (betweenTime < 1) return '방금 전';
        if (betweenTime < 60) return `\${betweenTime}분 전`;

        const betweenTimeHour = Math.floor(betweenTime / 60);
        if (betweenTimeHour < 24) return `\${betweenTimeHour}시간 전`;

        return `\${timeValue.getFullYear()}-\${timeValue.getMonth() + 1}-\${timeValue.getDate()}`;
    }

    // 모든 시간 텍스트 변환 실행
    function renderTimes() {
        document.querySelectorAll('.time-text').forEach(el => {
            if(el.dataset.time) el.innerText = timeForToday(el.dataset.time);
        });
    }

    window.onload = renderTimes;

    async function toggleBookmark(boardId) {
        const token = getCookie('accessToken');
        const res = await fetch('/api/bookmark/' + boardId, {
            method: 'POST',
            headers: { 'Authorization': 'Bearer ' + token }
        });
        if(res.ok) location.reload();
    }

    async function saveComment(boardId) {
        const content = document.getElementById('commentContent').value;
        if(!content) return alert("내용을 입력하세요.");

        const token = getCookie('accessToken');
        const res = await fetch('/api/board/comments', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            },
            body: JSON.stringify({ boardId, content })
        });
        if(res.ok) location.reload();
    }

    async function deleteComment(commentId) {
        if(!confirm("삭제하시겠습니까?")) return;
        const token = getCookie('accessToken');
        const res = await fetch('/api/board/comments/' + commentId, {
            method: 'DELETE',
            headers: { 'Authorization': 'Bearer ' + token }
        });
        if(res.ok) location.reload();
    }

    async function deleteBoard(id) {
        if(!confirm("글을 삭제하시겠습니까?")) return;
        const token = getCookie('accessToken');
        const res = await fetch('/api/board/' + id, {
            method: 'DELETE',
            headers: { 'Authorization': 'Bearer ' + token }
        });
        if(res.ok) location.href = '/board/list';
    }
</script>
</body>
</html>