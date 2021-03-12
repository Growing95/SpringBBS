<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div id="wrap">
		<div id="header">
			<span class="title2">KGGUC게시판</pan>
		</div>
		<div id="nav">
			<div id="login">
				<c:choose>
					<c:when test="${login =='ok' }">
						${mvo.name  }님 환영합니다. |<a href="logout.do"> 로그아웃</a>
					</c:when>
					<c:otherwise>
					<a href="login.do">로그인</a>|<a href="join.do">회원가입</a>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</body>
</html>