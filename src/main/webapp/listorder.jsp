<%@ page import="java.util.List" %>
<%@ page import="com.mackenzie.lab7.*" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %><!DOCTYPE html>
<html>
<head>
<title>ReSurrected Electronics Emporium orders</title>
</head>
<body>
<%
	if(!LoggedIn){
		response.sendRedirect("login.jsp");
		return;
	}
	List<Order> orders = Order.getOrders();
	if(!isAdmin){
		orders = orders.stream().filter(f -> f.custId == user.id).collect(Collectors.toList());
	}
	if(orders.isEmpty()){
		out.println("<h1>No orders found</h1>");
		return;
	}
%>
<div class="m-4">
<h1>Orders</h1>
<table class="table border-dark border-1 table-striped">
	<thead class="table-dark">
		<tr>
			<th>Order Id</th>
			<th>Order Date</th>
			<th>Customer Id</th>
			<th>Customer Name</th>
			<th>Total Amount</th>
			<th></th>
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
		<td><%=o.isShipped ? "Shipped":"Not Shipped"%></td>
	</tr>
	<tr>
		<td colspan="4">
			<table class="table table-sm mx-5">
				<thead class="table-dark">
					<tr>
						<th>Product Id</th>
						<th>Product Name</th>
						<th>Quantity</th>
						<th>Price</th>
					</tr>
				</thead>
				<%
					for (OrderProduct p : o.products){
				%>
				<tr>
					<td><%=p.product.id%></td>
					<td><%=p.product.name%></td>
					<td><%=p.quantity%></td>
					<td><%=p.product.priceStr%></td>
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
</div>
</body>
</html>
