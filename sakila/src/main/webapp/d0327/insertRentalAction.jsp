<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!-- Controller -->
<%
	//로그인 되었는지 아닌지?
	Integer staffId = (Integer)session.getAttribute("loginStaff");
	
	if (staffId == null) { // 로그아웃 상태라면
		response.sendRedirect("/sakila/loginForm.jsp");
		return;
	}
	
	Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
	Integer customerId = Integer.parseInt(request.getParameter("customerId"));
%>

<!-- Model -->
<%
	Connection conn = null;
	PreparedStatement stmt = null;
	String sql = "INSERT INTO rental(rental_date, inventory_id, customer_id, staff_id) VALUES (now(), ?, ?, ?)";
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, inventoryId);
	
	stmt.setInt(2, customerId);
	stmt.setInt(3, staffId);
	System.out.println(stmt);
    int rowsAffected = stmt.executeUpdate();  // 재고 상태 업데이트

    // 결과 처리
    if (rowsAffected > 0) {
        out.println("<h3>대여 등록 완료</h3>");
        response.setHeader("Refresh", "2; URL=inventoryList.jsp");  // 2초 후 리다이렉트
    } else {
        out.println("<h3>대여 등록 실패</h3>");
    }

    // 리소스 해제
    if (stmt != null) stmt.close();
    if (conn != null) conn.close();
%>