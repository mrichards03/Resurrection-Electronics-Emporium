<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>

<head>
<%@ include file="header.jsp" %>
<title>YOUR NAME Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input class="btn btn-secondary" type="submit" value="Submit"> <input class="btn btn-secondary" type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
	String name = request.getParameter("productName");
	List<Product> prods = init(name);
%>
</br>
<h2>All Products</h2>
</br>
<table class="table table-striped">
	<tr>
		<th></th>
		<th>Product Name</th>
		<th>Price</th>
	</tr>

<%
	for(Product prod : prods)
	{
%>
		<tr>
			<td>
				<a href="addcart.jsp?id=<%=prod.id%>&name=<%=prod.name%>&price=<%=prod.price%>" class="btn btn-success">Add to Cart</a>
			</td>
			<td><%=prod.name%></td>
			<td><%=prod.priceStr%></td>
		</tr>

<%
	}
%>
</table>

</body>
</html>

<%!
	public static class Product
	{
		int id;
		String name;
		double price;
		String priceStr;
	}

	public List<Product> init(String name)
	{
		try
		{	// Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		}
		catch (java.lang.ClassNotFoundException e)
		{
			System.err.println("ClassNotFoundException: " +e);
		}

		List<Product> prods = new ArrayList<>();
		try
		{
			getConnection();

			PreparedStatement prodsQuery = null;
			boolean hasName = name != null && !name.isEmpty();
			StringBuilder output = new StringBuilder();
			if(hasName)
			{
				name = "%" + name + "%";
				prodsQuery = con.prepareStatement("select * from product where productName like ? ");
				prodsQuery.setString(1, name);
			}else
			{
				prodsQuery = con.prepareStatement("select * from product");
			}
			ResultSet rsprods = prodsQuery.executeQuery();

			NumberFormat currFormat = NumberFormat.getCurrencyInstance();

			while (rsprods.next()) {
				int prodId = rsprods.getInt("productId");
				String prodName = rsprods.getString("productName");
				double dPrice = rsprods.getDouble("productPrice");
				String priceformatted = currFormat.format(rsprods.getDouble("productPrice"));

				prods.add(new Product(){{
					id = prodId;
					name = prodName;
					price = dPrice;
					priceStr = priceformatted;
				}});

			}

		}
		catch (SQLException ex)
		{
			System.err.println("SQLException: " + ex);
		}
		finally
		{
			closeConnection();
		}

		return prods;
	}
%>