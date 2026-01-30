<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>새 글 작성 - My Board</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="header.jsp" %>
<div class="container py-5" style="max-width: 800px;">
    <div class="card p-5 shadow-sm border-0">
        <h3 class="fw-bold mb-4">새 글 작성</h3>
        <div class="mb-3">
            <label class="form-label fw-bold small">카테고리</label>
            <select id="category" class="form-select bg-light">
                <option value="자유게시판">자유게시판</option>
                <option value="질문게시판">질문게시판</option>
                <option value="정보공유">정보공유</option>
            </select>
        </div>
        <div class="mb-3">
            <label class="form-label fw-bold small">제목</label>
            <input type="text" id="title" class="form-control bg-light" placeholder="제목을 입력하세요">
        </div>
        <div class="mb-4">
            <label class="form-label fw-bold small">내용</label>
            <textarea id="content" class="form-control bg-light" rows="10" placeholder="내용을 입력하세요"></textarea>
        </div>
        <button type="button" onclick="handleSave()" class="btn btn-primary w-100 fw-bold py-3 shadow-sm">등록하기</button>
    </div>
</div>

<script>
    async function handleSave() {
        const token = localStorage.getItem('accessToken');
        if (!token) { alert("로그인이 필요합니다."); return; }

        const data = {
            category: document.getElementById('category').value,
            title: document.getElementById('title').value,
            content: document.getElementById('content').value
        };

        const response = await fetch('/api/board', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            },
            body: JSON.stringify(data)
        });

        if (response.ok) {
            alert("글이 등록되었습니다.");
            location.href = "/board/list";
        } else {
            alert("등록 실패: 로그인 상태를 확인해주세요.");
        }
    }
</script>
</body>
</html>