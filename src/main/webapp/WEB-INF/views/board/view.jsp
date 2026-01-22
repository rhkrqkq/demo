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
    </style>
</head>
<body class="bg-light">
<%@ include file="header.jsp" %>

<div class="container py-5 post-container">
    <%-- 게시글 본문 영역 --%>
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-body p-5">
            <div class="mb-3">
                <span class="badge bg-primary opacity-75 mb-2">${board.category}</span>
                <h1 class="fw-bold display-6">${board.title}</h1>
                <div class="text-muted small mt-3">
                    <span class="me-3">👤 ${board.writer}</span>
                    <span class="time-convert" data-time="${board.createdAt}"></span>
                    <c:if test="${board.createdAt != board.updatedAt}">
                        <span class="ms-2 text-info fw-bold">(수정됨)</span>
                    </c:if>
                </div>
            </div>
            <hr class="my-4 opacity-25">
            <div class="post-content fs-5 mb-5">${board.content}</div>
        </div>
    </div>

    <%-- 댓글 작성 구역 --%>
    <div class="card shadow-sm border-0 mb-4 comment-input-box">
        <div class="card-body p-4">
            <h6 class="fw-bold mb-3">💬 댓글 남기기</h6>
            <div class="row g-2">
                <div class="col-md-3">
                    <%-- 로그인한 사용자의 이름을 세션에서 가져와 자동으로 채움 --%>
                    <input type="text" id="comment-writer" class="form-control bg-light"
                           value="${sessionScope.loginMember.name}" readonly>
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

    <%-- 댓글 목록 영역 --%>
    <div class="card shadow-sm border-0">
        <div class="card-body p-4">
            <h5 class="fw-bold mb-4">전체 댓글 (${board.comments.size()})</h5>
            <div id="comment-list">
                <c:forEach var="comment" items="${board.comments}">
                    <div class="comment-item py-3">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="fw-bold">${comment.writer}</span>
                            <small class="text-muted time-convert" data-time="${comment.createdAt}">
                                    ${comment.createdAt}
                            </small>
                        </div>
                        <p class="text-secondary mb-0">${comment.content}</p>
                    </div>
                </c:forEach>
                <c:if test="${board.comments.size() == 0}">
                    <p class="text-muted text-center py-3">첫 번째 댓글을 남겨보세요!</p>
                </c:if>
            </div>
        </div>
    </div>

    <%-- 하단 버튼 --%>
    <div class="mt-4 text-center">
        <a href="/board/list" class="btn btn-outline-secondary px-4">목록으로</a>
    </div>
</div>

<script>
    // 시간 변환 함수
    function formatRelativeTime(value) {
        if (!value) return '';
        const today = new Date();
        const timeValue = new Date(value);
        const betweenTime = Math.floor((today.getTime() - timeValue.getTime()) / 1000 / 60);

        if (betweenTime < 1) return '방금 전';
        if (betweenTime < 60) return `${betweenTime}분 전`;
        const hour = Math.floor(betweenTime / 60);
        if (hour < 24) return `${hour}시간 전`;
        const day = Math.floor(hour / 24);
        if (day < 8) return `${day}일 전`;

        return `${timeValue.getFullYear()}-${timeValue.getMonth() + 1}-${timeValue.getDate()}`;
    }

    // 댓글 저장 함수 (Ajax)
    function saveComment(boardId) {
        const writer = document.getElementById('comment-writer').value;
        const content = document.getElementById('comment-content').value;

        if (!writer.trim() || !content.trim()) {
            alert("내용을 입력해주세요.");
            return;
        }

        const data = {
            writer: writer,
            content: content
        };

        // 수정된 경로: /api/board/{id}/comments
        fetch(`/api/board/\${boardId}/comments`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        })
            .then(response => {
                if (response.ok) {
                    alert("댓글이 등록되었습니다.");
                    location.reload();
                } else {
                    alert("등록에 실패했습니다.");
                }
            });
    }

    document.addEventListener("DOMContentLoaded", function() {
        document.querySelectorAll('.time-convert').forEach(el => {
            el.innerText = formatRelativeTime(el.getAttribute('data-time'));
        });
    });
</script>
</body>
</html>