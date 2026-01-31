<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>글쓰기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="header.jsp" %>
<div class="container py-5">
    <div class="card shadow-sm border-0 p-4">
        <h3 class="fw-bold mb-4">새 글 작성</h3>
        <div class="mb-3">
            <label class="form-label">카테고리</label>
            <select id="category" class="form-select">
                <option value="공지">공지사항</option>
                <option value="자유">자유게시판</option>
                <option value="정보">정보게시판</option>
            </select>
        </div>
        <div class="mb-3">
            <label class="form-label fw-bold">제목</label>
            <input type="text" id="title" class="form-control" placeholder="제목을 입력하세요">
        </div>
        <div class="mb-3">
            <label class="form-label fw-bold">내용</label>
            <textarea id="content" class="form-control" rows="10" placeholder="내용을 입력하세요"></textarea>
        </div>
        <div class="text-end">
            <button onclick="location.href='/board/list'" class="btn btn-secondary me-2">취소</button>
            <button onclick="submitBoard()" class="btn btn-primary">등록하기</button>
        </div>
    </div>
</div>

<script>
    async function submitBoard() {
        const category = document.getElementById('category').value;
        const title = document.getElementById('title').value;
        const content = document.getElementById('content').value;

        if(!title || !content) return alert("제목과 내용을 모두 입력해주세요.");

        const res = await fetch('/api/board', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ category, title, content })
        });

        if(res.ok) {
            alert("글이 등록되었습니다.");
            location.href = '/board/list';
        } else {
            alert("등록 실패. 다시 시도해주세요.");
        }
    }
</script>
</body>
</html>