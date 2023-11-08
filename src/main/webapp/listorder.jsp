<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
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
		StringBuilder output = new StringBuilder("<table border=\"1\"><tr><th>Order Id</th><th>Order Date</th><th>Customer Id</th>" +
				"<th>Customer Name</th><th>Total Amount</th></tr><tr>");
		while (rst.next())
		{
			int orderId = rst.getInt("orderId");
            String date = rst.getString("orderDate");
			int custId = rst.getInt("customerId");
			String custName = rst.getString("firstname")+ " " + rst.getString("lastname");
			String total = currFormat.format(rst.getDouble("totalAmount"));

			output.append(String.format("<td>%d</td><td>%s</td><td>%d</td><td>%s</td><td>%s</td></tr>\n" +
							"<tr align=\"right\"><td colspan=\"4\"><table border=\"1\">\n" +
							"<th>Product Id</th> <th>Quantity</th> <th>Price</th></tr>\n",
					orderId, date, custId, custName, total));

			PreparedStatement prodsQuery = con.prepareStatement("select * from orderproduct op join product p on op.productId = p.productId where orderId = ?");
			prodsQuery.setInt(1, orderId);
			ResultSet prods = prodsQuery.executeQuery();

			while (prods.next()){
				int prodId = prods.getInt("productId");
                int quantity = prods.getInt("quantity");
                String amount = currFormat.format(prods.getDouble("price"));
			output.append(String.format("<tr><td>%d</td><td>%d</td><td>%s</td></tr>\n", prodId, quantity, amount));
			}
			output.append("</table></td></tr>\n");
		}
		output.append("</table>");
        out.print(output);
	}
	catch (SQLException ex)
	{
		out.println("SQLException: " + ex);
	}
%>

</body>
</html>

