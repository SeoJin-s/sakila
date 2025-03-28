<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>

<%
    String password = request.getParameter("password");
    String newPassword = request.getParameter("newPassword");
    Integer staffId = (Integer) session.getAttribute("loginStaff");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    String sql = "UPDATE staff SET password = ? WHERE staff_id = ? AND password = ?";

    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");

    stmt = conn.prepareStatement(sql);
    stmt.setString(1, newPassword);
    stmt.setInt(2, staffId);
    stmt.setString(3, password);

    int rowsAffected = stmt.executeUpdate();

    if (rowsAffected > 0) {
        session.invalidate();
        response.sendRedirect("loginForm.jsp");  
    } else {
        System.out.println("실패");
    }

    if (stmt != null) stmt.close();
    if (conn != null) conn.close();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>

</head>
<body>

</body>
</html>