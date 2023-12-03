<%@ page import="com.mackenzie.lab7.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="com.mackenzie.lab7.Connections" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
<script>
	function deleteProd(id) {
		if (confirm("Are you sure you want to delete this product?")) {
			window.location.href = "delete-Product?id=" + id;
		}
	}
</script>
<%

	if (request.getAttribute("message") != null && request.getAttribute("success") != null) {
		String message = request.getAttribute("message").toString();
		String success = request.getAttribute("success").toString();
%>
<jsp:include page="toast.jsp">
	<jsp:param name="message" value="<%=message%>" />
	<jsp:param name="success" value="<%=success%>" />
</jsp:include>
<%	} %>

<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery</title>
</head>
<body>
<div class="m-4">
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
	<% if(name == null || name.isEmpty()) { %>
		<h2>All Products</h2>
	<% } %>

	<% if(user != null && user.accessLevel == AccessLevel.Admin) { %>
		<div class="d-flex justify-content-end">
			<a href="newProduct.jsp" class="btn btn-primary mb-2">
				Add Product
			</a>
		</div>

	<% } %>

	<table class="table table-striped">
		<tr>
			<th></th>
			<th>Product Name</th>
			<th>Price</th>
			<% if(user != null && user.accessLevel == AccessLevel.Admin) { %>
				<th></th>
			<% } %>
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
				<% if(user != null && user.accessLevel == AccessLevel.Admin) { %>
					<td>
						<button onclick="deleteProd(<%=prod.id%>)" class="btn btn-danger">
							<i class="fa fa-trash-o fa-lg"></i></button>
					</td>
				<% } %>
			</tr>

	<%
		}
	%>
	</table>
</div>
</body>
</html>

<%!

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