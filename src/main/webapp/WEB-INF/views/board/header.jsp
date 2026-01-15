<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header style="padding: 10px; background: #f4f4f4; border-bottom: 1px solid #ddd; margin-bottom: 20px;">
    <a href="/board/list" style="font-weight: bold; font-size: 1.2em; text-decoration: none; color: black;">내 게시판</a>

    <div style="float: right;">
        <c:choose>
            <c:when test="${empty sessionScope.loginMember}">
                <a href="/login">로그인</a> | <a href="/signup">회원가입</a>
            </c:when>
            <c:otherwise>
                <strong>${sessionScope.loginMember.name}님</strong> 환영합니다! |
                <a href="/mypage" style="font-weight: bold; color: #007bff;">마이페이지</a> |
                <a href="/logout">로그아웃</a>
            </c:otherwise>
        </c:choose>
    </div>
    <div style="clear: both;"></div>
</header>