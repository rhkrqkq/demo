<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입 - My Board</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .auth-card {
            max-width: 450px;
            margin: 80px auto;
            border: none;
            border-radius: 15px;
        }
        .form-control { padding: 0.75rem; border-radius: 10px; border: 1px solid #dee2e6; }
        .btn-auth { padding: 0.75rem; font-weight: bold; border-radius: 10px; }
    </style>
</head>
<body>

<div class="container">
    <div class="card auth-card shadow-sm">
        <div class="card-body p-5">
            <h3 class="text-center fw-bold mb-4">회원가입</h3>
            <p class="text-muted small text-center mb-4">나만의 지식 공간, My Board에 오신 것을 환영합니다.</p>

            <form action="/board/signup" method="post">
                <div class="mb-3">
                    <label class="form-label small fw-bold">아이디</label>
                    <input type="text" name="loginId" class="form-control bg-light" placeholder="사용할 ID를 입력하세요" required>
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-bold">비밀번호</label>
                    <input type="password" name="password" class="form-control bg-light" placeholder="비밀번호를 입력하세요" required>
                </div>
                <div class="mb-4">
                    <label class="form-label small fw-bold">이름</label>
                    <input type="text" name="name" class="form-control bg-light" placeholder="이름을 입력하세요" required>
                </div>
                <button type="submit" class="btn btn-primary w-100 btn-auth shadow-sm">가입하기</button>
            </form>

            <div class="text-center mt-4">
                <span class="text-muted small">이미 계정이 있으신가요?</span>
                <a href="/board/login" class="small fw-bold text-decoration-none ms-1">로그인</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>