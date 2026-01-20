<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판 목록</title>
</head>
<body class="bg-light">
<%@ include file="header.jsp" %>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">전체 게시글</h2>
        <a href="/board/write" class="btn btn-primary px-4 shadow-sm">글쓰기</a>
    </div>

    <%-- 목록 테이블 --%>
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="table-light">
                <tr>
                    <th class="text-center" style="width: 100px;">주제</th>
                    <th>제목</th>
                    <th style="width: 120px;">작성자</th>
                    <th style="width: 120px;">날짜</th>
                    <th class="text-center" style="width: 80px;">조회</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="board" items="${boards.content}">
                    <tr>
                        <td class="text-center">
                            <span class="badge bg-secondary opacity-75">${board.category}</span>
                        </td>
                        <td>
                            <a href="/board/view/${board.id}" class="text-decoration-none text-dark fw-medium">
                                    ${board.title}
                            </a>
                        </td>
                        <td>${board.writer}</td>
                        <td class="text-muted small time-text" data-time="${board.createdAt}">
                                ${board.createdAt}
                        </td>
                        <td class="text-center text-muted">${board.hits}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    // 상대 시간 계산 함수
    function timeForToday(value) {
        const today = new Date();
        const timeValue = new Date(value);
        const betweenTime = Math.floor((today.getTime() - timeValue.getTime()) / 1000 / 60);
        if (betweenTime < 1) return '방금 전';
        if (betweenTime < 60) return `\${betweenTime}분 전`;
        const betweenTimeHour = Math.floor(betweenTime / 60);
        if (betweenTimeHour < 24) return `\${betweenTimeHour}시간 전`;
        const betweenTimeDay = Math.floor(betweenTimeHour / 24);
        if (betweenTimeDay < 8) return `\${betweenTimeDay}일 전`;
        return `\${timeValue.getFullYear()}-\${timeValue.getMonth() + 1}-\${timeValue.getDate()}`;
    }

    // 모든 시간 텍스트 변환
    document.querySelectorAll('.time-text').forEach(el => {
        el.innerText = timeForToday(el.dataset.time);
    });
</script>
</body>
</html>