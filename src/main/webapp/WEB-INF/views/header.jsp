<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <div class="container">
        <a class="navbar-brand fw-bold" href="/board/list">MyBoard</a>
        <div class="navbar-nav ms-auto">
            <c:choose>
                <c:when test="${not empty loginMemberName}">
                    <span class="nav-link text-white me-3">👤 ${loginMemberName}님</span>
                    <a class="nav-item nav-link" href="/board/mypage">마이페이지</a>
                    <a class="nav-item nav-link text-warning" href="javascript:void(0)" onclick="handleLogout()">로그아웃</a>
                </c:when>
                <c:otherwise>
                    <a class="nav-item nav-link" href="/board/login">로그인</a>
                    <a class="nav-item nav-link" href="/board/signup">회원가입</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<script>
    function handleLogout() {
        if(!confirm("로그아웃 하시겠습니까?")) return;
        document.cookie = "accessToken=; path=/; max-age=0";
        location.href = "/";
    }
</script>