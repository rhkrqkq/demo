<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="header.jsp" %>
<div class="container py-5">
    <h3 class="fw-bold mb-4">마이페이지</h3>

    <div class="card shadow-sm border-0 p-4 mb-5">
        <h5 class="fw-bold text-primary mb-3">⭐ 내 북마크</h5>
        <table class="table table-hover">
            <tbody>
            <c:forEach var="bookmark" items="${bookmarks}">
                <tr>
                    <td><a href="/board/view/${bookmark.board.id}" class="text-dark text-decoration-none">${bookmark.board.title}</a></td>
                    <td class="text-end">
                        <button onclick="toggleBookmark(${bookmark.board.id})" class="btn btn-sm btn-outline-danger">해제</button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty bookmarks}">
                <tr><td class="text-center text-muted py-4">북마크한 글이 없습니다.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <div class="card shadow-sm border-0 p-4">
        <h5 class="fw-bold text-success mb-3">📝 내가 작성한 글</h5>
        <table class="table table-hover">
            <tbody>
            <c:forEach var="board" items="${myBoards}">
                <tr>
                    <td><a href="/board/view/${board.id}" class="text-dark text-decoration-none">${board.title}</a></td>
                    <td class="text-end text-muted small">${board.createdAt}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty myBoards}">
                <tr><td class="text-center text-muted py-4">작성한 글이 없습니다.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<script>
    async function toggleBookmark(id) {
        const res = await fetch('/api/bookmark/' + id, { method: 'POST' });
        if(res.ok) location.reload();
    }
</script>
</body>
</html>