<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    Integer staffId = (Integer) session.getAttribute("loginStaff");
    if (staffId == null) {
        response.sendRedirect("/sakila/loginForm.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title></title>
  <style>
        body {
            font-family: 'Comic Sans MS', cursive, sans-serif;
            background-color: #ffefb4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            background-color: #fff;
            padding: 30px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 15px;
            width: 400px;
            text-align: center;
            border: 3px solid #e7a712;
        }

        h1 {
            color: #e7a712;
            font-size: 30px;
            margin-bottom: 20px;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
        }

        table {
            width: 100%;
            margin-bottom: 20px;
        }

        th {
            font-size: 18px;
            color: #d45d29;
            text-align: left;
            padding-right: 10px;
        }

        td {
            padding: 10px;
        }

        input[type="password"] {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: 2px solid #d45d29;
            border-radius: 8px;
            font-size: 16px;
            background-color: #fff;
            color: #333;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #e7a712;
            border: none;
            color: white;
            font-size: 18px;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #d18711;
        }
    </style>
</head>
<body>

    <h1></h1>
    
    <form action="/sakila/updatePasswordAction.jsp" method="post">
        <table>
            <tr>
                <th>현재 비밀번호</th>
                <td><input type="password" name="password" required></td>
            </tr>
            <tr>
                <th>새 비밀번호</th>
                <td><input type="password" id="newPassword" name="newPassword" required></td>
            </tr>
         
        </table>
 		<button type="submit">수정</button>
    </form>

</body>
</html>