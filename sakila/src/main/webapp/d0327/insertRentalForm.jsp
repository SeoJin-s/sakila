<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%
   // staff 로그인 session 확인
	Integer staffId = (Integer)session.getAttribute("loginStaff");
	
	if (staffId == null) { // 로그아웃 상태라면
		response.sendRedirect("/sakila/loginForm.jsp");
		return;
	}
   /*
      `rental_id` INT NOT NULL AUTO_INCREMENT,
      `rental_date` DATETIME NOT NULL, curdate() or now() or sysdate...
      `inventory_id` MEDIUMINT UNSIGNED NOT NULL, request
      `customer_id` SMALLINT UNSIGNED NOT NULL, 직접입력
      `return_date` DATETIME NULL DEFAULT NULL, null
      `staff_id` TINYINT UNSIGNED NOT NULL, session
   */
   Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
   Integer customerId = null;
   if(request.getParameter("customerId") != null) {
      // 이름검색 후 이 페이지가 다시 요청되면 customerId값을 받아 온다
      customerId = Integer.parseInt(request.getParameter("customerId"));
   }
   
   Connection conn = null;
   PreparedStatement stmt = null;
   ResultSet rs = null;
   String sql = "select i.inventory_id inventoryId,i.film_id filmId, f.title, i.store_id storeId from inventory i inner join film f on i.film_id=f.film_id  where inventory_id=?";
   Class.forName("com.mysql.cj.jdbc.Driver");
   conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
   stmt = conn.prepareStatement(sql);
   stmt.setInt(1, inventoryId);
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
        background-color: #f0f8ff;
        color: #444444;
        text-align: center;
    }

    h1 {
        color: #ff5733;
    }

    form {
        background-color: #e6f7ff;
        border-radius: 10px;
        padding: 20px;
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
        margin: 20px;
    }

    table {
        width: 100%;
        margin: 20px 0;
        border-collapse: collapse;
    }

    table, td {
        border: 2px solid #ff5733;
    }

    td {
        padding: 10px;
        text-align: left;
    }

    input[type="text"] {
        width: 100%;
        padding: 8px;
        border-radius: 5px;
        border: 1px solid #ff5733;
    }

    button {
        background-color: #ff5733;
        color: white;
        border: none;
        padding: 10px 20px;
        font-size: 16px;
        border-radius: 5px;
        cursor: pointer;
        margin: 5px;
    }

    button:hover {
        background-color: #c0392b;
    }

    input[type="text"]:readonly {
        background-color: #f2f2f2;
    }

    .button-container {
        display: flex;
        justify-content: center;
    }

    .button-container button {
        margin: 0 10px;
    }

    form input[type="text"] {
        background-color: #fff;
        border: 2px solid #f39c12;
    }

    input[type="text"]:focus {
        border-color: #f1c40f;
        box-shadow: 0 0 5px rgba(241, 196, 15, 0.7);
    }
</style>
</head>
	<body>
		<h1>Insert Rental Inventory</h1>
		<%
			if (rs.next()) {
		%>
			<form action="/sakila/d0327/searchCustomIdList.jsp" method="post">
				<input type="hidden" name="inventoryId" value='<%=inventoryId%>'>
				<input type="text" name="searchName">
				<button type="submit">이름으로 customerId검색</button>
			</form>
			<!--
				insertRentalForm.jsp -> 이름검색 -> SearchCustomerList.jsp -> insertRentalForm.jsp 
			 -->
			<form action="/sakila/d0327/insertRentalAction.jsp" method="post">
				<table border="1">
					<tr>
						<td>customerId</td>
						<td>
							<input type="text" name="customerId" value='<%=customerId%>' readonly>
						</td>
					</tr>
					<tr>
						<td>inventroyId</td>
						<td><input type="text" name="inventoryId" value='<%=inventoryId%>' readonly></td>
					</tr>
					<tr>
						<td>filmId</td>
						<td>
							<input type="text" name="filmId" value='<%=rs.getInt("filmId")%>' readonly> /
							<%=rs.getString("title")%>
						</td>
					</tr>
					<tr>
						<td>storeId</td>
						<td><input type="text" name="storeId" value='<%=rs.getInt("storeId")%>' readonly></td>
					</tr>
					<tr>
						<td>staffId</td>
						<td><input type="text" name="staffId" value='<%=staffId%>' readonly></td>
					</tr>
				</table>
				<button type="submit" name="action" value="rent">대여하기</button>
				<button type="submit" name="action" value="return">반납하기</button>
			</form>
		
		<%
			}
		%>
		
	</body>
</html>