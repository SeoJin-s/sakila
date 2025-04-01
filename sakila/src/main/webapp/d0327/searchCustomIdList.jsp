<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%
	//로그인 session 검증
	Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
	String searchName = request.getParameter("searchName");
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "select customer_id customerId, first_name firstName, last_name lastName, email, active from customer where concat(first_name, last_name) like?";
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, "%"+ searchName + "%");
	System.out.println(stmt);
	rs = stmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<style>
    body {
        font-family: 'Arial', sans-serif;
        background-color: #f4faff;
        color: #4a4a4a;
        text-align: center;
        padding: 20px;
    }

    h1 {
        color: #ff6f00;
    }

    table {
        width: 100%;
        margin-top: 20px;
        border-collapse: collapse;
        background-color: #ffffff;
        box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    }

    table, th, td {
        border: 2px solid #ff6f00;
    }

    th, td {
        padding: 12px;
        text-align: center;
    }

    th {
        background-color: #ffeb3b;
        color: #d32f2f;
    }

    td {
        background-color: #fff3e0;
    }

    tr:nth-child(even) td {
        background-color: #ffcc80;
    }

    a {
        color: #ff6f00;
        font-weight: bold;
        text-decoration: none;
        padding: 5px;
        border-radius: 5px;
    }

    a:hover {
        background-color: #ff7043;
        color: white;
    }

    .inactive {
        background-color: #f44336;
        color: white;
    }

    .active {
        background-color: #388e3c;
        color: white;
    }

    input[type="text"] {
        padding: 8px;
        width: 250px;
        border-radius: 5px;
        border: 1px solid #ff6f00;
        margin-top: 20px;
        margin-bottom: 20px;
    }

    button {
        background-color: #ff6f00;
        color: white;
        padding: 10px 20px;
        font-size: 16px;
        border-radius: 5px;
        cursor: pointer;
    }

    button:hover {
        background-color: #f57c00;
    }

</style>
</head>
<body>1
	<table border ="1">
		<tr>
			<td>customerId</td>
			<td>firstName</td>
			<td>lastName</td>
			<td>email</td>
			<td>active</td>
			<td>선택</td>
		</tr>
		<%
			while(rs.next()) {
		%>
			<tr>
				<td><%= rs.getInt("customerId") %></td>
				<td><%= rs.getString("firstName") %></td>
				<td><%= rs.getString("lastName") %></td>
				<td><%= rs.getString("email") %></td>
				<td><%= rs.getInt("active") %></td>
				<td>
					<%
						if(rs.getInt("active") == 0) {
					%>
							<a href='/sakila/d0327/updateCustmerActive.jsp?customerId=<%= rs.getInt("customerId") %>'>
							휴면 상태 해지	<!-- customer.active 0을 1로 변경 -->
							</a> 
					<%
						} else {
					%>
						<a href='/sakila/d0327/insertRentalForm.jsp?customerId=<%= rs.getInt("customerId") %>&inventoryId=<%=inventoryId%>'>
						선택
						</a>
					<%
						}
					%>
				</td>	
			</tr>
		<% 		
			}
		%>
	</table>
</body>
</html>