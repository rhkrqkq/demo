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
    <tr><th>조회수</th><td>${board.hits}</td></tr>
</table>

<br>
<a href="/board/list?page=${param.page}&keyword=${param.keyword}">목록으로</a>

<c:if test="${sessionScope.loginMember.name eq board.writer}">
    <a href="/board/write?id=${board.id}&page=${param.page}&keyword=${param.keyword}">수정하기</a>
    <button type="button" onclick="deleteBoard()">삭제하기</button>
</c:if>

<hr>
<h3>댓글 (${comments.size()})</h3>

<%-- 댓글 목록 (중복 제거된 단일 루프) --%>
<div id="comment-list">
    <c:forEach var="comment" items="${comments}">
        <div id="comment-container-${comment.id}" style="border-bottom: 1px solid #eee; padding: 10px;">
            <strong>${comment.writer}</strong>
            <small style="color: gray;">${comment.createdAt}</small>

                <%-- ID가 content-${comment.id}인 이 부분이 중요합니다 --%>
            <p id="content-${comment.id}">${comment.content}</p>

            <c:if test="${sessionScope.loginMember.name eq comment.writer}">
                <div id="btn-group-${comment.id}">
                    <button type="button" onclick="showEditForm(${comment.id})">수정</button>
                    <button type="button" onclick="deleteComment(${comment.id})" style="color:red;">삭제</button>
                </div>
            </c:if>
        </div>
    </c:forEach>
</div>

<%-- 댓글 입력 --%>
<c:if test="${not empty sessionScope.loginMember}">
    <div style="margin-top: 20px; padding: 10px; background: #f9f9f9;">
        <textarea id="commentContent" rows="3" style="width: 100%;"></textarea>
        <button type="button" onclick="addComment(${board.id})">댓글 등록</button>
    </div>
</c:if>



<script>
    function deleteBoard() {
        const id = document.getElementById('boardId').innerText;
        if (!confirm(id + '번 게시글을 삭제할까요?')) return;
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

    // 수정 폼 전환 (백틱 안의 $ 앞에 \를 붙여야 JSP 에러가 안 납니다)
    function showEditForm(id) {
        const contentP = document.getElementById(`content-\${id}`);
        const btnGroup = document.getElementById(`btn-group-\${id}`);
        const originalContent = contentP.innerText;

        contentP.innerHTML = `<textarea id="edit-input-\${id}" style="width:100%; height:60px;">\${originalContent}</textarea>`;
        btnGroup.innerHTML = `
            <button type="button" onclick="updateComment(\${id})">저장</button>
            <button type="button" onclick="location.reload()">취소</button>
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