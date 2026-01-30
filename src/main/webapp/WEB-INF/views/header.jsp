<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<header class="p-3 mb-3 border-bottom bg-white shadow-sm">
    <div class="container d-flex justify-content-between align-items-center">
        <a href="javascript:void(0)" onclick="goMain()" class="fs-4 fw-bold text-dark text-decoration-none">My Board</a>

        <div id="authMenu" class="d-flex align-items-center">
        </div>
    </div>
</header>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        renderHeader();
    });

    function renderHeader() {
        const token = localStorage.getItem('accessToken') || getCookie('accessToken');
        const authMenu = document.getElementById('authMenu');

        if (token) {
            // 로그인 상태: 마이페이지와 로그아웃만 표시
            authMenu.innerHTML = `
            <a href="/board/mypage" class="btn btn-sm btn-outline-primary fw-bold me-2">마이페이지</a>
            <button onclick="handleLogout()" class="btn btn-sm btn-danger fw-bold">로그아웃</button>
        `;
        } else {
            // 비로그인 상태: 현재 경로가 홈이 아니라면 홈으로 리다이렉트 (보안)
            const path = window.location.pathname;
            if (path !== "/" && path !== "/board/login" && path !== "/board/signup" && path !== "/board/find-password") {
                location.href = "/";
            }
        }
    }

    function handleLogout() {
        // 쿠키와 로컬스토리지 모두 삭제
        document.cookie = "accessToken=; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT;";
        localStorage.removeItem('accessToken');
        alert("로그아웃 되었습니다.");
        location.href = "/";
    }

    function goMain() {
        const token = localStorage.getItem('accessToken') || getCookie('accessToken');
        location.href = token ? "/board/list" : "/";
    }

    function getCookie(name) {
        let value = "; " + document.cookie;
        let parts = value.split("; " + name + "=");
        if (parts.length === 2) return parts.pop().split(";").shift();
    }
</script>