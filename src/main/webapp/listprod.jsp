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
	int currentPage = 1;
	if (request.getParameter("page") != null) {
		currentPage = Integer.parseInt(request.getParameter("page"));
		currentPage = Math.max(currentPage, 1);
	}


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
		String name = request.getParameter("productName") == null ? "" : request.getParameter("productName");
		List<Product> prods = Product.getProducts(name);
		int itemsPerPage = 10;
		int totalProducts = prods.size();

		// Calculate the start index
		int startIndex = (currentPage - 1) * itemsPerPage;

		// Calculate the end index
		int endIndex = Math.min(startIndex + itemsPerPage, totalProducts);
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

	<div class="row row-cols-1 row-cols-md-5 g-4">

	<%
		for(Product prod : prods.subList(startIndex, Math.min(endIndex, prods.size())))
		{
	%>
		<div class="col">
			<div class="card h-100">
				<img src="displayImage.jsp?id=<%=prod.id%>" class="card-img-top" alt="">
				<div class="card-body d-flex flex-column justify-content-end">
					<h5 class="card-title"><%=prod.name%></h5>
					<p class="card-text overflow-auto" style="max-height: 5rem;"><%=prod.desc%></p>
					<p class="card-text"><%=prod.priceStr%></p>
					<% if(user != null && user.accessLevel == AccessLevel.Admin) { %>
						<button class="btn btn-danger" onclick="deleteProd(<%=prod.id%>)">Delete</button>
					<% }else{ %>
						<a href="addcart.jsp?id=<%=prod.id%>&name=<%=prod.name%>&price=<%=prod.price%>" class="btn btn-success">Add to Cart</a>
					<% } %>
				</div>
			</div>
		</div>


	<%
		}
	%>
	</div>
	<nav aria-label="Page navigation">
		<ul class="pagination">
			<li class="page-item">
				<a class="page-link" href="listprod.jsp?page=<%=Math.max(currentPage - 1, 1)%>&productName=<%=name%>">Previous</a>
			</li>
			<%
				for(int i = 1; i <= prods.size()/itemsPerPage; i++)
				{%>
						<li class="page-item"><a class="page-link" href="listprod.jsp?page=<%=i%>&productName=<%=name%>"><%=i%></a></li>
				<%}%>

			<li class="page-item">
				<a class="page-link"
				   href="listprod.jsp?page=<%=Math.min(currentPage + 1, prods.size()/itemsPerPage)%>&productName=<%=name%>">Next</a>
			</li>

		</ul>
	</nav>
</div>
</body>
</html>
