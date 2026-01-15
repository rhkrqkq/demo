<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${board.title}</title>
    <style>
        .post-container { max-width: 900px; margin: 0 auto; }
        .post-content { min-height: 300px; white-space: pre-wrap; line-height: 1.6; }
        .comment-item { transition: background 0.2s; }
        .comment-item:hover { background-color: #f8f9fa; }
    </style>
</head>
<body class="bg-light">
<%@ include file="header.jsp" %>

<div class="container py-5 post-container">
    <%-- 게시글 영역 --%>
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-body p-5">
            <%-- 메타 정보 --%>
            <div class="d-flex justify-content-between align-items-center mb-3">
                <span class="badge bg-primary px-3 py-2">No. <span id="boardId">${board.id}</span></span>
                <div class="text-muted small">
                    <span class="me-3">👤 ${board.writer}</span>
                    <span>👀 조회수 ${board.hits}</span>
                </div>
            </div>

            <%-- 제목 --%>
            <h1 class="fw-bold mb-4">${board.title}</h1>
            <hr class="text-secondary opacity-25">

            <%-- 본문 --%>
            <div class="post-content fs-5 mb-5">${board.content}</div>

            <%-- 하단 버튼 영역 --%>
            <div class="d-flex justify-content-between border-top pt-4">
                <a href="/board/list?page=${param.page}&keyword=${param.keyword}" class="btn btn-outline-dark">
                    ← 목록으로
                </a>

                <c:if test="${sessionScope.loginMember.name eq board.writer}">
                    <div>
                        <a href="/board/write?id=${board.id}&page=${param.page}&keyword=${param.keyword}"
                           class="btn btn-warning me-1">수정하기</a>
                        <button type="button" class="btn btn-danger" onclick="deleteBoard()">삭제하기</button>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <%-- 댓글 영역 --%>
    <div class="card shadow-sm border-0">
        <div class="card-body p-4">
            <h5 class="fw-bold mb-4">💬 댓글 (${comments.size()})</h5>

            <%-- 댓글 입력 --%>
            <c:if test="${not empty sessionScope.loginMember}">
                <div class="mb-4 bg-light p-3 rounded">
                    <textarea id="commentContent" class="form-control mb-2" rows="3"
                              placeholder="내용을 입력해주세요"></textarea>
                    <div class="d-flex justify-content-end">
                        <button type="button" class="btn btn-primary px-4"
                                onclick="addComment(${board.id})">댓글 등록</button>
                    </div>
                </div>
            </c:if>

            <%-- 댓글 목록 --%>
            <div id="comment-list">
                <c:forEach var="comment" items="${comments}">
                    <div id="comment-container-${comment.id}" class="comment-item border-bottom py-3 px-2">
                        <div class="d-flex justify-content-between mb-2">
                            <strong>${comment.writer}</strong>
                            <small class="text-muted">${comment.createdAt}</small>
                        </div>

                        <p id="content-${comment.id}" class="mb-2 text-secondary">${comment.content}</p>

                        <c:if test="${sessionScope.loginMember.name eq comment.writer}">
                            <div id="btn-group-${comment.id}" class="text-end">
                                <button type="button" class="btn btn-sm btn-link text-decoration-none p-0 me-2"
                                        onclick="showEditForm(${comment.id})">수정</button>
                                <button type="button" class="btn btn-sm btn-link text-decoration-none text-danger p-0"
                                        onclick="deleteComment(${comment.id})">삭제</button>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
                <c:if test="${empty comments}">
                    <p class="text-center text-muted py-4">첫 번째 댓글을 남겨보세요!</p>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
    function deleteBoard() {
        const id = document.getElementById('boardId').innerText;
        if (!confirm('정말로 삭제하시겠습니까?')) return;
        fetch(`/api/board/\${id}`, { method: 'DELETE' })
            .then(async res => {
                if (res.ok) { alert('삭제되었습니다.'); location.href = '/board/list'; }
                else { alert(await res.text()); }
            });
    }

    function addComment(boardId) {
        const content = document.getElementById('commentContent').value;
        if(!content.trim()) return alert("내용을 입력하세요.");
        fetch(`/api/board/\${boardId}/comments`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ content: content, writer: "${sessionScope.loginMember.name}" })
        }).then(res => { if(res.ok) location.reload(); });
    }

    function deleteComment(commentId) {
        if(!confirm("삭제하시겠습니까?")) return;
        fetch(`/api/board/comments/\${commentId}`, { method: 'DELETE' })
            .then(res => { if(res.ok) location.reload(); });
    }

    function showEditForm(id) {
        const contentP = document.getElementById(`content-\${id}`);
        const btnGroup = document.getElementById(`btn-group-\${id}`);
        const originalContent = contentP.innerText;

        contentP.innerHTML = `<textarea id="edit-input-\${id}" class="form-control mb-2">\${originalContent}</textarea>`;
        btnGroup.innerHTML = `
            <button type="button" class="btn btn-sm btn-primary" onclick="updateComment(\${id})">저장</button>
            <button type="button" class="btn btn-sm btn-secondary" onclick="location.reload()">취소</button>
        `;
    }

    function updateComment(id) {
        const newContent = document.getElementById(`edit-input-\${id}`).value;
        fetch(`/api/board/comments/\${id}`, {
            method: 'PATCH',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ content: newContent })
        }).then(res => {
            if (res.ok) { alert("수정되었습니다."); location.reload(); }
        });
    }
</script>
</body>
</html>