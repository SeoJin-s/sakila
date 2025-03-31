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
            background: linear-gradient(to right, #ffcc99, #6699cc);
            font-family: 'Poppins', sans-serif;
            color: #3a3a3a;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        h1 {
            font-size: 3rem;
            color: #ffffff;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
            margin-bottom: 20px;
            text-align: center;
        }

        table {
            border-collapse: collapse;
            width: 80%;
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

        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 2px solid #3a3a3a;
            border-radius: 5px;
            background-color: #f9f9f9;
            font-size: 1rem;
            box-sizing: border-box;
        }

        input[type="password"]:focus {
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