<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@  page trimDirectiveWhitespaces="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mackenzie.lab7.Connections" %>

<html>
<head>
    <title>Ray's Grocery - Product Information</title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<table class="table table-striped">
    <tr>
        <th>Product Id</th>
        <th>Product Name</th>
        <th>Price</th>
    </tr>

    <%
        Connections con = new Connections();
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        int pId = Integer.valueOf(request.getParameter("id"));
        String name = "";
        double price = 0;
        String imageURL = "";
        String productDesc = "";

        try{
            con.getConnection();

            PreparedStatement prodQuery = con.con.prepareStatement("Select * from product where productId = ?");
            prodQuery.setInt(1, pId);
            ResultSet prodNameResultSet = prodQuery.executeQuery();
            if (prodNameResultSet.next()) {
                price = prodNameResultSet.getDouble("productprice");
                name = prodNameResultSet.getString("productname");
                imageURL = prodNameResultSet.getString("productImageURL");
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Handle the exception appropriately
        }finally{
            con.closeConnection();
        }
    %>

    <tr>
        <td><%=pId%></td>
        <td><%=name%></td>
        <td><%=currFormat.format(price)%></td>
    </tr>

</table>
<img src="<%= imageURL %>" alt="">

<img src="displayImage.jsp?id=<%= pId %>" alt="">




<button class="btn btn-secondary">
    <a class="text-decoration-none text-white" href="listprod.jsp">Continue Shopping</a>
</button>
<button class="btn btn-secondary">
    <a class="text-decoration-none text-white" href="addcart.jsp?id=<%=pId%>&name=<%=name%>&price=<%=price%>">Add to Cart</a>
</button>
</body>
</html>

