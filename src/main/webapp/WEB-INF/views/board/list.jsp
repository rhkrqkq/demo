<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="header.jsp" %>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">게시판</h2>
        <a href="/board/write" class="btn btn-primary px-4 shadow-sm">글쓰기</a>
    </div>

    <div class="mb-4">
        <div class="btn-group shadow-sm" role="group">
            <a href="/board/list?category=ALL&keyword=${keyword}" class="btn btn-outline-primary ${category == 'ALL' || category == null ? 'active' : ''}">전체</a>
            <a href="/board/list?category=NOTICE&keyword=${keyword}" class="btn btn-outline-primary ${category == 'NOTICE' ? 'active' : ''}">공지사항</a>
            <a href="/board/list?category=FREE&keyword=${keyword}" class="btn btn-outline-primary ${category == 'FREE' ? 'active' : ''}">자유게시판</a>
        </div>
    </div>

    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="table-light">
                <tr class="text-center">
                    <th style="width: 100px;">주제</th>
                    <th>제목</th>
                    <th style="width: 120px;">작성자</th>
                    <th style="width: 150px;">날짜</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="board" items="${boards.content}">
                    <tr>
                        <td class="text-center">
                            <span class="badge ${board.category == 'NOTICE' ? 'bg-danger' : 'bg-secondary'} opacity-75">
                                    ${board.category}
                            </span>
                        </td>
                        <td>
                            <a href="/board/view/${board.id}" class="text-decoration-none text-dark fw-medium">
                                    ${board.title}
                                    <c:if test="${board.commentCount > 0}">
                                        <span class="text-danger small"> [${board.commentCount}]</span>
                                    </c:if>
                            </a>
                        </td>
                        <td class="text-center">${board.writer}</td>
                        <td class="text-center text-muted small time-text" data-time="${board.createdAt}">
                                ${board.createdAt}
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <nav aria-label="Page navigation">
        <ul class="pagination justify-content-center">
            <%-- 게시글이 있을 때만 페이지 번호 출력 (end < 0 에러 방지) --%>
            <c:if test="${boards.totalPages > 0}">
                <c:if test="${boards.hasPrevious()}">
                    <li class="page-item">
                        <a class="page-link" href="/board/list?page=${boards.number - 1}&category=${category}&keyword=${keyword}">이전</a>
                    </li>
                </c:if>

                <c:forEach var="i" begin="0" end="${boards.totalPages - 1}">
                    <li class="page-item ${i == boards.number ? 'active' : ''}">
                        <a class="page-link" href="/board/list?page=${i}&category=${category}&keyword=${keyword}">${i + 1}</a>
                    </li>
                </c:forEach>

                <c:if test="${boards.hasNext()}">
                    <li class="page-item">
                        <a class="page-link" href="/board/list?page=${boards.number + 1}&category=${category}&keyword=${keyword}">다음</a>
                    </li>
                </c:if>
            </c:if>
        </ul>
    </nav>

    <div class="row justify-content-center mt-4">
        <div class="col-md-6">
            <form action="/board/list" method="get" class="input-group shadow-sm">
                <input type="hidden" name="category" value="${category}">
                <input type="text" name="keyword" class="form-control" placeholder="제목으로 검색" value="${keyword}">
                <button class="btn btn-primary" type="submit">검색</button>
            </form>
        </div>
    </div>
</div>

<script>
    // 상대 시간 변환 스크립트 (기존 동일)
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
    document.querySelectorAll('.time-text').forEach(el => {
        if(el.dataset.time) el.innerText = timeForToday(el.dataset.time);
    });
</script>
</body>
</html>