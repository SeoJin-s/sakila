<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String actorIdStr = request.getParameter("actorId");
    if (actorIdStr == null || actorIdStr.trim().isEmpty()) {
        out.println("배우 이름을 찾을 수 없음");
        return;
    }

    int actorId = -1;
    if (actorIdStr.matches("\\d+")) {
        actorId = Integer.parseInt(actorIdStr);
    } else {
        out.println("잘못된 조회");
        return;
    }

    // 페이징 변수 초기화
    int currentPage = 1;
    if (request.getParameter("currentPage") != null) {
        currentPage = Integer.parseInt(request.getParameter("currentPage"));
    }
    int rowPerPage = 10; // 한 페이지당 보여줄 영화 개수
    int startRow = (currentPage - 1) * rowPerPage;

    // 데이터베이스 연결
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
    PreparedStatement stmt = null;
    ResultSet rs = null;

    // 배우 정보 가져오기
    String sqlActor = "SELECT first_name, last_name FROM actor WHERE actor_id = ?";
    stmt = conn.prepareStatement(sqlActor);
    stmt.setInt(1, actorId);
    rs = stmt.executeQuery();

    String firstName = "";
    String lastName = "";
    if (rs.next()) {
        firstName = rs.getString("first_name");
        lastName = rs.getString("last_name");
    }

    // 출연 영화 개수 가져오기
    String countFilmSql = "SELECT COUNT(f.film_id) AS filmCount FROM film f JOIN film_actor fa ON f.film_id = fa.film_id WHERE fa.actor_id = ?";
    stmt = conn.prepareStatement(countFilmSql);
    stmt.setInt(1, actorId);
    rs = stmt.executeQuery();
    int totalFilms = 0;
    if (rs.next()) {
        totalFilms = rs.getInt("filmCount");
    }

    // 총 페이지 계산
    int lastPage = totalFilms / rowPerPage;
    if (totalFilms % rowPerPage != 0) {
        lastPage = lastPage + 1;
    }

    // 출연 영화 목록 가져오기 (페이징 처리)
    String sqlFilms = "SELECT f.film_id, f.title FROM film f JOIN film_actor fa ON f.film_id = fa.film_id WHERE fa.actor_id = ? LIMIT ?, ?";
    stmt = conn.prepareStatement(sqlFilms);
    stmt.setInt(1, actorId);
    stmt.setInt(2, startRow);
    stmt.setInt(3, rowPerPage);
    rs = stmt.executeQuery();

    StringBuilder films = new StringBuilder();
    while (rs.next()) {
        films.append("<a href='filmOne.jsp?filmId=" + rs.getInt("film_id") + "'>")
              .append(rs.getString("title"))
              .append("</a><br>");
    }

    // 페이지 네비게이션
    int pageGroupSize = 10;
    int currentGroup = (currentPage - 1) / pageGroupSize;
    int startPage = currentGroup * pageGroupSize + 1;
    int endPage = Math.min(startPage + pageGroupSize - 1, lastPage);

    if (rs != null) rs.close();
    if (stmt != null) stmt.close();
    if (conn != null) conn.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배우 정보</title>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>배우 정보</title>
    <style>
        /* 전체 배경과 글꼴 스타일 */
        body {
            background-color: #fff8e1; /* 푸의 노란색 느낌을 주는 부드러운 배경 */
            font-family: 'Comic Sans MS', sans-serif; /* 친근하고 귀여운 글꼴 */
            margin: 0;
            padding: 0;
            color: #3e2723; /* 다소 어두운 갈색 텍스트로 부드러운 느낌 */
        }

        /* 페이지 제목 스타일 */
        h1 {
            text-align: center;
            color: #ff6f00; /* 푸의 빨간색 느낌을 주는 색 */
            margin-top: 50px;
            font-size: 2.5em;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.1);
        }

        /* 테이블 스타일 */
        table {
            width: 80%;
            margin: 50px auto;
            border-collapse: collapse;
            background-color: #ffcc80; /* 따뜻한 노란색 배경 */
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 20px;
            text-align: center;
            border: 1px solid #ff7043; /* 따뜻한 갈색 선 */
            font-size: 1.2em;
        }

        th {
            background-color: #ff6f00; /* 푸의 빨간색 느낌 */
            color: white;
            font-weight: bold;
            border-radius: 10px;
        }

        td {
            background-color: #fff3e0; /* 부드러운 크림색 배경 */
            color: #3e2723; /* 부드러운 갈색 텍스트 */
        }

        /* 링크 스타일 */
        td a {
            color: #ff6f00; /* 빨간색 링크 */
            font-weight: bold;
            font-size: 1.2em;
            text-decoration: none;
        }

        td a:hover {
            color: #ff7043; /* 링크 호버 시 더 진한 빨간색 */
            text-decoration: underline;
        }

        /* 페이지네이션 스타일 */
        #pagination {
            text-align: center;
            margin-top: 20px;
        }

        #pagination a {
            margin: 0 10px;
            padding: 10px 20px;
            background-color: #ffcc80; /* 부드러운 노란색 */
            color: #3e2723; /* 다크 브라운 텍스트 */
            border-radius: 5px;
            font-size: 1.2em;
            text-decoration: none;
        }

        #pagination a:hover {
            background-color: #ff6f00; /* 호버 시 빨간색 */
            color: white;
        }

        #pagination strong {
            color: #ff7043; /* 현재 페이지는 더 진한 빨간색으로 강조 */
        }

        /* 버튼 스타일 */
        .search-btn {
            display: block;
            width: 200px;
            margin: 30px auto;
            padding: 15px;
            background-color: #ff7043; /* 밝은 빨간색 */
            color: white;
            font-size: 1.5em;
            font-weight: bold;
            text-align: center;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .search-btn:hover {
            background-color: #ff5722; /* 버튼 호버 시 더 진한 빨간색 */
        }

        /* 테이블 내 영화 제목 텍스트 스타일 */
        .film-title {
            font-size: 1.5em;
            color: #ff6f00;
            font-weight: bold;
            text-align: center;
        }

        .film-title a {
            color: #ff7043;
            text-decoration: none;
        }

        .film-title a:hover {
            color: #ff6f00;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h1>배우 정보</h1>
    <table border="1">
        <tr>
            <td>배우 이름</td>
            <td><%= firstName + " " + lastName %></td>
        </tr>
        <tr>
            <td>출연 영화</td>
            <td><%= films.toString() %></td>
        </tr>
    </table>

    <!-- 페이징 처리 -->
    <div id="pagination">
        <a href="actorOne.jsp?actorId=<%= actorId %>&currentPage=1">[처음]</a>
        <%
            if (currentPage > 1) { 
        %>
            <a href="actorOne.jsp?actorId=<%= actorId %>&currentPage=<%= currentPage - 1 %>">[이전]</a>
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
            <a href="actorOne.jsp?actorId=<%= actorId %>&currentPage=<%= i %>"><%= i %></a>
        <%
                }
            }
        %>
        <%
            if (currentPage < lastPage) { 
        %>
            <a href="actorOne.jsp?actorId=<%= actorId %>&currentPage=<%= currentPage + 1 %>">[다음]</a>
        <%
            }
        %>
        <a href="actorOne.jsp?actorId=<%= actorId %>&currentPage=<%= lastPage %>">[마지막]</a>
    </div>
</body>
</html>