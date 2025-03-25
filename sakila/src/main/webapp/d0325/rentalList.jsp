<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>

<%
    String searchWord = request.getParameter("searchWord");
    if (searchWord == null) {
        searchWord = "";
    }
    System.out.println("searchWord: " + searchWord);

    int currentPage = 1;
    if (request.getParameter("currentPage") != null) {
        currentPage = Integer.parseInt(request.getParameter("currentPage"));
    }
    int rowPerPage = 10;
    int startRow = (currentPage - 1) * rowPerPage;

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");

    String countSql = "SELECT COUNT(*) AS cnt " +
			          "FROM rental r " +
			          "JOIN inventory i ON r.inventory_id = i.inventory_id " +
			          "JOIN film f ON i.film_id = f.film_id " +
			          "JOIN customer c ON r.customer_id = c.customer_id " +
			          "WHERE f.title LIKE ?";


    PreparedStatement countStmt = conn.prepareStatement(countSql);
    countStmt.setString(1, "%" + searchWord + "%");
    ResultSet countRs = countStmt.executeQuery();

    int totalCnt = 0;
    if (countRs.next()) {
        totalCnt = countRs.getInt("cnt");
    }

    int lastPage = totalCnt / rowPerPage;
    if (totalCnt % rowPerPage != 0) {
        lastPage = lastPage + 1;
    }

    int pageGroupSize = 10;
    int currentGroup = (currentPage - 1) / pageGroupSize;
    int startPage = currentGroup * pageGroupSize + 1;
    int endPage = Math.min(startPage + pageGroupSize - 1, lastPage);

    String sql = "SELECT " +
            "r.rental_id AS rentalId, " +
            "f.title AS filmTitle, " +
            "r.inventory_id AS inventoryId, " +
            "CONCAT(COALESCE(c.first_name, ''), ' ', COALESCE(c.last_name, '')) AS customerId, " +  
            "r.rental_date AS rentalDate, " +
            "COALESCE(r.return_date, NOW()) AS returnDate " +
            "FROM rental r " +
            "JOIN inventory i ON r.inventory_id = i.inventory_id " +
            "JOIN film f ON i.film_id = f.film_id " +
            "JOIN customer c ON r.customer_id = c.customer_id " +
            "WHERE f.title LIKE ? " +
            "ORDER BY r.rental_date ASC " +
            "LIMIT ?, ?";

    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setString(1, "%" + searchWord + "%");
    stmt.setInt(2, startRow);
    stmt.setInt(3, rowPerPage);

    ResultSet rs = stmt.executeQuery();

    HashMap<String, Object> resultMap = new HashMap<>();

    List<HashMap<String, Object>> rentalRecords = new ArrayList<>();

    while (rs.next()) {
        HashMap<String, Object> rentalRecord = new HashMap<>();
        rentalRecord.put("rentalId", rs.getObject("rentalId"));
        rentalRecord.put("filmTitle", rs.getObject("filmTitle"));
        rentalRecord.put("inventoryId", rs.getObject("inventoryId"));
        rentalRecord.put("customerId", rs.getObject("customerId"));
        rentalRecord.put("rentalDate", rs.getObject("rentalDate"));
        rentalRecord.put("returnDate", rs.getObject("returnDate"));

        rentalRecords.add(rentalRecord);
    }

    resultMap.put("rentalRecords", rentalRecords);
    resultMap.put("totalCnt", totalCnt);
    resultMap.put("currentPage", currentPage);
    resultMap.put("lastPage", lastPage);
    resultMap.put("startPage", startPage);
    resultMap.put("endPage", endPage);

    request.setAttribute("resultMap", resultMap);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<style>
			body {
			    background-color: #0d0d0d;
			    color: #e0e0e0;
			    font-family: 'Verdana', sans-serif;
			    margin: 0;
			    padding: 0;
			    display: flex;
			    justify-content: center;
			    align-items: center;
			    height: 100vh;
			    flex-direction: column;
			}
			
			.element-strange {
			    border-radius: 20px;
			    border: 2px solid #0f4c75;
			    width: 250px;
			    height: 250px;
			    margin: 20px auto;
			    display: flex;
			    justify-content: center;
			    align-items: center;
			    background-color: #1c1c1c;
			    box-shadow: 0 4px 20px rgba(15, 76, 117, 0.7);
			    position: relative;
			    animation: strangeChaos 5s infinite alternate;
			}
			
			@keyframes strangeChaos {
			    0% {
			        transform: scale(1);
			        box-shadow: 0 4px 20px rgba(15, 76, 117, 0.5);
			        filter: blur(0);
			    }
			    50% {
			        transform: scale(1.05);
			        box-shadow: 0 8px 40px rgba(0, 204, 255, 0.8);
			        filter: blur(5px);
			        background-color: #171717;
			    }
			    100% {
			        transform: scale(1.1);
			        box-shadow: 0 12px 60px rgba(75, 0, 130, 0.9);
			        filter: blur(10px);
			        background-color: #1f1f1f;
			    }
			}
			
			h1 {
			    color: #0f4c75;
			    font-family: 'Arial', sans-serif;
			    font-size: 48px;
			    margin-bottom: 20px;
			    text-shadow: 3px 3px 6px rgba(0, 204, 255, 0.6);
			    animation: textPulse 4s infinite alternate;
			}
			
			@keyframes textPulse {
			    0% {
			        text-shadow: 3px 3px 6px rgba(0, 204, 255, 0.6);
			        transform: scale(1);
			    }
			    50% {
			        text-shadow: 6px 6px 12px rgba(75, 0, 130, 0.8);
			        transform: scale(1.1);
			    }
			    100% {
			        text-shadow: 3px 3px 6px rgba(255, 105, 180, 0.8);
			        transform: scale(1);
			    }
			}
			
			button {
			    padding: 14px 28px;
			    background-color: #0f4c75;
			    border: none;
			    color: white;
			    font-size: 18px;
			    font-weight: bold;
			    cursor: pointer;
			    border-radius: 30px;
			    transition: background-color 0.3s ease, transform 0.2s ease;
			    box-shadow: 0 4px 8px rgba(15, 76, 117, 0.3);
			}
			
			button:hover {
			    background-color: #0a3e58;
			    transform: scale(1.1);
			}
			
			.pagination {
			    display: flex;
			    justify-content: center;
			    align-items: center;
			    gap: 20px;
			    margin-top: 30px;
			}
			
			.pagination button {
			    padding: 12px 24px;
			    background-color: #0f4c75;
			    border: none;
			    color: white;
			    font-size: 16px;
			    font-weight: bold;
			    cursor: pointer;
			    border-radius: 25px;
			    transition: background-color 0.3s ease, transform 0.2s ease;
			}
			
			.pagination button:hover {
			    background-color: #0a3e58;
			    transform: scale(1.1);
			}
			
			table {
			    border-collapse: separate;
			    border-radius: 12px;
			    overflow: hidden;
			    width: 80%;
			    margin-top: 20px;
			    background-color: #333;
			    box-shadow: 0 6px 12px rgba(15, 76, 117, 0.3);
			}
			
			table, th, td {
			    border: 2px solid #0f4c75;
			}
			
			th, td {
			    padding: 15px;
			    text-align: center;
			    font-size: 16px;
			    color: #f0f0f0;
			}
			
			th {
			    background-color: #0f4c75;
			    color: white;
			}
			
			td {
			    background-color: #2b2b2b;
			}
			
			#id {
			    color: #0f4c75;
			}
</style>
<body>
    <h1>Rental List</h1>
    <form action="/sakila/d0325/rentalList.jsp">
        Store: 
        <select name="storeId">
            <option value="0">All</option>
            <option value="1">Store 1</option>
            <option value="2">Store 2</option>
        </select>
        <button type="submit">Search</button>
    </form>

    <table border="1" id="table1">
        <tr>
            <th>Rental ID</th>
            <th>Film Title</th>
            <th>Inventory ID</th>
            <th>Customer Name (Customer ID)</th>
            <th>Rental Date</th>
            <th>Return Date</th>
        </tr>

        <%
        	for (HashMap<String, Object> record : rentalRecords) {
        %>
            <tr>
                <td><%= record.get("rentalId") %></td>
                <td><%= record.get("filmTitle") %></td>
                <td><%= record.get("inventoryId") %></td>
                <td><%= record.get("customerId") %></td>
                <td><%= record.get("rentalDate") %></td>
                <td><%= record.get("returnDate") %></td>
            </tr>
        <%
        }
        %>    
    </table>

    <form action="/sakila/d0325/rentalList.jsp">
        Film Title Search:
        <input type="text" name="searchWord" value="<%= searchWord %>">
        <button type="submit">Search</button>
    </form>

    <div id="page">
        <%= "Current Page: " + resultMap.get("currentPage") %>
        <%= " / " + "Last Page: " + resultMap.get("lastPage") %>
    </div>
    
    <div id="pagination">
    	<a href="/sakila/d0325/rentalList.jsp?currentPage=1&searchWord=<%= searchWord %>"> [처음]</a>
    	<%
    		if (currentPage > 1) { %>
    	<a href='/sakila/d0325/rentalList.jsp?searchWord=<%= searchWord %>&currentPage=<%= currentPage -1 %>'>[이전]</a>
    	<% } %>
    
    	<%
        for (int i = startPage; i <= endPage; i++) {
            if (i == currentPage) {
    	%>
               <strong><%= i %></strong> 
        <% 
            } else { 
         %>
        <a href='/sakila/d0325/rentalList.jsp?searchWord=<%= searchWord %>&currentPage=<%= i %>'><%= i %></a>
         <%
            }
        }
      %>
      <% if (currentPage < lastPage) { %>
    <a href='/sakila/d0325/rentalList.jsp?searchWord=<%= searchWord %>&currentPage=<%= currentPage + 1 %>'>[이전]</a>
    <% } %>	
    	<a href='/sakila/d0325/rentalList.jsp?searchWord=<%= searchWord %>&currentPage=<%= lastPage %>'>[마지막]</a>
    </div>
</body>
</html>