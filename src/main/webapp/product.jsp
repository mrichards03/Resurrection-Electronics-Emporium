<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<html>
<head>
    <title>Ray's Grocery - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
    // Get product name to search for
// TODO: Retrieve and display info for the product
    String productId = request.getParameter("id");

    String sql = "";

// TODO: If there is a productImageURL, display using IMG tag

// TODO: Retrieve any image stored directly in the database. Note: Call displayImage.jsp with product id as a parameter.

// TODO: Add links to Add to Cart and Continue Shopping
%>

<table class="table table-striped">
    <tr>
        <th>Product Id</th>
        <th>Product Name</th>
        <th>Price</th>
    </tr>

    <%
        getConnection();
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        int pId = Integer.valueOf(request.getParameter("id"));
        String name = "";
        double price = 0;
        String imageURL = "";
        try (PreparedStatement prodQuery = con.prepareStatement("Select productName, productPrice from product where productId = ?")) {
            prodQuery.setInt(1, pId);
            try (ResultSet prodNameResultSet = prodQuery.executeQuery()) {
                if (prodNameResultSet.next()) {
                    price = prodNameResultSet.getDouble("productprice");
                    name = prodNameResultSet.getString("productname");
                    imageURL = prodNameResultSet.getString("productImageURL");
                } else {
                    // Handle the case when no rows are returned
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Handle the exception appropriately
        }
        closeConnection();
    %>

    <tr>
        <td><%=pId%></td>
        <td><%=name%></td>
        <td><%=currFormat.format(price)%></td>
    </tr>

</table>

<img src="<%= imageURL %>" alt="Display Image Failed">

<!--Display Image with displayImage.jsp -->
<jsp:include page="displayImage.jsp">
    <jsp:param name="id" value="<%= pId %>" />
</jsp:include>
<img src="displayImage.jsp" alt="Display Image Failed">


<button class="btn btn-secondary">
    <a class="text-decoration-none text-white" href="listprod.jsp">Continue Shopping</a>
</button>
<button class="btn btn-secondary">
    <a class="text-decoration-none text-white" href="addcart.jsp?id=<%=pId%>&name=<%=name%>&price=<%=price%>">Add to Cart</a>
</button>
</body>
</html>
