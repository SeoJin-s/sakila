<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    Integer staffId = (Integer)(session.getAttribute("loginStaff"));
    
    if (staffId == null) {
        response.sendRedirect("/sakila/inventoryList.jsp");
        return;
    }

    String customerIdStr = request.getParameter("customerId");
    String activeStr = request.getParameter("active");
    
    if (customerIdStr == null || activeStr == null || customerIdStr.isEmpty() || activeStr.isEmpty()) {
        System.out.println("누락: customerIdStr=" + customerIdStr + ", activeStr=" + activeStr);
        response.sendRedirect("/sakila/d0327/inventoryList.jsp");
        return;
    }

    Integer customerId = Integer.parseInt(customerIdStr);
    Integer active = Integer.parseInt(activeStr);

    Connection conn = null;
    PreparedStatement stmt = null;

    Class.forName("com.mysql.cj.jdbc.Driver");

    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");

    String sql = "UPDATE customer SET ACTIVE = ? WHERE customer_id = ?";
    stmt = conn.prepareStatement(sql);

    if (active == 1) {
        stmt.setInt(1, 0);
    } else {
        stmt.setInt(1, 1);
    }

    stmt.setInt(2, customerId);

    int rowsAffected = stmt.executeUpdate();
    if (rowsAffected > 0) {
        System.out.println("업데이트 성공");
    } else {
        System.out.println("업데이트 실패");
    }

    if (stmt != null) {
        stmt.close();
    }
    if (conn != null) {
        conn.close();
    }

    response.sendRedirect("/sakila/d0327/inventoryList.jsp");
%>