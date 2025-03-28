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

    String countSql = "SELECT COUNT(DISTINCT a.actor_id) AS cnt " +
                      "FROM actor a " +
                      "JOIN film_actor fa ON a.actor_id = fa.actor_id " +
                      "JOIN film f ON fa.film_id = f.film_id " +
                      "WHERE a.first_name LIKE ? OR a.last_name LIKE ?";

    PreparedStatement countStmt = conn.prepareStatement(countSql);
    countStmt.setString(1, "%" + searchWord + "%");
    countStmt.setString(2, "%" + searchWord + "%");
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

    String sql = "SELECT a.actor_id, a.first_name, a.last_name " + 
                 "FROM actor a " + 
                 "WHERE a.first_name LIKE ? OR a.last_name LIKE ? " + 
                 "ORDER BY a.actor_id " +
                 "LIMIT ?, ?";

    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setString(1, "%" + searchWord + "%");
    stmt.setString(2, "%" + searchWord + "%");
    stmt.setInt(3, startRow);
    stmt.setInt(4, rowPerPage);

    ResultSet rs = stmt.executeQuery();
    HashMap<String, Object> resultMap = new HashMap<>();
    List<HashMap<String, Object>> actorRecords = new ArrayList<>();

    while (rs.next()) {
        HashMap<String, Object> actorRecord = new HashMap<>();
        actorRecord.put("actor_id", rs.getObject("actor_id"));
        String actorName = rs.getString("first_name") + " " + rs.getString("last_name");
        actorRecord.put("actor_name", actorName);
        actorRecords.add(actorRecord);
    }

    resultMap.put("actors", actorRecords);
    resultMap.put("totalCnt", totalCnt);
    resultMap.put("currentPage", currentPage);
    resultMap.put("lastPage", lastPage);

    request.setAttribute("resultMap", resultMap);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>배우 정보</title>
    <style>
        /* 전체 배경과 글꼴 스타일 */
        body {
            background-color: #f0f8ff; /* 밝고 부드러운 파란색 배경 */
            font-family: 'Arial', sans-serif;
            color: #333;
            margin: 0;
            padding: 0;
        }

        /* 페이지 제목 스타일 */
        h1 {
            text-align: center;
            color: #2c3e50; /* 어두운 파란색 */
            margin-top: 50px;
            font-size: 2.5em;
            font-weight: bold;
        }

        /* 테이블 스타일 */
        table {
            width: 80%;
            margin: 50px auto;
            border-collapse: collapse;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 15px;
            text-align: center;
            border: 1px solid #dfe6e9; /* 라이트 그레이 테두리 */
            font-size: 1.1em;
        }

        th {
            background-color: #2980b9; /* 테일 스타일의 블루 색상 */
            color: white;
            font-weight: bold;
            border-radius: 10px 10px 0 0;
        }

        td {
            background-color: #ecf0f1; /* 부드러운 회색 배경 */
        }

        /* 링크 스타일 */
        td a {
            color: #2980b9; /* 테일 스타일의 블루 색상 */
            font-weight: bold;
            font-size: 1.1em;
            text-decoration: none;
        }

        td a:hover {
            color: #3498db; /* 조금 더 밝은 블루 색상 */
            text-decoration: underline;
        }

        /* 검색 폼 스타일 */
        form {
            text-align: center;
            margin: 30px auto;
        }

        input[type="text"] {
            padding: 10px;
            font-size: 1em;
            border-radius: 25px;
            border: 1px solid #dfe6e9;
            width: 250px;
            margin-right: 10px;
        }

        button {
            padding: 10px 20px;
            font-size: 1em;
            color: white;
            background-color: #2980b9;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #3498db;
        }

        /* 페이징 스타일 */
        #pagination {
            text-align: center;
            margin-top: 20px;
        }

        #pagination a {
            margin: 0 8px;
            padding: 10px 15px;
            background-color: #2980b9; /* 기본 블루 */
            color: white;
            font-size: 1.1em;
            border-radius: 23px;
            text-decoration: none;
        }

        #pagination a:hover {
            background-color: #3498db; /* 호버 시 밝은 블루 */
        }

        #pagination strong {
            color: #3498db; /* 현재 페이지 강조 색상 */
        }

        /* 페이지네이션 마지막, 첫 번째 버튼 스타일 */
        #pagination a:first-child,
        #pagination a:last-child {
            background-color: #2ecc71; /* 처음/끝 페이지는 초록색으로 구분 */
        }

        #pagination a:first-child:hover,
        #pagination a:last-child:hover {
            background-color: #27ae60; /* 초록색 호버 */
        }
    </style>
</head>
<body>
    <div>
		<%=staffId %>님 반갑습니다.
		<a href ="/sakila/logOut.jsp">[로그아웃]</a>
             </div>
    <h1>배우 정보</h1>
    <table border="1" id="table1">
    
    <tr>
        <th>배우 이름</th>
    </tr>

    <%
	    List<HashMap<String, Object>> actors = (List<HashMap<String, Object>>) resultMap.get("actors");
	    if (actors != null && !actors.isEmpty()) {
	        for (HashMap<String, Object> record : actors) {
	    %>
	    <tr>
	       	 <td>
	            <a href="actorOne.jsp?actorId=<%= record.get("actor_id") %>&searchWord=<%= searchWord %>&currentPage=<%= currentPage %>">
   				 <%= record.get("actor_name") %></a>
	        </td>
	    	</tr>
	    <%
	        }
	   		 } else {
	    %>
	    		<tr><td colspan="1">No records found.</td></tr>
	    <%
	   		 }
	    %>
	</table>

    <form action="/sakila/d0326/actorList.jsp" method="get">
        배우 검색:
        <input type="text" name="searchWord" value="<%= searchWord %>">
        <button type="submit">Search</button>
    </form>

    <div id="page">
        Current Page: <%= resultMap.get("currentPage") %> / Last Page: <%= resultMap.get("lastPage") %>
    </div>

    <div id="pagination">
        <a href="/sakila/d0326/actorList.jsp?currentPage=1&searchWord=<%= searchWord %>">[처음]</a>
        <%
            if (currentPage > 1) { 
        %>
            <a href='/sakila/d0326/actorList.jsp?searchWord=<%= searchWord %>&currentPage=<%= currentPage - 1 %>'>[이전]</a>
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
            <a href='/sakila/d0326/actorList.jsp?searchWord=<%= searchWord %>&currentPage=<%= i %>'><%= i %></a>
        <%
                }
            }
        %>

        <%
            if (currentPage < lastPage) { 
        %>
            <a href='/sakila/d0326/actorList.jsp?searchWord=<%= searchWord %>&currentPage=<%= currentPage + 1 %>'>[다음]</a>
        <%
            }
        %>
        <a href='/sakila/d0326/actorList.jsp?searchWord=<%= searchWord %>&currentPage=<%= lastPage %>'>[마지막]</a>
    </div>
</body>
</html>