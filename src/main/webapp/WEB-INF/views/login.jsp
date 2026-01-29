<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
            transition: none !important;
        }
    </style>
    <script>
        /**
         * JWT 로그인을 위한 자바스크립트 처리 함수
         */
        async function handleLogin(event) {
            // 1. 폼의 기본 제출 동작(페이지 새로고침)을 막습니다.
            event.preventDefault();

            const loginId = document.getElementById('loginId').value;
            const password = document.getElementById('password').value;

            // 2. MemberRequestDTO 구조에 맞게 JSON 객체를 생성합니다.
            const loginData = {
                loginId: loginId,
                password: password
            };

            try {
                // 3. fetch를 이용해 서버에 JSON 데이터를 전송합니다.
                const response = await fetch('/board/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json' // 서버가 JSON임을 인지하게 함
                    },
                    body: JSON.stringify(loginData)
                });

                if (response.ok) {
                    const token = await response.text();

                    // 쿠키 저장 (Path를 /로 설정해야 전역에서 전송됨)
                    document.cookie = "accessToken=" + token + "; path=/; max-age=3600";

                    alert('로그인 성공!');
                    location.href = '/board/list';
                } else {
                    // 401 에러 등의 로그인 실패 처리
                    alert('아이디 또는 비밀번호를 확인해주세요.');
                }
            } catch (error) {
                console.error('Login Error:', error);
                alert('로그인 처리 중 오류가 발생했습니다.');
            }
        }
    </script>
</head>
<body>
<%@ include file="board/header.jsp" %>

<div class="container">
    <div class="card auth-card shadow-sm">
        <div class="card-body p-5">
            <h3 class="text-center fw-bold mb-4">로그인</h3>
            <form id="loginForm" onsubmit="handleLogin(event)">
                <div class="mb-3">
                    <label class="form-label small fw-bold">아이디</label>
                    <input type="text" id="loginId" class="form-control bg-light" placeholder="ID" required>
                </div>
                <div class="mb-4">
                    <label class="form-label small fw-bold">비밀번호</label>
                    <input type="password" id="password" class="form-control bg-light" placeholder="Password" required>
                </div>
                <button type="submit" class="btn btn-primary w-100 btn-auth">로그인</button>
            </form>
            <div class="text-center mt-4">
                <span class="text-muted small">계정이 없으신가요?</span>
                <a href="/board/signup" class="small fw-bold text-decoration-none ms-1">회원가입</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>