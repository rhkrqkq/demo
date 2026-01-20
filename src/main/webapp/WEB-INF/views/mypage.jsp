<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <style>
        .nav-pills .nav-link { color: #666; border-radius: 10px; padding: 12px 20px; }
        .nav-pills .nav-link.active { background-color: #0d6efd; color: white; }
        .item-card { transition: transform 0.2s; border-radius: 12px; }
        .item-card:hover { transform: translateY(-3px); }
    </style>
</head>
<body class="bg-light">
<%@ include file="board/header.jsp" %>

<div class="container py-5" style="max-width: 850px;">
    <div class="d-flex align-items-center mb-5">
        <div class="bg-primary rounded-circle text-white d-flex align-items-center justify-content-center shadow" style="width: 60px; height: 60px; font-size: 1.5rem;">
            ${sessionScope.loginMember.name.substring(0,1)}
        </div>
        <div class="ms-3">
            <h3 class="fw-bold mb-0">${sessionScope.loginMember.name}님, 반갑습니다!</h3>
        </div>
    </div>

    <%-- 탭 메뉴 --%>
    <ul class="nav nav-pills mb-4 bg-white p-2 rounded shadow-sm" id="pills-tab" role="tablist">
        <li class="nav-item flex-fill text-center" role="presentation">
            <button class="nav-link active w-100 fw-bold" id="posts-tab" data-bs-toggle="pill" data-bs-target="#posts-content" type="button">내가 쓴 글</button>
        </li>
        <li class="nav-item flex-fill text-center" role="presentation">
            <button class="nav-link w-100 fw-bold" id="bookmarks-tab" data-bs-toggle="pill" data-bs-target="#bookmarks-content" type="button">⭐ 북마크</button>
        </li>
    </ul>

    <%-- 탭 내용 --%>
    <div class="tab-content mt-3">
        <%-- 내 게시글 탭 --%>
        <div class="tab-pane fade show active" id="posts-content" role="tabpanel">
            <div class="row g-3">
                <c:forEach var="post" items="${myPosts}">
                    <div class="col-12">
                        <div class="card item-card border-0 shadow-sm">
                            <div class="card-body p-4 d-flex justify-content-between align-items-center">
                                <div>
                                    <h5 class="fw-bold mb-1">
                                        <a href="/board/view/${post.id}" class="text-decoration-none text-dark">${post.title}</a>
                                    </h5>
                                    <small class="text-muted">조회수 ${post.hits} · ${post.createdAt}</small>
                                </div>
                                <span class="badge bg-light text-dark border">작성완료</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty myPosts}">
                    <div class="text-center py-5 bg-white rounded shadow-sm">
                        <p class="text-muted mb-0">아직 작성한 게시글이 없습니다.</p>
                    </div>
                </c:if>
            </div>
        </div>

        <%-- 북마크 탭 --%>
        <div class="tab-pane fade" id="bookmarks-content" role="tabpanel">
            <div class="row g-3">
                <c:forEach var="mark" items="${myBookmarks}">
                    <div class="col-12">
                        <div class="card item-card border-0 shadow-sm border-start border-warning border-4">
                            <div class="card-body p-4 d-flex justify-content-between align-items-center">
                                <div>
                                    <h5 class="fw-bold mb-1">
                                        <a href="/board/view/${mark.board.id}" class="text-decoration-none text-dark">${mark.board.title}</a>
                                    </h5>
                                    <small class="text-muted">작성자: ${mark.board.writer} · 조회수 ${mark.board.hits}</small>
                                </div>
                                <span class="text-warning fs-4">★</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty myBookmarks}">
                    <div class="text-center py-5 bg-white rounded shadow-sm">
                        <p class="text-muted mb-0">북마크한 게시글이 없습니다.</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>