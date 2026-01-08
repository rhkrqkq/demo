<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 작성</title>
</head>
<body>
<h2>
    <c:choose>
        <c:when test="${empty board.id}">게시글 등록</c:when>
        <c:otherwise>게시글 수정</c:otherwise>
    </c:choose>
</h2>

<form id="saveForm">
    <input type="hidden" id="boardId" value="${board.id}">

    <div>
        <label>제목</label>
        <input type="text" id="title" value="${board.title}" placeholder="제목을 입력하세요">
    </div>
    <div>
        <label>작성자</label>
        <input type="text" id="writer" value="${board.writer}"
               ${not empty board.id ? 'readonly' : ''} placeholder="작성자 성함">
    </div>
    <div>
        <label>내용</label>
        <textarea id="content" placeholder="내용을 입력하세요">${board.content}</textarea>
    </div>

    <button type="button" onclick="save()">저장하기</button>
    <a href="/board/list">취소</a>
</form>

<script>
    function save() {
        const id = document.getElementById('boardId').value;
        const params = {
            title: document.getElementById('title').value,
            writer: document.getElementById('writer').value,
            content: document.getElementById('content').value
        };

        const method = id ? 'PATCH' : 'POST';
        const url = id ? `/api/board/\${id}` : '/api/board';

        fetch(url, {
            method: method,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(params)
        })
            .then(response => {
                if (response.ok) {
                    alert('저장이 완료되었습니다.');
                    location.href = '/board/list';
                } else {
                    alert('저장에 실패했습니다.');
                }
            })
            .catch(error => console.error('Error:', error));
    }
</script>
</body>
</html>