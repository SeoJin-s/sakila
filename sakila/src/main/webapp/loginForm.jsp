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
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&family=Winky+Sans:ital,wght@0,300..900;1,300..900&display=swap');

* { 
  margin: 0; 
  padding: 0; 
  box-sizing: border-box; 
}

body {
  font-family: "Noto Sans KR", sans-serif;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background-color: #fff; 
  color: #333; 
}

.login-container {
  background-color: rgba(0, 0, 0, 0.7); 
  padding: 50px 40px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.5); 
  width: 100%;
  max-width: 1000px;
  text-align: center;
}

h1 {
  font-size: 2.5rem;
  margin-bottom: 30px;
  color: #ff6600; 
  font-weight: bold;
}

input[type="number"], input[type="password"] {
  width: 100%;
  padding: 15px;
  margin: 15px 0;
  border-radius: 10px;
  border: 1px solid #ccc; 
  background-color: #f8f8f8; 
  color: #333;
  font-size: 1.2rem;
}

input[type="number"]:focus, input[type="password"]:focus {
  outline: none;
  border: 2px solid #ff6600; 
}

button {
  width: 100%;
  padding: 15px;
  background-color: #ff6600; 
  color: white;
  border: none;
  border-radius: 10px;
  font-size: 1.5rem;
  cursor: pointer;
  transition: background-color 0.3s;
}

button:hover {
  background-color: #ff4500; 
}

button:active {
  background-color: #e64a19; 
}

footer {
  margin-top: 20px;
  font-size: 0.9rem;
  color: #888;
}

footer a {
  color: #ff6600; 
  text-decoration: none;
}

footer a:hover {
  text-decoration: underline;
}


th {
  background-color: #ff6600; 
  color: white; 
  padding: 15px 25px; 
  font-weight: bold;
  text-align: center;
}
</style>
</head>
<body>
	<h1>로그인</h1>
	<form action="/sakila/loginAction.jsp">
		<table border="1">
			<tr>
				<th>로그인</th>
				<td><input type="number" name="staffId">
			</tr>
			<tr>
				<th>비밀번호</th>
				<td><input type="password" name="password">
			</tr>
		</table>
		<button type="submit">로그인</button>
	</form>
</body>
</html>