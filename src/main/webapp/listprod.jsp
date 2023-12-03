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
	function submit(){
		document.getElementById('productForm-1').submit();
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
	<% }
		if(isAdmin){%>
			<button type="button" class="btn btn-primary mb-2 d-flex justify-content-end" data-bs-toggle="modal" data-bs-target="#addProduct">
				Add Product
			</button>
	<%}%>
	<div class="row row-cols-1 row-cols-md-<%=isAdmin? "4":"5"%> g-4">

	<%
		for(Product prod : prods.subList(startIndex, Math.min(endIndex, prods.size())))
		{
			request.setAttribute("prod", prod);
			request.setAttribute("isAdmin", isAdmin);
	%>
			<jsp:include page="productCard.jsp"/>
		<%}%>
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
<!--add product modal!-->
<div class="modal fade" id="addProduct" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h1 class="modal-title fs-5" id="staticBackdropLabel">Modal title</h1>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<%
				request.setAttribute("prod", "");
				request.setAttribute("isAdmin", isAdmin);
				%>
				<jsp:include page="productCard.jsp"/>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-success mb-2" data-bs-dismiss="modal" onclick="submit()">Add</button>
				<button class="btn btn-secondary mb-2" data-bs-dismiss="modal">Cancel</button>
			</div>
		</div>
	</div>
</div>
</body>
</html>
