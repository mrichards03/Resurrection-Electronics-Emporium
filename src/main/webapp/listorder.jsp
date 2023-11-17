<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
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
	List<Order> orders = getOrders();
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
		<td><%=o.date%></td>
		<td><%=o.custId%></td>
		<td><%=o.custName%></td>
		<td><%=o.total%></td>
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

<%!
	private List<Order> getOrders(){

		List<Order> orders = new ArrayList<>();

		try{
			getConnection();

			NumberFormat currFormat = NumberFormat.getCurrencyInstance();
			PreparedStatement stmt = con.prepareStatement("SELECT * FROM ordersummary join customer on ordersummary.customerid = customer.customerid");
			ResultSet rst = stmt.executeQuery();

			while (rst.next()) {

				Order order = new Order(){{
					id = rst.getInt("orderId");
					date = rst.getString("orderDate");
					custId = rst.getInt("customerId");
					custName = rst.getString("firstname") + " " + rst.getString("lastname");
					total = currFormat.format(rst.getDouble("totalAmount"));
				}};

				PreparedStatement prodsQuery = con.prepareStatement("select * from orderproduct op join product p on op.productId = p.productId where orderId = ?");
				prodsQuery.setInt(1, order.id);
				ResultSet prods = prodsQuery.executeQuery();

				while (prods.next()) {
					order.products.add(new Product(){{
						id = prods.getInt("productId");
						quantity = prods.getInt("quantity");
						priceStr = currFormat.format(prods.getDouble("price"));
					}});
				}

				orders.add(order);
			}

		}catch (Exception e){
			System.err.println("SQLException: " + e);
		}
		finally {
			closeConnection();
		}

		return orders;
	}
%>
