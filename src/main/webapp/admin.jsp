
<jsp:include page="header.jsp" />
<%@ page import="com.mackenzie.lab7.Order" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.Map" %>
<%@include file="auth.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>Sales</title>
</head>
<body>

    <h1>Sales</h1>
    <table class="table border-dark border-1 table-striped">
    <thead class="table-dark">
    <tr>
    <th>Order Date</th>
    <th>Total Amount</th>
    </tr>
    </thead>

<%
    List<Map.Entry<LocalDate, String>> orders = Order.getDailySales();
    for(Map.Entry<LocalDate, String> order : orders){

%>
<tr>
    <td><%=order.getKey()%></td>
    <td><%=order.getValue()%></td>
</tr>
<% } %>

</body>
</html>

<%!
%>

