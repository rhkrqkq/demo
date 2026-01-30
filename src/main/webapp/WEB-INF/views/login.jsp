<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow-sm border-0 p-4">
                <h2 class="text-center fw-bold mb-4">로그인</h2>
                <div class="mb-3">
                    <label for="loginId" class="form-label">아이디</label>
                    <input type="text" id="loginId" class="form-control" placeholder="아이디를 입력하세요">
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">비밀번호</label>
                    <input type="password" id="password" class="form-control" placeholder="비밀번호를 입력하세요">
                </div>
                <button onclick="handleLogin()" class="btn btn-primary w-100 py-2 fw-bold">로그인</button>
                <div class="text-center mt-3">
                    <a href="/board/signup" class="text-decoration-none small text-muted">계정이 없으신가요? 회원가입</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    async function handleLogin() {
        const loginId = document.getElementById('loginId').value;
        const password = document.getElementById('password').value;

        if (!loginId || !password) {
            alert("아이디와 비밀번호를 모두 입력해주세요.");
            return;
        }

        try {
            const res = await fetch('/api/member/login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ loginId, password })
            });

            if (res.ok) {
                const token = await res.text(); // json()이 아니라 text()로 받아야 안전합니다.

                // 쿠키 저장 (이름: accessToken)
                document.cookie = "accessToken=" + token + "; path=/; max-age=3600";

                location.href = '/board/list';
            } else {
                alert("아이디 또는 비밀번호를 확인해주세요.");
            }
        } catch (error) {
            alert("서버 연결에 실패했습니다.");
        }
    }
</script>
</body>
</html>