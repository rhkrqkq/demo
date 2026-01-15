<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head><title>마이페이지</title></head>
<body class="bg-light">
<%@ include file="board/header.jsp" %>

<div class="container py-4">
    <div class="text-center mb-5">
        <h2 class="fw-bold">마이페이지</h2>
        <p class="text-muted">사용자 <strong>${sessionScope.loginMember.name}</strong>님의 활동 정보입니다.</p>
    </div>

    <div class="row g-4">
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-header bg-primary text-white py-3 fw-bold">📝 내가 쓴 게시글</div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush">
                        <c:forEach var="post" items="${myPosts}">
                            <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                                <a href="/board/view/${post.id}" class="text-decoration-none text-dark">${post.title}</a>
                                <span class="badge bg-info text-dark">조회 ${post.hits}</span>
                            </li>
                        </c:forEach>
                        <c:if test="${empty myPosts}">
                            <li class="list-group-item text-center py-4 text-muted">작성한 게시글이 없습니다.</li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-header bg-success text-white py-3 fw-bold">💬 내가 쓴 댓글</div>
                <div class="card-body p-3">
                    <c:forEach var="comment" items="${myComments}">
                        <div class="p-3 mb-2 bg-light rounded border">
                            <p class="mb-1 text-dark">${comment.content}</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted">${comment.createdAt}</small>
                                <a href="/board/view/${comment.boardId}" class="btn btn-sm btn-outline-success">원문보기</a>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty myComments}">
                        <div class="text-center py-4 text-muted">작성한 댓글이 없습니다.</div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>