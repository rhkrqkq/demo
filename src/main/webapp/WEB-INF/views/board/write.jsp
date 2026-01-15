<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${not empty board.id ? '게시글 수정' : '새 글 작성'}</title>
    <style>
        /* 추가적인 미세 디자인 조정 */
        .write-container { max-width: 850px; }
        .form-floating > .form-control:focus { border-color: #0d6efd; box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.1); }
        .card { border-radius: 15px; overflow: hidden; }
        .btn { border-radius: 8px; font-weight: 600; transition: all 0.2s; }
    </style>
</head>
<body class="bg-light">
<%@ include file="header.jsp" %>

<div class="container py-5 write-container">
    <%-- 상단 타이틀 영역 --%>
    <div class="text-center mb-4">
        <h2 class="fw-bold text-dark">
            <c:choose>
                <c:when test="${not empty board.id}">게시글 수정</c:when>
                <c:otherwise>새 글 작성</c:otherwise>
            </c:choose>
        </h2>
    </div>

    <div class="card shadow-lg border-0">
        <div class="card-body p-5">
            <form id="postForm">
                <%-- Hidden ID --%>
                <input type="hidden" id="boardId" value="${board.id}">

                <%-- 제목 입력 (Floating Label) --%>
                <div class="form-floating mb-4">
                    <input type="text" class="form-control border-0 bg-light" id="title"
                           placeholder="제목" value="${board.title}" style="font-size: 1.2rem; height: 70px;">
                    <label for="title" class="text-secondary">제목을 입력하세요</label>
                </div>

                <%-- 내용 입력 (Floating Label) --%>
                <div class="form-floating mb-4">
                    <textarea class="form-control border-0 bg-light" id="content"
                              placeholder="내용" style="height: 450px; resize: none;">${board.content}</textarea>
                    <label for="content" class="text-secondary">여기에 내용을 입력하세요</label>
                </div>

                <%-- 버튼 영역: 하단 배치 및 정렬 --%>
                <div class="row g-3">
                    <div class="col-6">
                        <button type="button" class="btn btn-outline-secondary w-100 py-3" onclick="history.back()">
                            취소하고 돌아가기
                        </button>
                    </div>
                    <div class="col-6">
                        <button type="button" class="btn btn-primary w-100 py-3 shadow-sm" onclick="savePost()">
                            ${not empty board.id ? '수정 내용 저장' : '작성 완료'}
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function savePost() {
        const id = document.getElementById('boardId').value;
        const title = document.getElementById('title').value;
        const content = document.getElementById('content').value;

        if(!title.trim() || !content.trim()) {
            alert("제목과 내용을 모두 채워주세요!");
            return;
        }

        const url = id ? `/api/board/\${id}` : '/api/board';
        const method = id ? 'PATCH' : 'POST';

        const data = { title, content };
        if (!id) data.writer = "${sessionScope.loginMember.name}";

        fetch(url, {
            method: method,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        }).then(res => {
            if(res.ok) {
                alert(id ? "성공적으로 수정되었습니다." : "게시글이 등록되었습니다.");
                location.href = '/board/list';
            } else {
                alert("처리 중 오류가 발생했습니다.");
            }
        });
    }
</script>
</body>
</html>