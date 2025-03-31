<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	// 로그인 되었는지 아닌지?
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
			
	if(staffId != null) { // 로그인 상태라면
		response.sendRedirect("/sakila/index.jsp");
		return;
	}

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<style>
 body {
    background: linear-gradient(to right, #ffcc99, #6699cc);
    font-family: 'Poppins', sans-serif;
    color: #3a3a3a;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    margin: 0;
    background-image: url('https://example.com/path/to/your/background-image.jpg');
    background-size: cover;
    background-position: center;
    animation: float 4s ease-in-out infinite;
  }


  h1 {
    font-size: 3rem;
    color: #ffffff;
    text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
    margin-bottom: 20px;
    font-family: 'Poppins', sans-serif;
    text-align: center;
  }

  table {
    border-collapse: collapse;
    width: 100%;
    background: rgba(255, 255, 255, 0.8);
    border-radius: 10px;
    padding: 20px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  }

  th {
    font-size: 1.2rem;
    padding: 10px;
    background-color: #ffcc66;
    color: #3a3a3a;
    text-align: center;
    border-radius: 5px;
  }

  td {
    padding: 10px;
    text-align: center;
    background-color: #fff;
    border-radius: 5px;
  }

  input[type="number"], input[type="password"] {
    width: 100%;
    padding: 10px;
    border: 2px solid #3a3a3a;
    border-radius: 5px;
    background-color: #f9f9f9;
    font-size: 1rem;
    box-sizing: border-box;
  }

  input[type="number"]:focus, input[type="password"]:focus {
    border-color: #ffcc66;
    outline: none;
  }

  button {
    width: 100%;
    padding: 10px;
    background-color: #ffcc66;
    border: none;
    border-radius: 5px;
    font-size: 1.2rem;
    cursor: pointer;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    transition: all 0.3s ease;
  }

  button:hover {
    background-color: #ffb84d;
    transform: scale(1.05);
  }
#login {
	width : 410px;
	height: 500px;
}
</style>
</head>
<body>
	
	<form action="/sakila/loginAction.jsp" method="post"> 
	<!-- 
	 a 태그랑 동일한 방식 loginAction.hsp?number= & password= -
	 매개값이 노출, 브라우저 주소창에 문자열 형태로 넘어간다 < 대신 길이가 제한
	 
	 데이터값을 매개값으로 다른 페이지로 전송하는 방법은
	 1) a 태그 : get 방식 ( 길이가 제한되고 노출)
	 2) form 태그의 method 속성은 : get 과 post( 길이가 제한되지않고 노출되지않는다)
	-->
	<div id = "login">
		<table border="1">
			<tr>
				<th>LOGIN</th>
				<td><input type="number" name="staffId">
			</tr>
			<tr>
				<th>PW</th>
				<td><input type="password" name="password">
			</tr>
		</table>
		<button type="submit">로그인</button>
	</div>
	</form>
</body>
</html>