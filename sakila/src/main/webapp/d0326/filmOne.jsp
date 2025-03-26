<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
    String filmIdStr = request.getParameter("filmId");

    if (filmIdStr == null || filmIdStr.trim().isEmpty()) {
        out.println("Film ID is missing or invalid.");
        return;
    }

    int filmId = 0;
    try {
        filmId = Integer.parseInt(filmIdStr);
    } catch (NumberFormatException e) {
        out.println("Invalid Film ID provided.");
        return;
    }

    String sqlFilm = "SELECT * FROM film WHERE film_id = ?";
    String sqlActor = "SELECT a.actor_id, a.first_name, a.last_name FROM actor a JOIN film_actor fa ON a.actor_id = fa.actor_id WHERE fa.film_id = ?";
    String sqlCategory = "SELECT c.name FROM category c JOIN film_category fc ON c.category_id = fc.category_id WHERE fc.film_id = ?";
    String sqlFilmText = "SELECT description FROM film_text WHERE film_id = ?";

    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
    PreparedStatement stmt = null;
    ResultSet rs = null;

    stmt = conn.prepareStatement(sqlFilm);
    stmt.setInt(1, filmId);
    rs = stmt.executeQuery();

    String filmTitle = "";
    String description = "";
    int releaseYear = 0;
    if (rs.next()) {
        filmTitle = rs.getString("title");
        releaseYear = rs.getInt("release_year");
    }

    stmt = conn.prepareStatement(sqlActor);
    stmt.setInt(1, filmId);
    rs = stmt.executeQuery();

    StringBuilder actors = new StringBuilder();
    while (rs.next()) {
        int actorId = rs.getInt("actor_id");
        String actorFullName = rs.getString("first_name") + " " + rs.getString("last_name");
        actors.append("<a href='actorOne.jsp?actorId=" + actorId + "'>" + actorFullName + "</a><br>");
    }

    stmt = conn.prepareStatement(sqlCategory);
    stmt.setInt(1, filmId);
    rs = stmt.executeQuery();

    StringBuilder categories = new StringBuilder();
    while (rs.next()) {
        categories.append(rs.getString("name")).append("<br>");
    }

    stmt = conn.prepareStatement(sqlFilmText);
    stmt.setInt(1, filmId);
    rs = stmt.executeQuery();

    if (rs.next()) {
        description = rs.getString("description");
    }

    if (rs != null) rs.close();
    if (stmt != null) stmt.close();
    if (conn != null) conn.close();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>영화 상세 정보</title>
<style>
        /* 전체 배경 색상과 글꼴 설정 */
        body {
            background-color: #ffcc00; /* 디즈니의 밝은 노란색 */
            font-family: 'Comic Sans MS', cursive, sans-serif;
            color: #333;
            margin: 0;
            padding: 0;
        }

        /* 페이지 헤더 스타일 */
        h1 {
            text-align: center;
            font-size: 3em;
            color: #ff5733; /* 디즈니의 대표적인 오렌지 색상 */
            margin-top: 50px;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
        }

        /* 테이블 스타일 */
        table {
            width: 70%;
            margin: 50px auto;
            border-collapse: collapse;
            background-color: #ff9800; /* 디즈니 느낌의 오렌지 색상 */
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
        }

        th, td {
            padding: 20px;
            text-align: center;
            border: 1px solid #ff5722; /* 따뜻한 느낌의 붉은 색 */
        }

        th {
            background-color: #ff5733; /* 디즈니 느낌의 오렌지 색 */
            color: white;
            font-size: 1.5em;
            text-transform: uppercase;
            border-radius: 10px;
        }

        td {
            background-color: #fff3e0; /* 부드러운 크림색 */
            color: #333;
            font-size: 1.2em;
        }

        /* 영화 제목 스타일 */
        td a {
            color: #2196f3; /* 파란색으로 링크 스타일 설정 */
            font-weight: bold;
            font-size: 1.2em;
            text-decoration: none;
        }

        td a:hover {
            color: #ff5722; /* 마우스를 올렸을 때 빨간색으로 변경 */
            text-decoration: underline;
        }

        /* 돌아가기 버튼 스타일 */
        .btn {
            display: block;
            width: 200px;
            margin: 30px auto;
            padding: 15px;
            background-color: #ff5733; /* 디즈니의 오렌지 색상 */
            color: white;
            font-size: 1.5em;
            font-weight: bold;
            text-align: center;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .btn:hover {
            background-color: #ff5722; /* 호버 시 밝은 빨간색으로 변경 */
        }

        /* 테이블 안에서의 텍스트 마진 설정 */
        table td {
            padding-left: 10px;
            padding-right: 10px;
        }

        /* 화면 여백 */
        .content {
            margin: 50px 0;
            padding: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <h1>영화 상세 정보</h1>
    <table border="1">
        <tr>
            <td>영화 제목</td>
            <td><%= filmTitle %></td>
        </tr>
        <tr>
            <td>출연 배우</td>
            <td><%= actors.toString() %></td>
        </tr>
        <tr>
            <td>카테고리</td>
            <td><%= categories.toString() %></td>
        </tr>
        <tr>
            <td>출시 연도</td>
            <td><%= releaseYear %></td>
        </tr>
        <tr>
            <td>총평</td>
            <td><%= description %></td>
        </tr>
    </table>
</body>
</html>