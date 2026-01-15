<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <style>
        .container { max-width: 900px; margin: 0 auto; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f8f9fa; }
        .title-box { background: #eee; padding: 10px; margin: 20px 0 10px 0; border-left: 5px solid #333; }
    </style>
</head>
<body>
<%@ include file="board/header.jsp" %>

<div class="container">
    <h2>마이페이지</h2>
    <p>안녕하세요, <strong>${sessionScope.loginMember.name}</strong>님의 활동 내역입니다.</p>

    <div class="title-box"><h3>내가 작성한 게시글</h3></div>
    <table>
        <thead>
        <tr>
            <th>번호</th>
            <th>제목</th>
            <th>조회수</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="post" items="${myPosts}">
            <tr>
                <td>${post.id}</td>
                <td><a href="/board/view/${post.id}">${post.title}</a></td>
                <td>${post.hits}</td>
            </tr>
        </c:forEach>
        <c:if test="${empty myPosts}">
            <tr><td colspan="3" style="text-align:center;">작성한 게시글이 없습니다.</td></tr>
        </c:if>
        </tbody>
    </table>

    <div class="title-box"><h3>내가 작성한 댓글</h3></div>
    <table>
        <thead>
        <tr>
            <th>댓글 내용</th>
            <th>작성일</th>
            <th>이동</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="comment" items="${myComments}">
            <tr>
                <td>${comment.content}</td>
                <td>${comment.createdAt}</td>
                <td><a href="/board/view/${comment.boardId}">원문보기</a></td>
            </tr>
        </c:forEach>
        <c:if test="${empty myComments}">
            <tr><td colspan="3" style="text-align:center;">작성한 댓글이 없습니다.</td></tr>
        </c:if>
        </tbody>
    </table>
</div>
</body>
</html>