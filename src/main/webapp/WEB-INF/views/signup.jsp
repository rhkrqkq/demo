<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><title>회원가입</title></head>
<body>
<%@ include file="board/header.jsp" %>
<h2>회원가입</h2>
<form action="/signup" method="post">
    <p>아이디: <input type="text" name="loginId" required></p>
    <p>비밀번호: <input type="password" name="password" required></p>
    <p>이름: <input type="text" name="name" required></p>
    <button type="submit">가입하기</button>
</form>
</body>
</html>