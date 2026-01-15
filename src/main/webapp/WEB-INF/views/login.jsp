<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <style>
        body { background-color: #f8f9fa; }
        .auth-card {
            max-width: 400px;
            margin: 100px auto;
            border: none;
            border-radius: 15px;
        }
        .form-control { padding: 0.75rem; border-radius: 10px; }
        .btn-auth {
            padding: 0.75rem;
            font-weight: bold;
            border-radius: 10px;
            transition: none !important; /* 효과 제거 */
        }
    </style>
</head>
<body>
<%@ include file="board/header.jsp" %>

<div class="container">
    <div class="card auth-card shadow-sm">
        <div class="card-body p-5">
            <h3 class="text-center fw-bold mb-4">로그인</h3>
            <form action="/login" method="post">
                <div class="mb-3">
                    <label class="form-label small fw-bold">아이디</label>
                    <input type="text" name="loginId" class="form-control bg-light" placeholder="ID" required>
                </div>
                <div class="mb-4">
                    <label class="form-label small fw-bold">비밀번호</label>
                    <input type="password" name="password" class="form-control bg-light" placeholder="Password" required>
                </div>
                <button type="submit" class="btn btn-primary w-100 btn-auth">로그인</button>
            </form>
            <div class="text-center mt-4">
                <span class="text-muted small">계정이 없으신가요?</span>
                <a href="/signup" class="small fw-bold text-decoration-none ms-1">회원가입</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>