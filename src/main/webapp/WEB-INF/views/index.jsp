<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Board Service</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .hero-section {
            padding: 100px 0;
            background: white;
            border-bottom: 1px solid #dee2e6;
            margin-bottom: 50px;
        }
        .feature-card {
            border: none;
            border-radius: 15px;
            transition: transform 0.2s;
        }
        .feature-card:hover { transform: translateY(-5px); }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="/">My Board</a>
        <div class="d-flex">
            <a href="/board/login" class="btn btn-outline-primary me-2">로그인</a>
            <a href="/board/signup" class="btn btn-primary">시작하기</a>
        </div>
    </div>
</nav>

<header class="hero-section text-center">
    <div class="container">
        <h1 class="display-4 fw-bold mb-3">함께 나누는 지식 공간</h1>
        <p class="lead text-muted mb-4">지금 바로 시작하여 다양한 게시글을 확인하고 의견을 나누어보세요.</p>
        <div class="d-flex justify-content-center gap-3">
            <a href="/board/signup" class="btn btn-primary btn-lg px-5 shadow-sm">무료로 시작하기</a>
            <a href="/board/login" class="btn btn-light btn-lg px-5 border">기존 계정으로 로그인</a>
        </div>
    </div>
</header>

<main class="container mb-5">
    <div class="row g-4 text-center">
        <div class="col-md-4">
            <div class="card h-100 shadow-sm feature-card p-4">
                <div class="card-body">
                    <h5 class="fw-bold mb-3">자유로운 게시판</h5>
                    <p class="text-muted small">누구나 자유롭게 글을 작성하고 소통할 수 있는 공간을 제공합니다.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100 shadow-sm feature-card p-4">
                <div class="card-body">
                    <h5 class="fw-bold mb-3">실시간 댓글 소통</h5>
                    <p class="text-muted small">게시글에 대한 다양한 의견을 실시간으로 주고받으며 통찰을 얻으세요.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100 shadow-sm feature-card p-4">
                <div class="card-body">
                    <h5 class="fw-bold mb-3">관심글 북마크</h5>
                    <p class="text-muted small">나중에 다시 보고 싶은 유익한 글은 북마크 기능을 통해 따로 보관하세요.</p>
                </div>
            </div>
        </div>
    </div>
</main>

<footer class="py-4 bg-white border-top mt-auto">
    <div class="container text-center text-muted small">
        &copy; 2026 My Board Service. All rights reserved.
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 이미 로그인한 상태라면 홈을 건너뛰고 리스트로 이동
    document.addEventListener("DOMContentLoaded", function() {
        if (localStorage.getItem('accessToken')) {
            location.href = '/board/list';
        }
    });
</script>
</body>
</html>