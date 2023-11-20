        <%@ page import="java.text.NumberFormat" %>
<jsp:include page="header.jsp" />
<%@ include file="jdbc.jsp"%>
        <%@include file="auth.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

    <h1>Order List</h1>
    <table class="table border-dark border-1 table-striped">
    <thead class="table-dark">
    <tr>
    <th>Order Date</th>
    <th>Total Amount</th>
    </tr>
    </thead>

<%
                getConnection();

                NumberFormat currFormat = NumberFormat.getCurrencyInstance();
                PreparedStatement stmt = con.prepareStatement("SELECT YEAR(orderDate) as year, MONTH(orderDate) as month, DAY(orderDate) as day, SUM(totalAmount) as totalOrderAmount FROM ordersummary GROUP BY YEAR(orderDate), MONTH(orderDate), DAY(orderDate) HAVING SUM(totalAmount) > 0 ORDER BY year ASC, month ASC, day ASC");
                ResultSet rst = stmt.executeQuery();
                String date = null;
                String total=null;
                while (rst.next()) {
                    String date1 = rst.getString("year");
                    String date2 = rst.getString("month");
                    String date3 = rst.getString("day");
                    date = String.format("%s/%s/%s", date1, date2, date3);
                    total = currFormat.format(rst.getDouble("totalOrderAmount"));

                %>
<tr>
    <td><%=date%></td>
    <td><%=total%></td>
</tr>
<% } %>

</body>
</html>

