<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><title>로그인</title></head>
<body>
<%@ include file="board/header.jsp" %>
<h2>로그인</h2>
<form action="/login" method="post">
    <p>아이디: <input type="text" name="loginId" required></p>
    <p>비밀번호: <input type="password" name="password" required></p>
    <button type="submit">로그인</button>
</form>
</body>
</html>