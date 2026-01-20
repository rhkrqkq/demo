<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>글쓰기</title>
</head>
<body class="bg-light">
<%@ include file="header.jsp" %>

<div class="container py-5" style="max-width: 800px;">
    <div class="card border-0 shadow-lg">
        <div class="card-body p-5">
            <h3 class="fw-bold mb-4">${not empty board.id ? '게시글 수정' : '새 글 작성'}</h3>

            <form id="postForm">
                <input type="hidden" id="boardId" value="${board.id}">

                <%-- 카테고리 선택 --%>
                <div class="form-floating mb-3">
                    <select class="form-select border-0 bg-light" id="category">
                        <option value="자유" ${board.category == '자유' ? 'selected' : ''}>자유게시판</option>
                        <option value="정보" ${board.category == '정보' ? 'selected' : ''}>정보공유</option>
                        <option value="공지" ${board.category == '공지' ? 'selected' : ''}>공지사항</option>
                    </select>
                    <label for="category">게시판 주제를 선택하세요</label>
                </div>

                <div class="form-floating mb-3">
                    <input type="text" class="form-control border-0 bg-light" id="title" value="${board.title}" placeholder="제목">
                    <label for="title">제목</label>
                </div>

                <div class="form-floating mb-4">
                    <textarea class="form-control border-0 bg-light" id="content" style="height: 400px" placeholder="내용">${board.content}</textarea>
                    <label for="content">내용을 입력하세요</label>
                </div>

                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                    <button type="button" class="btn btn-light px-4" onclick="history.back()">취소</button>
                    <button type="button" class="btn btn-primary px-5" onclick="savePost()">작성 완료</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function savePost() {
        const id = document.getElementById('boardId').value;
        const data = {
            category: document.getElementById('category').value,
            title: document.getElementById('title').value,
            content: document.getElementById('content').value,
            writer: "${sessionScope.loginMember.name}"
        };

        const url = id ? `/api/board/\${id}` : '/api/board';
        const method = id ? 'PATCH' : 'POST';

        fetch(url, {
            method: method,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        }).then(res => res.ok && (location.href = '/board/list'));
    }
</script>
</body>
</html>