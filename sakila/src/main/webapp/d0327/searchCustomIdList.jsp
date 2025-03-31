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
							<a href='/sakila/d0327/updateCustmerActive.jsp'>
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