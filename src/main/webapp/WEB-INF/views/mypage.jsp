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
    <h3 class="fw-bold mb-4">${loginMemberName}님의 마이페이지</h3>

    <div class="card shadow-sm border-0 p-4 mb-4">
        <h5 class="fw-bold mb-3">내가 등록한 북마크</h5>
        <table class="table table-hover">
            <thead class="table-light">
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>관리</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="bookmark" items="${bookmarks}">
                <tr>
                    <td>${bookmark.board.id}</td>
                    <td><a href="/board/view/${bookmark.board.id}">${bookmark.board.title}</a></td>
                    <td>${bookmark.board.writer}</td>
                    <td>
                        <button onclick="removeBookmark(${bookmark.board.id})" class="btn btn-sm btn-danger">삭제</button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty bookmarks}">
                <tr><td colspan="4" class="text-center text-muted">등록된 북마크가 없습니다.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<script>
    async function removeBookmark(boardId) {
        if(!confirm("북마크를 해제하시겠습니까?")) return;
        const res = await fetch('/api/bookmark/' + boardId, { method: 'POST' });
        if (res.ok) location.reload();
        else alert("처리에 실패했습니다.");
    }
</script>
</body>
</html>