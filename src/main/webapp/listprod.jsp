<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<%@ include file="header.jsp" %>
<head>
<title>YOUR NAME Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

// Make the connection
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	String uid = "sa";
	String pw = "304#sa#pw";

	try ( Connection con = DriverManager.getConnection(url, uid, pw);
		  Statement stmt = con.createStatement();)
	{
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		PreparedStatement prodsQuery = null;
		boolean hasName = name != null && !name.equals("");
		if(hasName){
			name = "%" + name + "%";
			prodsQuery = con.prepareStatement("select * from product where productName like ? ");
			prodsQuery.setString(1, name);
		}else{
			prodsQuery = con.prepareStatement("select * from product");
		}

		ResultSet prods = prodsQuery.executeQuery();

		StringBuilder output = new StringBuilder("<h2>All Products</h2>\n" +
				"<table><tr><th></th><th>Product Name</th><th>Price</th></tr>");
		while (prods.next())
		{
			int prodId = prods.getInt("productId");
			String prodName = prods.getString("productName");
			String price = currFormat.format(prods.getDouble("productPrice"));

			output.append(String.format("<tr><td><a href=\"addcart.jsp?id=%d&name=%s&price=%f\">Add to Cart</a></td><td>%s</td><td>%s</td></tr>",
					prodId, prodName, prods.getDouble("productPrice"), prodName, price));


		}
		output.append("</table>");
		out.print(output);
	}
	catch (SQLException ex)
	{
		out.println("SQLException: " + ex);
	}
// Print out the ResultSet

// For each product create a link of the form
// addcart.jsp?id=productId&name=productName&price=productPrice
// Close connection

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
%>

</body>
</html>