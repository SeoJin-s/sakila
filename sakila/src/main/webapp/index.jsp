<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 로그인 되었는지 안되었는지 ?
	Integer staffId = (Integer)(session.getAttribute("loginStaff")); //int로 받으면 null값을 받을 수가 없다.
      if(session.getAttribute("loginStaff") == null) {
         response.sendRedirect("/sakila/loginForm.jsp");
            return;
      }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Index</title>
</head>
<body>
	<div>
		<%=staffId %>님 반갑습니다.
		<a href ="/sakila/logout.jsp">[로그아웃]</a>
		<a href ="/sakila/updatePasswordForm.jsp">[비밀번호 수정]</a>
	</div>
	
	<h1>Index</h1>
	<ol>
		<li><a href="/sakila/d0325/rentalList.jsp">대여 목록</a></li>
		<li><a href="/sakila/d0326/filmList.jsp">영화 목록</a></li>
		<li><a href="/sakila/d0326/actorList.jsp">출연자 목록</a></li>
		
		    <!--  3/27 : 인벤토리 리스트 + 영화제목 + 대여중 or 대여가능 -->
      <li><a href="/sakila/d0327/inventoryList.jsp">인벤토리 목록</a></li><!-- 3/27 -->
		
	</ol>
	
</body>
</html>