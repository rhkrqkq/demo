<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 작성</title>
</head>
<body>
<%@ include file="header.jsp" %>
<h2>${empty board.id ? '게시글 등록' : '게시글 수정'}</h2>

<form id="saveForm">
    <input type="hidden" id="boardId" value="${board.id}">
    <div>
        <label>제목</label>
        <input type="text" id="title" value="${board.title}">
    </div>
    <div>
        <label>작성자</label>
        <%-- 신규 작성 시 로그인한 사용자 이름 자동 입력 --%>
        <input type="text" id="writer" value="${empty board.id ? sessionScope.loginMember.name : board.writer}" readonly>
    </div>
    <div>
        <label>내용</label>
        <textarea id="content">${board.content}</textarea>
    </div>
    <button type="button" onclick="save()">저장하기</button>
    <a href="/board/list?page=${param.page}&keyword=${param.keyword}">취소</a>
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
                    alert('저장되었습니다.');
                    location.href = `/board/list?page=${param.page}&keyword=${param.keyword}`;
                }
            });
    }
</script>
</body>
</html>