<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판 목록</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
        .pagination { margin-top: 20px; text-align: center; }
        .pagination a { margin: 0 5px; text-decoration: none; color: black; }
        .active { font-weight: bold; color: red !important; }
    </style>
</head>
<body>
<%@ include file="header.jsp" %>
<h2>게시판 목록 (JSP)</h2>

<div style="margin-bottom: 10px;">
    <form action="/board/list" method="get">
        <input type="text" name="keyword" value="${keyword}" placeholder="제목 검색">
        <button type="submit">검색</button>
    </form>
</div>

<table>
    <thead>
    <tr>
        <th>번호</th>
        <th>제목</th>
        <th>작성자</th>
        <th>작성일</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${not empty boards.content}">
            <c:forEach var="board" items="${boards.content}">
                <tr>
                    <td>${board.id}</td>
                    <td>
                        <a href="/board/view/${board.id}?page=${boards.number}&keyword=${keyword}">${board.title}</a>
                    </td>
                    <td>${board.writer}</td>
                    <td>
                            <%-- LocalDateTime 포맷팅 처리 --%>
                            ${board.createdAt.toLocalDate()} ${board.createdAt.toLocalTime()}
                    </td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="4">게시글이 없습니다.</td>
            </tr>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>

<div class="pagination">
    <%-- '이전' 버튼 --%>
    <c:if test="${boards.hasPrevious()}">
        <a href="/board/list?page=${boards.number - 1}&keyword=${keyword}">이전</a>
    </c:if>

    <%-- 페이지 번호 목록 --%>
    <c:forEach var="i" begin="0" end="${boards.totalPages - 1}">
        <%-- 현재 페이지 근처 5개씩만 노출되도록 설정 가능 --%>
        <c:if test="${i >= boards.number - 5 && i <= boards.number + 5}">
            <a href="/board/list?page=${i}&keyword=${keyword}"
               class="${i == boards.number ? 'active' : ''}">
                    ${i + 1}
            </a>
        </c:if>
    </c:forEach>

    <%-- '다음' 버튼 --%>
    <c:if test="${boards.hasNext()}">
        <a href="/board/list?page=${boards.number + 1}&keyword=${keyword}">다음</a>
    </c:if>
</div>

<br>
<a href="/board/write">글쓰기</a>

</body>
</html>