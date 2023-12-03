
<jsp:include page="header.jsp" />
<%@ page import="com.mackenzie.lab7.Order" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@include file="auth.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>Sales</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

    <h1>Sales</h1>

    <canvas id="salesChart" style="position: relative; height:40vh; width:80vw"></canvas>

    <script>
        var ctx = document.getElementById('salesChart').getContext('2d');

        var dates = [];
        var amounts = [];

        <%
        List<Map.Entry<LocalDate, Double>> orders = Order.getDailySales();
        for(Map.Entry<LocalDate, Double> order : orders){
            %>
        dates.push("<%=order.getKey()%>");
        amounts.push(<%=order.getValue()%>);
        <%
    }
    %>

        var chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: dates,
                datasets: [{
                    label: 'Daily Sales',
                    backgroundColor: 'rgb(41,44,194)',
                    borderColor: 'rgb(41,44,194)',
                    data: amounts,
                    responsive: true
                }]
            },
            options: {}
        });
    </script>

    <table class="table border-dark border-1 table-striped">
    <thead class="table-dark">
    <tr>
    <th>Order Date</th>
    <th>Total Amount</th>
    </tr>
    </thead>

<%
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    for(Map.Entry<LocalDate, Double> order : orders){

%>
<tr>
    <td><%=order.getKey()%></td>
    <td><%=currFormat.format(order.getValue())%></td>
</tr>
<% } %>

</body>
</html>

<%!
%>

