<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
    String searchWord = request.getParameter("searchWord");
    if (searchWord == null) {
        searchWord = "";
    }

    int currentPage = 1;
    if (request.getParameter("currentPage") != null) {
        currentPage = Integer.parseInt(request.getParameter("currentPage"));
    }

    int rowPerPage = 10;
    int startRow = (currentPage - 1) * rowPerPage;

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");

    String countSql = "SELECT COUNT(*) AS cnt " +
            "FROM ( " +
            "    SELECT i.inventory_id, f.title " +
            "    FROM inventory i " +
            "    INNER JOIN film f ON i.film_id = f.film_id " +
            "    LEFT OUTER JOIN ( " +
            "        SELECT inventory_id, rental_date, " +
            "        CASE WHEN return_date IS NULL THEN '대여불가' ELSE '대여가능' END AS isRental " +
            "        FROM rental " +
            "        WHERE (inventory_id, rental_date) IN ( " +
            "            SELECT inventory_id, MAX(rental_date) " +
            "            FROM rental " +
            "            GROUP BY inventory_id " +
            "        ) " +
            "    ) t2 ON i.inventory_id = t2.inventory_id " +
            "    WHERE f.title LIKE ? " +
            ") AS filtered_rentals";

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

    String sql = "SELECT i.inventory_id, f.title, t2.isRental " +
            "FROM inventory i " +
            "INNER JOIN film f ON i.film_id = f.film_id " +
            "LEFT OUTER JOIN ( " +
            "    SELECT inventory_id, rental_date, " +
            "    CASE WHEN return_date IS NULL THEN '대여불가' ELSE '대여가능' END AS isRental " +
            "    FROM rental " +
            "    WHERE (inventory_id, rental_date) IN ( " +
            "        SELECT inventory_id, MAX(rental_date) " +
            "        FROM rental " +
            "        GROUP BY inventory_id " +
            "    ) " +
            ") t2 ON i.inventory_id = t2.inventory_id " +
            "WHERE f.title LIKE ? " +
            "LIMIT ?, ?";

    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setString(1, "%" + searchWord + "%");
    stmt.setInt(2, startRow);
    stmt.setInt(3, rowPerPage);

    ResultSet rs = stmt.executeQuery();

    HashMap<String, Object> resultMap = new HashMap<>();
    ArrayList<HashMap<String, Object>> rentals = new ArrayList<>();

    while (rs.next()) {
        HashMap<String, Object> rental = new HashMap<>();
        rental.put("inventory_id", rs.getInt("inventory_id"));
        rental.put("film_title", rs.getString("title"));
        rental.put("isRental", rs.getString("isRental"));
        rentals.add(rental);
    }

    resultMap.put("rentals", rentals);
    rs.close();
    stmt.close();
    conn.close();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비디오방</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f9;
            color: #3c3c3c;
            margin: 0;
            padding: 0;
        }

        h1 {
            text-align: center;
            color: #2c6f77;
            margin-top: 30px;
            font-size: 2em;
        }

        table {
            width: 90%;
            margin: 30px auto;
            border-collapse: collapse;
            border: 2px solid #5c8a74;
            background-color: #ffffff;
        }

        table th, table td {
            padding: 12px;
            text-align: center;
            border: 1px solid #5c8a74;
        }

        table th {
            background-color: #a7c7e7;
            color: white;
            font-size: 1.2em;
        }

        table td {
            background-color: #e1f2f3;
        }

        input[type="submit"] {
            background-color: #f1b2a7;
            color: white;
            border: none;
            padding: 8px 16px;
            cursor: pointer;
            border-radius: 5px;
        }

        input[type="submit"]:hover {
            background-color: #f0a18b;
        }

        #pagination {
            text-align: center;
            margin-top: 30px;
            font-size: 1.1em;
        }

        #pagination a {
            color: #5c8a74;
            text-decoration: none;
            margin: 0 8px;
            padding: 8px 16px;
            border-radius: 5px;
            background-color: #a7c7e7;
        }

        #pagination a:hover {
            background-color: #88a6b5;
        }

        #pagination strong {
            font-weight: bold;
            color: #2c6f77;
        }

        form {
            text-align: center;
            margin-top: 20px;
        }

        form input[type="text"] {
            padding: 8px;
            font-size: 1em;
            border-radius: 5px;
            border: 1px solid #ddd;
            width: 200px;
        }

        form button {
            padding: 8px 16px;
            background-color: #f1b2a7;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            font-size: 1em;
        }

        form button:hover {
            background-color: #f0a18b;
        }

        #page {
            text-align: center;
            margin-top: 20px;
            font-size: 1.2em;
        }
    </style>
</head>
<body>
    <h1>영화 비디오 대여 리스트</h1>
    <table border="1">
        <tr>
            <th>비디오번호</th>
            <th>영화 제목</th>
            <th>대여 가능 여부</th>
            <th>반납</th>
        </tr>

        <% 
        ArrayList<HashMap<String, Object>> rentalsList = (ArrayList<HashMap<String, Object>>) resultMap.get("rentals");
        for (HashMap<String, Object> rental : rentalsList) {
        %>
            <tr>
                <td><%= rental.get("inventory_id") %></td>
                <td><%= rental.get("film_title") %></td>
                <td><%= rental.get("isRental") %></td>
                <td><input type="submit" value="반납"> </td>
            </tr>
        <% } %>
    </table>

    <form action="/sakila/d0327/inventoryList.jsp" method="get">
        영화 검색:
        <input type="text" name="searchWord" value="<%= searchWord %>">
        <button type="submit">Search</button>
    </form>

    <div id="pagination">
        <a href="/sakila/d0327/inventoryList.jsp?currentPage=1&searchWord=<%= searchWord %>">[처음]</a>

        <% if (currentPage > 1) { %>
            <a href='/sakila/d0327/inventoryList.jsp?searchWord=<%= searchWord %>&currentPage=<%= currentPage - 1 %>'>[이전]</a>
        <% } %>

        <% for (int i = startPage; i <= endPage; i++) { %>
            <% if (i == currentPage) { %>
                <strong><%= i %></strong>
            <% } else { %>
                <a href='/sakila/d0327/inventoryList.jsp?searchWord=<%= searchWord %>&currentPage=<%= i %>'><%= i %></a>
            <% } %>
        <% } %>

        <% if (currentPage < lastPage) { %>
            <a href='/sakila/d0327/inventoryList.jsp?searchWord=<%= searchWord %>&currentPage=<%= currentPage + 1 %>'>[다음]</a>
        <% } %>

        <a href='/sakila/d0327/inventoryList.jsp?searchWord=<%= searchWord %>&currentPage=<%= lastPage %>'>[마지막]</a>
    </div>
</body>
</html>