<%@ page import="java.util.List" %>
<%@ page import="com.mackenzie.lab7.Product" %>
<%@ page import="com.mackenzie.lab7.Order" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<link rel="stylesheet" type="text/css" href="bootstrap/css/bootstrap.min.css">
<!DOCTYPE html>
<html>
<head>
<%@ include file="header.jsp" %>

<title>YOUR NAME Grocery Order List</title>
</head>
<body>
<%
	List<Order> orders = Order.getOrders();
%>

<h1>Order List</h1>
<table class="table border-dark border-1 table-striped">
	<thead class="table-dark">
		<tr>
			<th>Order Id</th>
			<th>Order Date</th>
			<th>Customer Id</th>
			<th>Customer Name</th>
			<th>Total Amount</th>
		</tr>
	</thead>

	<%
		for (Order o : orders){
	%>
	<tr>
		<td><%=o.id%></td>
		<td><%=o.date.toLocalDate()%> <%=o.date.toLocalTime()%></td>
		<td><%=o.custId%></td>
		<td><%=o.custName%></td>
		<td><%=o.totalStr%></td>
	</tr>
	<tr>
		<td colspan="4">
			<table class="table table-sm mx-5">
				<thead class="table-dark">
					<tr>
						<th>Product Id</th>
						<th>Quantity</th>
						<th>Price</th>
					</tr>
				</thead>
				<%
					for (Product p : o.products){
				%>
				<tr>
					<td><%=p.id%></td>
					<td><%=p.quantity%></td>
					<td><%=p.priceStr%></td>
				</tr>
				<%
					}
				%>
			</table>
		</td>
	</tr>
	<%
		}
	%>
</table>

</body>
</html>
