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
<title>목록</title>
<style>
    /* 전체 페이지를 중앙 정렬 */
    body {
        font-family: 'Arial', sans-serif;
        background-color: #f9fbe7;
        color: #4a4a4a;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        text-align: center;
    }

    h1 {
        color: #ff6f00;
        font-size: 2.5em;
        margin: 0;
    }

    /* div 스타일을 상단 중앙으로 */
    div {
        position: absolute;
        top: 20px;
        left: 50%;
        transform: translateX(-50%);
        text-align: center;
        width: 100%;
    }

    a {
        color: #ff6f00;
        text-decoration: none;
        font-weight: bold;
        margin-left: 15px;
        padding: 5px 10px;
        border-radius: 5px;
    }

    a:hover {
        background-color: #ff7043;
        color: white;
    }

    ol {
        font-size: 1.2em;
        line-height: 1.6;
        padding-left: 20px;
    }

    ol li {
        margin: 10px 0;
    }

    ol li a {
        color: #ff6f00;
        font-weight: bold;
        text-decoration: none;
    }

    ol li a:hover {
        text-decoration: underline;
    }

    .header {
        font-size: 1.5em;
        color: #d32f2f;
        margin-bottom: 10px;
    }
</style>
</head>
<body>
	<div>
		<%=staffId %>님 반갑습니다.
		<a href ="/sakila/logOut.jsp">[로그아웃]</a>
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