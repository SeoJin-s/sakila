<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<h1>rental List</h1>
	<form action="/sakila/d0325/rentalList.jsp">
	 strore :
	 <select name="storeId">
	 	<option value="0">전체</option>
	 	<option value="1">1지점</option>
	 	<option value="2">2지점</option>
	 </select>
	 <button type = "submit">검색</button>
	</form>

	<table border="1">
		<tr>
			<th>rentalId</th>
			<th>filmTitle</th>
			<th>inventoryID</th>
			<th>name(customerID)</th> <!-- name = first_name + last_name -->
			<th>rentalDate</th>
			<th>retrunDate</th>
		</tr>
	</table>
		<form action="/sakila/d0325/rentalList.jsp">
		filmTitle SearchWord :
			 <select name="storeId">
			 	<input type="text" name="searchWord">
			 </select>
			 <button type = "submit">검색</button>
		</form>
</body>
</html>