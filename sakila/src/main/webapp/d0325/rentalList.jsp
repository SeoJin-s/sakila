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
.element {
    border-radius: 40px;  /* 요소의 모서리를 40px 반지름으로 둥글게 만듬 */
    border: 2px solid black; /* 검정색 2px 실선 테두리 */
    width: 200px;  /* 요소의 너비를 200px로 설정 */
    height: 200px;  /* 요소의 높이를 200px로 설정 */
    margin: 20px auto;  /* 요소를 수평으로 가운데 정렬, 위 아래에 20px 여백 추가 */
    display: flex;  /* Flexbox 레이아웃으로 설정 */
    justify-content: center;  /* 가로 방향으로 내용 중앙 정렬 */
    align-items: center;  /* 세로 방향으로 내용 중앙 정렬 */
}

h1 {
    color: black;  /* 제목의 텍스트 색상을 lightblue로 설정 */
    text-align: center;  /* 제목을 중앙 정렬 */
    font-family: Arial, sans-serif;  /* 글꼴을 Arial로 설정 */
    font-size: 42px;  /* 글자 크기를 36px로 설정 */
    margin-bottom: 20px;  /* 제목 아래에 20px 여백 추가 */
}

body {
    background-color: white;  /* 페이지 배경 색상을 ivory로 설정 */
    color: #15b8f9;  /* 텍스트 색상을 #15b8f9로 설정 */
    font-family: 'Verdana', sans-serif;  /* 글꼴을 Verdana로 설정 */
    margin: 0;  /* 페이지의 기본 여백을 제거 */
    padding: 0;  /* 페이지의 기본 패딩을 제거 */
    display: flex;  /* Flexbox 레이아웃으로 설정 */
    justify-content: center;  /* 페이지의 내용을 가로로 중앙 정렬 */
    align-items: center;  /* 페이지의 내용을 세로로 중앙 정렬 */
    height: 100vh;  /* 페이지 높이를 100%로 설정하여 화면 전체를 채우도록 함 */
    flex-direction: column;  /* 세로 방향으로 요소 배치 */
}

form {
    text-align: center;  /* 폼 내용을 중앙 정렬 */
    margin-bottom: 30px;  /* 폼 아래에 30px 여백 추가 */
}

button {
    padding: 10px 20px;  /* 버튼에 10px 상하 여백, 20px 좌우 여백 추가 */
    background-color: #15b8f9;  /* 버튼 배경 색상을 #15b8f9로 설정 */
    border: none;  /* 버튼의 기본 테두리 제거 */
    color: white;  /* 버튼 텍스트 색상을 흰색으로 설정 */
    font-size: 16px;  /* 버튼 텍스트 크기를 16px로 설정 */
    cursor: pointer;  /* 버튼에 마우스를 올리면 클릭할 수 있음을 표시 */
    border-radius: 15px;  /* 버튼의 모서리를 5px로 둥글게 설정 */
}

button:hover {
    background-color: #1089a8;  /* 버튼에 마우스를 올리면 배경 색상이 #1089a8로 변경 */
}

.pagination {
    display: flex;  /* Flexbox 레이아웃으로 설정 */
    justify-content: center;  /* 페이징 버튼을 가로로 중앙 정렬 */
    align-items: center;  /* 페이징 버튼을 세로로 중앙 정렬 */
    gap: 10px;  /* 버튼 간의 간격을 10px로 설정 */
    margin-top: 20px;  /* 페이징 상단에 20px 여백 추가 */
}

.pagination button {
    padding: 8px 16px;  /* 페이징 버튼에 8px 상하 여백, 16px 좌우 여백 추가 */
    background-color: #15b8f9;  /* 페이징 버튼 배경 색상을 #15b8f9로 설정 */
    border: none;  /* 페이징 버튼의 기본 테두리 제거 */
    color: white;  /* 페이징 버튼 텍스트 색상을 흰색으로 설정 */
    font-size: 16px;  /* 페이징 버튼 텍스트 크기를 16px로 설정 */
    cursor: pointer;  /* 페이징 버튼에 마우스를 올리면 클릭할 수 있음을 표시 */
    border-radius: 5px;  /* 페이징 버튼의 모서리를 5px로 둥글게 설정 */
}

.pagination button:hover {
    background-color: #1089a8;  /* 페이징 버튼에 마우스를 올리면 배경 색상이 #1089a8로 변경 */
}

/* 테이블 모서리 둥글게 만들기 */
table {
    border-collapse: separate;  /* 셀 간의 경계를 분리하여 둥글게 만든 테두리가 유지되도록 설정 */
    border-radius: 60px;  /* 테이블 모서리를 10px로 둥글게 만듦 */
    overflow: hidden;  /* 테이블 경계를 넘는 부분을 숨겨서 둥글게 보이도록 처리 */
    width: 66%;  /* 테이블 너비를 100%로 설정하여 전체 페이지에 맞게 확장 */
}

table, th, td {
    border: 2px solid white;  /* 테이블과 셀들의 테두리를 #15b8f9 색상으로 설정 */
}

th, td {
    padding: 10px;  /* 셀 내 내용에 10px의 여백을 추가 */
    text-align: center;  /* 셀의 내용 중앙 정렬 */
    #id {
   	color: black;
   }
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