<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 상세 보기</title>
</head>
<body>
<%@ include file="header.jsp" %>
<h2>게시글 상세 보기</h2>
<table>
    <tr><th>번호</th><td id="boardId">${board.id}</td></tr>
    <tr><th>작성자</th><td>${board.writer}</td></tr>
    <tr><th>제목</th><td>${board.title}</td></tr>
    <tr><th>내용</th><td>${board.content}</td></tr>
</table>

<br>
<%-- 목록으로 돌아갈 때 정보 유지 --%>
<a href="/board/list?page=${param.page}&keyword=${param.keyword}">목록으로</a>

<%-- 로그인한 사용자와 작성자가 같을 때만 수정/삭제 허용 --%>
<c:if test="${sessionScope.loginMember.name eq board.writer}">
    <a href="/board/write?id=${board.id}&page=${param.page}&keyword=${param.keyword}">수정하기</a>
    <button type="button" onclick="deleteBoard()">삭제하기</button>
</c:if>

<script>
    function deleteBoard() {
        const id = document.getElementById('boardId').innerText;
        if (!confirm(id + '번 게시글을 삭제할까요?')) return;

        fetch(`/api/board/\${id}`, { method: 'DELETE' })
            .then(response => {
                if (response.ok) {
                    alert('삭제되었습니다.');
                    location.href = '/board/list?page=${param.page}&keyword=${param.keyword}';
                }
            });
    }
</script>
</body>
</html>