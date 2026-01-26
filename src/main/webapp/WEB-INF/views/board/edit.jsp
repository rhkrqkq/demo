<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="header.jsp" %>
<div class="container py-5" style="max-width: 800px;">
    <h2 class="fw-bold mb-4">게시글 수정</h2>
    <div class="card shadow-sm border-0 p-4">
        <div class="mb-3">
            <label class="form-label">제목</label>
            <input type="text" id="title" class="form-control" value="${board.title}">
        </div>
        <div class="mb-3">
            <label class="form-label">내용</label>
            <textarea id="content" class="form-control" rows="10">${board.content}</textarea>
        </div>
        <div class="text-end">
            <button type="button" class="btn btn-primary" onclick="updatePost(${board.id})">수정완료</button>
            <a href="/board/view/${board.id}" class="btn btn-secondary">취소</a>
        </div>
    </div>
</div>

<script>
    function updatePost(id) {
        const data = {
            title: document.getElementById('title').value,
            content: document.getElementById('content').value
        };

        fetch(`/api/board/\${id}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        }).then(res => {
            if (res.ok) {
                alert("수정되었습니다.");
                location.href = "/board/view/" + id;
            } else {
                res.json().then(error => alert("실패: " + error.message));
            }
        });
    }
</script>
</body>
</html>