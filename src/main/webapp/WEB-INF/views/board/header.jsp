<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="/board/list">🚀 MY BOARD</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <c:choose>
                    <c:when test="${empty sessionScope.loginMember}">
                        <li class="nav-item"><a class="nav-link" href="/login">로그인</a></li>
                        <li class="nav-item"><a class="nav-link btn btn-outline-light btn-sm ms-lg-2" href="/signup">회원가입</a></li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item"><span class="nav-link text-white me-2">👋 ${sessionScope.loginMember.name}님</span></li>
                        <li class="nav-item"><a class="nav-link" href="/mypage">마이페이지</a></li>
                        <li class="nav-item"><a class="nav-link text-danger" href="/logout">로그아웃</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>