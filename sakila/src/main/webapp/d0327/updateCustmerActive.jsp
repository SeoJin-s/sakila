<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@ page import="java.sql.*" %>
 <%
 	
 	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
 			
 	if(staffId == null) { 
 		response.sendRedirect("/sakila/loginForm.jsp");
 		return;
 	}
 	
 	Integer customerId = Integer.parseInt(request.getParameter("customerId"));
 	
 	Connection conn = null;
 	PreparedStatement stmt = null;
 	Class.forName("com.mysql.cj.jdbc.Driver");
 	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
 	String sql = "UPDATE customer SET active = 1 WHERE active = 0 and customer_id = ?;";
 	stmt = conn.prepareStatement(sql);
 	stmt.setInt(1, customerId);
 	 
 	stmt.executeUpdate();
 	 
 	response.sendRedirect("/sakila/d0327/inventoryList.jsp");
 %>