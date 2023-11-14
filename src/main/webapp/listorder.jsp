<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<link rel="stylesheet" type="text/css" href="bootstrap/css/bootstrap.min.css">
<!DOCTYPE html>
<html>
<head>
<%@ include file="header.jsp" %>

<title>YOUR NAME Grocery Order List</title>
</head>
<body>

<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	String uid = "sa";
	String pw = "304#sa#pw";

	try ( Connection con = DriverManager.getConnection(url, uid, pw);
		  Statement stmt = con.createStatement();)
	{
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		ResultSet rst = stmt.executeQuery("SELECT * FROM ordersummary join customer on ordersummary.customerid = customer.customerid");
		%>
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
			<tr>
<%
		while (rst.next())
		{
			int orderId = rst.getInt("orderId");
            String date = rst.getString("orderDate");
			int custId = rst.getInt("customerId");
			String custName = rst.getString("firstname")+ " " + rst.getString("lastname");
			String total = currFormat.format(rst.getDouble("totalAmount"));
%>
				<td><%=orderId%></td>
				<td><%=date%></td>
				<td><%=custId%></td>
				<td><%=custName%></td>
				<td><%=total%></td>
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

			PreparedStatement prodsQuery = con.prepareStatement("select * from orderproduct op join product p on op.productId = p.productId where orderId = ?");
			prodsQuery.setInt(1, orderId);
			ResultSet prods = prodsQuery.executeQuery();

			while (prods.next()){
				int prodId = prods.getInt("productId");
                int quantity = prods.getInt("quantity");
                String amount = currFormat.format(prods.getDouble("price"));
				%>

				<tr>
					<td><%=prodId%></td>
					<td><%=quantity%></td>
					<td><%=amount%></td>
				</tr>

			<%}
			%>
				</table>
		</td>
	</tr>

		<%}
		%>
</table>
		<%
	}
	catch (SQLException ex)
	{
		out.println("SQLException: " + ex);
	}
%>

</body>
</html>


