<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${board.title}</title>
    <style>
        .post-container { max-width: 900px; margin: 0 auto; }
        .post-content { min-height: 300px; white-space: pre-wrap; line-height: 1.8; color: #333; }
        .comment-item { border-bottom: 1px solid #f1f3f5; }
    </style>
</head>
<body class="bg-light">
<%@ include file="header.jsp" %>

<div class="container py-5 post-container">
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-body p-5">
            <div class="mb-3">
                <%-- 주제 출력 --%>
                <span class="badge bg-primary opacity-75 mb-2">${board.category}</span>
                <h1 class="fw-bold display-6">${board.title}</h1>
                <div class="text-muted small mt-3">
                    <span class="me-3">👤 ${board.writer}</span>
                    <%-- 본문 시간 --%>
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

    <%-- 댓글 영역 --%>
    <div class="card shadow-sm border-0">
        <div class="card-body p-4">
            <h5 class="fw-bold mb-4">💬 댓글 (${comments.size()})</h5>
            <div id="comment-list">
                <c:forEach var="comment" items="${comments}">
                    <div class="comment-item py-3">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="fw-bold">${comment.writer}</span>
                                <%-- 댓글 시간: 클래스 'time-convert' 부여 --%>
                            <small class="text-muted time-convert" data-time="${comment.createdAt}">
                                    ${comment.createdAt}
                            </small>
                        </div>
                        <p class="text-secondary mb-0">${comment.content}</p>
                    </div>
                </c:forEach>
            </div>
        </div>
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
        if (betweenTime < 60) return `\${betweenTime}분 전`;
        const hour = Math.floor(betweenTime / 60);
        if (hour < 24) return `\${hour}시간 전`;
        const day = Math.floor(hour / 24);
        if (day < 8) return `\${day}일 전`;

        return `\${timeValue.getFullYear()}-\${timeValue.getMonth() + 1}-\${timeValue.getDate()}`;
    }

    // 모든 시간 요소 한꺼번에 변환
    document.addEventListener("DOMContentLoaded", function() {
        document.querySelectorAll('.time-convert').forEach(el => {
            el.innerText = formatRelativeTime(el.getAttribute('data-time'));
        });
    });
</script>
</body>
</html>