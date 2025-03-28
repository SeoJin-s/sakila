<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%

	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
			
	if(staffId != null) {
		response.sendRedirect("/sakila/index.jsp");
		return;
	}
%>

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
        background-color: #fff5e0; /* 따뜻한 크림색 배경 */
        font-family: 'Comic Sans MS', sans-serif; /* 귀여운 느낌의 글꼴 */
        margin: 0;
        padding: 0;
    }

    /* 페이지 헤더 스타일 */
    h1 {
        text-align: center;
        font-size: 2.5em; /* 조금 더 큰 글자 */
        color: #f4c542; /* 곰돌이 푸의 노란색 */
        margin-top: 40px;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1); /* 부드러운 그림자 */
    }

    /* 테이블 스타일 */
    table {
        width: 80%; /* 테이블 폭 증가 */
        margin: 40px auto;
        border-collapse: collapse;
        background-color: #d68e3a; /* 곰돌이 푸의 갈색 */
        border-radius: 12px;
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
    }

    th, td {
        padding: 18px;
        text-align: center;
        border: 1px solid #d68e3a; /* 테이블 테두리 색상 */
    }

    th {
        background-color: #f4c542; /* 노란색 헤더 */
        color: #fff;
        font-size: 1.4em;
        text-transform: uppercase;
        border-radius: 10px;
    }

    td {
        background-color: #fff9d9; /* 부드러운 노란색 배경 */
        color: #5a4e42; /* 갈색 글자 */
        font-size: 1.1em;
    }

    /* 링크 스타일 */
    td a {
        color: #5a4e42; /* 곰돌이 푸의 갈색 */
        font-weight: bold;
        font-size: 1.1em;
        text-decoration: none;
    }

    td a:hover {
        color: #f4c542; /* 마우스를 올렸을 때 노란색으로 변경 */
        text-decoration: underline;
    }

    /* 페이지네이션 스타일 */
    #pagination {
        text-align: center;
        margin-top: 20px;
    }

    #pagination a {
        margin: 0 6px;
        padding: 10px 16px; /* 패딩 크기 증가 */
        background-color: #d68e3a; /* 곰돌이 푸의 갈색 */
        color: white;
        text-decoration: none;
        border-radius: 6px;
        font-size: 1.2em; /* 페이지 번호 글자 크기 증가 */
    }

    #pagination a:hover {
        background-color: #f4c542; /* 노란색으로 hover 효과 */
    }

    #pagination strong {
        color: #d68e3a; /* 현재 페이지는 갈색으로 강조 */
    }

    /* 버튼 스타일 */
    .search-btn {
        display: block;
        width: 200px; /* 버튼 폭 증가 */
        margin: 20px auto;
        padding: 12px;
        background-color: #d68e3a; /* 곰돌이 푸의 갈색 */
        color: white;
        font-size: 1.3em;
        font-weight: bold;
        text-align: center;
        border-radius: 8px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .search-btn:hover {
        background-color: #f4c542; /* 노란색으로 hover 효과 */
    }

    /* 로그아웃 버튼 스타일 */
    .logout-btn {
        display: inline-block;
        padding: 10px 20px;
        background-color: #d68e3a; /* 갈색 */
        color: white;
        font-size: 1.1em;
        font-weight: bold;
        text-decoration: none;
        border-radius: 8px;
        margin: 20px 0;
    }

    .logout-btn:hover {
        background-color: #f4c542; /* 노란색으로 hover 효과 */
    }

</style>
</head>
<body>
	<div>
		<%=staffId %>님 반갑습니다.
		<a href ="/sakila/logOut.jsp">[로그아웃]</a>
             </div>
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