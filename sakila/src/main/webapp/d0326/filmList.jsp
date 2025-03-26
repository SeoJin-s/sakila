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
                      "FROM film f " +
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

    String sql = "SELECT f.title AS filmTitle, f.film_id AS filmId " +
                 "FROM film f " +
                 "WHERE f.title LIKE ? " +
                 "ORDER BY f.title ASC " +
                 "LIMIT ?, ?";

    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setString(1, "%" + searchWord + "%");
    stmt.setInt(2, startRow);
    stmt.setInt(3, rowPerPage);

    ResultSet rs = stmt.executeQuery();

    HashMap<String, Object> resultMap = new HashMap<>();

    List<HashMap<String, Object>> filmRecords = new ArrayList<>();

    while (rs.next()) {
        HashMap<String, Object> filmRecord = new HashMap<>();
        filmRecord.put("filmTitle", rs.getObject("filmTitle"));
        filmRecord.put("filmId", rs.getObject("filmId"));
        filmRecords.add(filmRecord);
    }

    resultMap.put("filmRecords", filmRecords);
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
<title>영화 목록</title>
<style>
    /* 전체 배경 색상과 글꼴 설정 */
    body {
        background-color: #f9f9f9; /* 미키 마우스의 밝고 깨끗한 느낌을 반영 */
        font-family: 'Arial', sans-serif;
        margin: 0;
        padding: 0;
    }

    /* 페이지 헤더 스타일 */
    h1 {
        text-align: center;
        font-size: 2.2em; /* 조금 작은 크기로 수정 */
        color: #ffcc00; /* 미키 마우스의 대표적인 노란색 */
        margin-top: 30px; /* 상단 여백 줄이기 */
        text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.2);
    }

    /* 테이블 스타일 */
    table {
        width: 70%; /* 테이블 폭 줄이기 */
        margin: 30px auto; /* 테이블과 다른 요소 사이의 여백 줄이기 */
        border-collapse: collapse;
        background-color: #ff5733; /* 미키 마우스의 빨간색 반영 */
        border-radius: 12px; /* 모서리 둥글게 */
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.15);
    }

    th, td {
        padding: 15px; /* 셀 안의 패딩을 줄여서 크기 감소 */
        text-align: center;
        border: 1px solid #ff5722; /* 따뜻한 느낌의 붉은 색 */
    }

    th {
        background-color: #ffcc00; /* 미키 마우스의 노란색 */
        color: black;
        font-size: 1.3em; /* 글자 크기 조금 줄이기 */
        text-transform: uppercase;
        border-radius: 8px;
    }

    td {
        background-color: #fff3e0; /* 부드러운 크림색 */
        color: #333;
        font-size: 1.1em; /* 글자 크기 조금 줄이기 */
    }

    /* 링크 스타일 */
    td a {
        color: #000000; /* 미키 마우스의 전통적인 검정색 */
        font-weight: bold;
        font-size: 1.1em; /* 글자 크기 조금 줄이기 */
        text-decoration: none;
    }

    td a:hover {
        color: #ff5733; /* 마우스를 올렸을 때 빨간색으로 변경 */
        text-decoration: underline;
    }

    /* 페이지네이션 스타일 */
    #pagination {
        text-align: center;
        margin-top: 15px;
    }

    #pagination a {
        margin: 0 4px;
        padding: 8px 12px; /* 패딩 크기 줄이기 */
        background-color: #ff5733; /* 미키 마우스의 빨간색 */
        color: white;
        text-decoration: none;
        border-radius: 4px;
        font-size: 1.1em; /* 글자 크기 조금 줄이기 */
    }

    #pagination a:hover {
        background-color: #ff5722; /* 마우스를 올렸을 때 더 밝은 빨간색 */
    }

    #pagination strong {
        color: #ffcc00; /* 현재 페이지는 노란색으로 강조 */
    }

    /* 버튼 스타일 */
    .search-btn {
        display: block;
        width: 180px; /* 버튼 폭 줄이기 */
        margin: 20px auto; /* 여백 줄이기 */
        padding: 12px;
        background-color: #ff5733; /* 미키 마우스의 빨간색 */
        color: white;
        font-size: 1.2em; /* 글자 크기 줄이기 */
        font-weight: bold;
        text-align: center;
        border-radius: 8px; /* 모서리 둥글게 */
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .search-btn:hover {
        background-color: #ff5722; /* 호버 시 빨간색으로 변경 */
    }

    /* 영화 제목 텍스트 스타일 */
    .film-title {
        font-size: 1.2em; /* 제목 크기 줄이기 */
        color: #000000;
        font-weight: bold;
        text-align: center;
    }

    .film-title a {
        color: #ff5733;
        text-decoration: none;
    }

    .film-title a:hover {
        color: #ffcc00;
        text-decoration: underline;
    }
</style>
</head>
<body>
    <h1>영화 목록</h1>

    <form action="/sakila/d0326/filmList.jsp">
    </form>

    <table border="1">
        <tr>
            <th>영화 제목</th>
        </tr>

        <%
        	for (HashMap<String, Object> record : filmRecords) {
        %>
            <tr>
                <td><a href="filmOne.jsp?filmId=<%= record.get("filmId") %>"><%= record.get("filmTitle") %></a></td>
            </tr>
        <%
        }
        %>    
    </table>

    <div id="pagination">
        <a href="/sakila/d0326/filmList.jsp?currentPage=1&searchWord=<%= searchWord %>">[처음]</a>
        <%
            if (currentPage > 1) { 
        %>
            <a href='/sakila/d0326/filmList.jsp?searchWord=<%= searchWord %>&currentPage=<%= currentPage - 1 %>'>[이전]</a>
        <%
            } 
        %>

        <%
        for (int i = startPage; i <= endPage; i++) {
            if (i == currentPage) {
        %>
               <strong><%= i %></strong>
        <% 
            } else { 
         %>
        <a href='/sakila/d0326/filmList.jsp?searchWord=<%= searchWord %>&currentPage=<%= i %>'><%= i %></a>
         <%
            }
        }
      %>
      <% if (currentPage < lastPage) { %>
    <a href='/sakila/d0326/filmList.jsp?searchWord=<%= searchWord %>&currentPage=<%= currentPage + 1 %>'>[다음]</a>
    <% } %>  
    	<a href='/sakila/d0326/filmList.jsp?searchWord=<%= searchWord %>&currentPage=<%= lastPage %>'>[마지막]</a>
    </div>

</body>
</html>