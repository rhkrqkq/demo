<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head><title>게시판 목록</title></head>
<body>
<%@ include file="header.jsp" %>

<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">게시판 목록</h2>
        <a href="/board/write" class="btn btn-primary px-4">글쓰기</a>
    </div>

    <div class="table-responsive bg-white rounded shadow-sm">
        <table class="table table-hover mb-0">
            <thead class="table-light">
            <tr>
                <th class="ps-4">번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>날짜</th>
                <th class="text-center">조회수</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="board" items="${boards.content}">
                <tr>
                    <td class="ps-4 text-muted">${board.id}</td>
                    <td><a href="/board/view/${board.id}" class="text-decoration-none text-dark fw-bold">${board.title}</a></td>
                    <td>${board.writer}</td>
                    <td><small class="text-muted">${board.createdAt}</small></td>
                    <td class="text-center"><span class="badge bg-secondary rounded-pill">${board.hits}</span></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <form action="/board/list" method="get" class="row g-2 justify-content-center mt-4">
        <div class="col-md-4">
            <div class="input-group">
                <input type="text" name="keyword" class="form-control" placeholder="검색어를 입력하세요..." value="${param.keyword}">
                <button class="btn btn-dark" type="submit">검색</button>
            </div>
        </div>
    </form>
</div>
</body>
</html>