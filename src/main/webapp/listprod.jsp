<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.mackenzie.lab7.Product" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<jsp:include page="header.jsp" />
<%@ page import="com.mackenzie.lab7.Connections" %>

<!DOCTYPE html>
<html>
<head>
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
			<td>
				<a href="product.jsp?id=<%=prod.id%>"><%=prod.name%></a>
			</td>
			<td><%=prod.priceStr%></td>
		</tr>

<%
	}
%>
</table>
<h2>Recommended Products</h2>
<table class="table table-striped">
	<tr>
		<th></th>
		<th>Product Name</th>
		<th>Price</th>
	</tr>

		<%

		List<Product> recProds = getRecs(session);
	for(Product prod : recProds)
	{
%>
	<tr>
		<td>
			<a href="addcart.jsp?id=<%=prod.id%>&name=<%=prod.name%>&price=<%=prod.price%>" class="btn btn-success">Add to Cart</a>
		</td>
		<td>
			<a href="product.jsp?id=<%=prod.id%>"><%=prod.name%></a>
		</td>
		<td><%=prod.priceStr%></td>
	</tr>
		<%
	}
%>

</body>
</html>

<%!
	public List<Product> getRecs(HttpSession session) {
		String username;
		List<Product> recProds = new ArrayList<>();
		if (session.getAttribute("authenticatedUser") == null) {
			return null;
		} else {
			username = session.getAttribute("authenticatedUser").toString();
		}
		try {    // Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		} catch (java.lang.ClassNotFoundException e) {
			System.err.println("ClassNotFoundException: " + e);
		}
		Connections con = new Connections();
		try {
			con.getConnection();

			PreparedStatement topBrand = con.con.prepareStatement("SELECT brandID from (SELECT brandID FROM ordersummary join users on ordersummary.userID = users.userId join orderproduct on ordersummary.orderID = orderproduct.orderID join product on orderproduct.productID = product.ProductID where userName = ?) where count(brandID) >= count(ANY)");
			topBrand.setString(1, username);
			ResultSet brand = topBrand.executeQuery();
			String brandID = brand.getString("brandID");
			PreparedStatement topCategory = con.con.prepareStatement("SELECT categoryID from (SELECT categoryID FROM ordersummary join users on ordersummary.userID = users.userId join orderproduct on ordersummary.orderID = orderproduct.orderID join product on orderproduct.productID = product.ProductID where userName = ?) where count(categoryID) >= count(ANY)");
			topBrand.setString(1, username);
			ResultSet category = topCategory.executeQuery();
			String categoryID = category.getString("categoryID");
			PreparedStatement getRecProds1 = con.con.prepareStatement("SELECT * from product where brandID = ? and categoryID = ?");
			getRecProds1.setString(1, brandID);
			getRecProds1.setString(2, categoryID);
			ResultSet recProds1 = getRecProds1.executeQuery();

		} catch (SQLException ex) {
			System.err.println("SQLException: " + ex);
		} finally {
			con.closeConnection();
		}

		return recProds;
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
		Connections con = new Connections();
		List<Product> prods = new ArrayList<>();
		try
		{
			con.getConnection();

			PreparedStatement prodsQuery;
			boolean hasName = name != null && !name.isEmpty();
			if(hasName)
			{
				name = "%" + name + "%";
				prodsQuery = con.con.prepareStatement("select * from product where productName like ? ");
				prodsQuery.setString(1, name);
			}else
			{
				prodsQuery = con.con.prepareStatement("select * from product");
			}
			ResultSet rsprods = prodsQuery.executeQuery();

			NumberFormat currFormat = NumberFormat.getCurrencyInstance();

			while (rsprods.next()) {

				prods.add(new Product(rsprods.getInt("productId"), rsprods.getDouble("productPrice"),
						0, rsprods.getString("productName")));

			}

		}
		catch (SQLException ex)
		{
			System.err.println("SQLException: " + ex);
		}
		finally
		{
			con.closeConnection();
		}

		return prods;
	}
%>