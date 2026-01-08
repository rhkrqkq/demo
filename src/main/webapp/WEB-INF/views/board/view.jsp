<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 상세 보기</title>
</head>
<body>
<h2>게시글 상세 보기</h2>
<table>
    <tr>
        <th>번호</th>
        <td id="boardId">${board.id}</td>
    </tr>
    <tr>
        <th>작성일</th>
        <td>${board.createdAt}</td>
    </tr>
    <tr>
        <th>작성자</th>
        <td>${board.writer}</td>
    </tr>
    <tr>
        <th>제목</th>
        <td>${board.title}</td>
    </tr>
    <tr>
        <th>내용</th>
        <td>${board.content}</td>
    </tr>
</table>

<br>
<c:set var="queryParams" value="page=${param.page}&keyword=${param.keyword}" />

<a href="/board/list?page=${param.page}&keyword=${param.keyword}">목록으로</a>
<a href="/board/write?id=${board.id}&page=${param.page}&keyword=${param.keyword}">수정하기</a>
<button type="button" onclick="deleteBoard()">삭제하기</button>

<script>
    function deleteBoard() {
        const id = document.getElementById('boardId').innerText;

        if (!confirm(id + '번 게시글을 삭제할까요?')) {
            return;
        }

        fetch(`/api/board/\${id}`, {
            method: 'DELETE'
        }).then(response => {
            if (response.ok) {
                alert('삭제되었습니다.');
                location.href = '/board/list';
            } else {
                alert('삭제에 실패했습니다.');
            }
        });
    }
</script>
</body>
</html>