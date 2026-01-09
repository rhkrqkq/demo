<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header style="background: #f4f4f4; padding: 10px; margin-bottom: 20px;">
    <h1><a href="/board/list" style="text-decoration: none; color: black;">My Spring Board</a></h1>
    <div style="text-align: right;">
        <c:choose>
            <%-- 세션에 loginMember가 없으면 로그인/회원가입 표시 --%>
            <c:when test="${empty sessionScope.loginMember}">
                <a href="/login">로그인</a> | <a href="/signup">회원가입</a>
            </c:when>
            <%-- 세션에 정보가 있으면 환영 메시지와 로그아웃 표시 --%>
            <c:otherwise>
                <span><strong>${sessionScope.loginMember.name}</strong>님 환영합니다.</span>
                <a href="/logout">로그아웃</a>
            </c:otherwise>
        </c:choose>
    </div>
    <hr>
</header>