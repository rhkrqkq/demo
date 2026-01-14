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
<%-- 목록으로 돌아갈 때 정보 유지 --%>
<a href="/board/list?page=${param.page}&keyword=${param.keyword}">목록으로</a>

<%-- 로그인한 사용자와 작성자가 같을 때만 수정/삭제 허용 --%>
<c:if test="${sessionScope.loginMember.name eq board.writer}">
    <a href="/board/write?id=${board.id}&page=${param.page}&keyword=${param.keyword}">수정하기</a>
    <button type="button" onclick="deleteBoard()">삭제하기</button>
</c:if>
<%-- 게시글 내용 아래에 추가 --%>
<hr>
<h3>댓글 (${comments.size()})</h3>
<div id="comment-list">
    <c:forEach var="comment" items="${comments}">
        <div style="border-bottom: 1px solid #eee; padding: 10px;">
            <strong>${comment.writer}</strong>
            <small style="color: gray;">${comment.createdAt}</small>
            <p>${comment.content}</p>

                <%-- 추가할 부분: 로그인 사용자와 댓글 작성자가 같을 때만 삭제 버튼 노출 --%>
            <c:if test="${sessionScope.loginMember.name eq comment.writer}">
                <button type="button" onclick="deleteComment(${comment.id})"
                        style="color:red; font-size: 0.8em; cursor:pointer;">삭제</button>
            </c:if>
        </div>
    </c:forEach>
</div>

<%-- 댓글 입력 폼 (로그인 시에만 노출) --%>
<c:if test="${not empty sessionScope.loginMember}">
    <div style="margin-top: 20px;">
        <textarea id="commentContent" rows="3" style="width: 100%;"></textarea>
        <button type="button" onclick="addComment(${board.id})">댓글 등록</button>
    </div>
</c:if>

<c:if test="${sessionScope.loginMember.name eq comment.writer}">
    <button type="button" onclick="deleteComment(${comment.id})" style="color:red; cursor:pointer;">삭제</button>
</c:if>

<script>
    function deleteBoard() {
        const id = document.getElementById('boardId').innerText;
        if (!confirm(id + '번 게시글을 삭제할까요?')) return;

        fetch(`/api/board/${id}`, { method: 'DELETE' })
            .then(async response => {
                if (response.ok) {
                    alert('삭제되었습니다.');
                    location.href = '/board/list';
                } else {
                    // 서버가 보낸 에러 메시지("삭제 권한이 없습니다." 등)를 읽어서 띄웁니다.
                    const errorMsg = await response.text();
                    alert(errorMsg);
                }
            })
            .catch(error => alert('네트워크 오류가 발생했습니다.'));
    }

    function addComment(boardId) {
        const params = {
            content: document.getElementById('commentContent').value,
            writer: "${sessionScope.loginMember.name}"
        };
        fetch(`/api/board/\${boardId}/comments`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(params)
        }).then(res => { if(res.ok) location.reload(); });
    }

    // 댓글 삭제 함수 추가
    function deleteComment(commentId) {
        if(!confirm("댓글을 삭제하시겠습니까?")) return;

        fetch(`/api/board/comments/\${commentId}`, {
            method: 'DELETE'
        }).then(res => {
            if(res.ok) {
                alert("삭제되었습니다.");
                location.reload();
            } else {
                alert("삭제 권한이 없거나 오류가 발생했습니다.");
            }
        });
    }
</script>
</body>
</html>