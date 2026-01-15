<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <style>
        body { background-color: #f8f9fa; }
        .auth-card {
            max-width: 400px;
            margin: 80px auto;
            border: none;
            border-radius: 15px;
        }
        .form-control { padding: 0.75rem; border-radius: 10px; }
        /* 버튼 효과 완전 제거 */
        .btn-auth {
            padding: 0.75rem;
            font-weight: bold;
            border-radius: 10px;
            transition: none !important;
        }
        .btn-auth:hover, .btn-auth:focus, .btn-auth:active {
            background-color: #0d6efd !important; /* 기본 파란색 유지 */
            border-color: #0d6efd !important;
            box-shadow: none !important;
            transform: none !important;
        }
    </style>
</head>
<body>
<%@ include file="board/header.jsp" %>

<div class="container">
    <div class="card auth-card shadow-sm">
        <div class="card-body p-5">
            <h3 class="text-center fw-bold mb-4">회원가입</h3>
            <form action="/signup" method="post">
                <div class="mb-3">
                    <label class="form-label small fw-bold">아이디</label>
                    <input type="text" name="loginId" class="form-control bg-light" placeholder="ID" required>
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-bold">비밀번호</label>
                    <input type="password" name="password" class="form-control bg-light" placeholder="Password" required>
                </div>
                <div class="mb-4">
                    <label class="form-label small fw-bold">이름(닉네임)</label>
                    <input type="text" name="name" class="form-control bg-light" placeholder="Name" required>
                </div>
                <button type="submit" class="btn btn-primary w-100 btn-auth">회원가입 완료</button>
            </form>
            <div class="text-center mt-4">
                <a href="/login" class="small text-muted text-decoration-none">이미 계정이 있나요? 로그인</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>