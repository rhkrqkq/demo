<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${board.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .post-container { max-width: 900px; margin: 0 auto; }
        .post-content { min-height: 300px; white-space: pre-wrap; line-height: 1.8; color: #333; }
        .comment-item { border-bottom: 1px solid #f1f3f5; }
        .comment-input-box { background-color: #f8f9fa; border-radius: 10px; }
        /* 수정/삭제 버튼: 아주 작게, 검정색, 날짜 아래 */
        .btn-mini-action {
            color: #000 !important;
            text-decoration: none !important;
            font-size: 0.65rem;
            padding: 0;
            margin-left: 8px;
        }
        .btn-mini-action:hover { font-weight: bold; }
    </style>
</head>
<body class="bg-light">
<%@ include file="header.jsp" %>

<div class="container py-5 post-container">
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-body p-5">
            <div class="d-flex justify-content-between align-items-start mb-3">
                <div>
                    <span class="badge bg-primary opacity-75 mb-2">${board.category}</span>
                    <h1 class="fw-bold display-6">${board.title}</h1>
                </div>
                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="toggleBookmark(${board.id})">🔖 북마크</button>
            </div>
            <div class="text-muted small mt-3">
                <span class="me-3">👤 ${board.writer}</span>
                <span class="time-convert" data-time="${board.createdAt}"></span>
            </div>
            <hr class="my-4 opacity-25">
            <div class="post-content fs-5 mb-5">${board.content}</div>

            <c:if test="${sessionScope.loginMember.name == board.writer}">
                <div class="text-end">
                    <a href="/board/edit/${board.id}" class="btn btn-outline-warning btn-sm">수정</a>
                    <button type="button" class="btn btn-outline-danger btn-sm" onclick="deletePost(${board.id})">삭제</button>
                </div>
            </c:if>
        </div>
    </div>

    <div class="card shadow-sm border-0 mb-4 comment-input-box">
        <div class="card-body p-4">
            <h6 class="fw-bold mb-3">💬 댓글 남기기</h6>
            <div class="row g-2">
                <div class="col-md-3">
                    <input type="text" id="comment-writer" class="form-control bg-light" value="${sessionScope.loginMember.name}" readonly>
                </div>
                <div class="col-12">
                    <textarea id="comment-content" class="form-control" rows="3" placeholder="댓글 내용을 입력하세요."></textarea>
                </div>
                <div class="col-12 text-end">
                    <button type="button" class="btn btn-primary px-4" onclick="saveComment(${board.id})">등록</button>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-4">
            <h5 class="fw-bold mb-4" style="font-size: 1rem;">전체 댓글 (${board.comments.size()})</h5>
            <div id="comment-list">
                <c:forEach var="comment" items="${board.comments}">
                    <div class="comment-item py-3">
                        <div class="d-flex justify-content-between mb-1">
                            <span class="fw-bold" style="font-size: 0.9rem;">${comment.writer}</span>
                            <div class="text-end">
                                <div style="font-size: 0.75rem; color: #6c757d;">
                                    <span class="time-convert" data-time="${comment.createdAt}">${comment.createdAt}</span>
                                </div>
                                <c:if test="${sessionScope.loginMember.name == comment.writer}">
                                    <div class="mt-1">
                                        <button type="button" class="btn btn-link btn-mini-action" onclick="enableEdit(${comment.id}, '${comment.content}')">수정</button>
                                        <button type="button" class="btn btn-link btn-mini-action" onclick="deleteComment(${comment.id})">삭제</button>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        <div id="comment-box-${comment.id}">
                            <p class="text-secondary mb-0" style="font-size: 0.9rem;">${comment.content}</p>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script>
    function deletePost(id) {
        if (!confirm("삭제하시겠습니까?")) return;
        fetch(`/api/board/\${id}`, { method: 'DELETE' })
            .then(res => res.ok ? location.href="/board/list" : alert("실패"));
    }

    function toggleBookmark(boardId) {
        fetch(`/api/bookmarks/\${boardId}`, { method: 'POST' })
            .then(res => res.ok ? alert("북마크 완료") : alert("로그인을 확인하세요."));
    }

    function enableEdit(id, content) {
        const box = document.getElementById(`comment-box-\${id}`);
        box.innerHTML = `
            <div class="mt-2">
                <textarea id="edit-input-\${id}" class="form-control mb-2" rows="2" style="font-size:0.9rem;">\${content}</textarea>
                <div class="text-end">
                    <button class="btn btn-sm btn-dark py-0" onclick="updateComment(\${id})" style="font-size:0.7rem;">저장</button>
                    <button class="btn btn-sm btn-light border py-0" onclick="location.reload()" style="font-size:0.7rem;">취세</button>
                </div>
            </div>
        `;
    }

    function updateComment(id) {
        const content = document.getElementById(`edit-input-\${id}`).value;
        fetch(`/api/board/comments/\${id}`, {
            method: 'PATCH',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ content: content })
        }).then(res => res.ok ? location.reload() : alert("수정 실패"));
    }

    function deleteComment(id) {
        if (!confirm("삭제하시겠습니까?")) return;
        fetch(`/api/board/comments/\${id}`, { method: 'DELETE' })
            .then(res => res.ok ? location.reload() : alert("삭제 실패"));
    }

    function saveComment(boardId) {
        const content = document.getElementById('comment-content').value;
        const writer = document.getElementById('comment-writer').value;
        if(!content.trim()) return alert("내용을 입력하세요.");
        fetch(`/api/board/\${boardId}/comments`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ writer: writer, content: content })
        }).then(res => res.ok ? location.reload() : alert("실패"));
    }

    function formatRelativeTime(value) {
        if (!value) return '';
        const today = new Date();
        const timeValue = new Date(value);
        const betweenTime = Math.floor((today.getTime() - timeValue.getTime()) / 1000 / 60);
        if (betweenTime < 1) return '방금 전';
        if (betweenTime < 60) return `\${betweenTime}분 전`;
        const hour = Math.floor(betweenTime / 60);
        if (hour < 24) return `\${hour}시간 전`;
        return `\${timeValue.getFullYear()}-\${timeValue.getMonth() + 1}-\${timeValue.getDate()}`;
    }

    document.addEventListener("DOMContentLoaded", function() {
        document.querySelectorAll('.time-convert').forEach(el => {
            el.innerText = formatRelativeTime(el.getAttribute('data-time'));
        });
    });
</script>
</body>
</html>