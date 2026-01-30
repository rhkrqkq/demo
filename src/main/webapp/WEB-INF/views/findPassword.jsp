<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container" style="max-width: 400px; margin-top: 100px;">
    <div class="card shadow-sm border-0 p-4">
        <h3 class="text-center fw-bold mb-4">비밀번호 찾기</h3>
        <form id="findForm">
            <div class="mb-3">
                <label class="form-label">가입한 아이디</label>
                <input type="text" id="loginId" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary w-100">임시 비밀번호 발급</button>
        </form>
        <div id="resultArea" class="mt-4 d-none alert alert-info text-break"></div>
        <div class="text-center mt-3"><a href="/board/login" class="small text-decoration-none">로그인으로 돌아가기</a></div>
    </div>
</div>

<script>
    document.getElementById('findForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        const loginId = document.getElementById('loginId').value;
        const res = await fetch('/api/member/find-password', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ loginId })
        });
        const msg = await res.text();
        const area = document.getElementById('resultArea');
        area.innerHTML = res.ok ? "임시 비밀번호: <b>" + msg + "</b><br>로그인 후 즉시 변경하세요." : "오류: " + msg;
        area.classList.remove('d-none');
    });
</script>
</body>
</html>