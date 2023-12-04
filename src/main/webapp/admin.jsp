
<jsp:include page="header.jsp" />
<%@ page import="com.mackenzie.lab7.Order" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.stream.Collectors" %>
<%@include file="auth.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>Sales</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<%
    List<Map.Entry<LocalDate, Double>> orders = Order.getDailySales();
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");
    LocalDate startDate;
    LocalDate endDate;
    int totalOrders = Order.getOrders().size();

    if (startDateStr != null && !startDateStr.isEmpty()) {
        startDate = LocalDate.parse(startDateStr);
    } else {
        startDate = orders.get(0).getKey();
    }
    if (endDateStr != null && !endDateStr.isEmpty()) {
        endDate = LocalDate.parse(endDateStr);
    } else {
        endDate = orders.get(orders.size() - 1).getKey();
    }

    // Filter orders based on the selected dates
    if (startDate != null && endDate != null && startDate.isBefore(endDate)) {
        orders = orders.stream()
                .filter(order -> !order.getKey().isBefore(startDate) && !order.getKey().isAfter(endDate))
                .collect(Collectors.toList());
    }
%>
<div class="m-4">
    <div class="row">
        <div class="card col m-2">
            <div class="card-body">
                <h5 class="card-title">Orders ready to ship</h5>
                <p class="card-text"><%=Order.readyToShip()%></p>
            </div>
        </div>
        <div class="card col m-2">
            <div class="card-body">
                <h5 class="card-title">Orders waiting for inventory</h5>
                <p class="card-text"><%=Order.cantShip()%></p>
            </div>
        </div>
        <div class="card col m-2">
            <div class="card-body">
                <h5 class="card-title">Shipped Orders</h5>
                <%int shipped = Order.shipped();%>
                <p class="card-text"><%=shipped%></p>
                <div class="progress" role="progressbar" aria-valuenow="<%=shipped%>>" aria-valuemin="0" aria-valuemax="<%=totalOrders%>>">
                    <div class="progress-bar progress-bar-striped progress-bar-animated" style="width: 25%"><%=((float)shipped/(float)totalOrders) * 100%>%</div>
                </div>
            </div>
        </div>
    </div>
    <h1>Sales</h1>
    <form action="admin.jsp" method="get" class="row align-items-center" style="width: 50%;">
        <div class="form-floating col">
            <input class="form-control" type="date" id="startDate" name="startDate" value="<%=request.getParameter("startDate")%>">
            <label for="startDate" class="ms-2">Start Date</label>
        </div>
       <div class="form-floating col">
           <input class="form-control" type="date" id="endDate" name="endDate" value="<%=request.getParameter("endDate")%>">
           <label for="endDate" class="ms-2">End Date</label>
       </div>
        <input type="submit" value="Filter" class="btn btn-secondary col-2 h-50">
    </form>
    <canvas id="salesChart" style="position: relative; height:20vh; width:50vw"></canvas>

    <script>
        var ctx = document.getElementById('salesChart').getContext('2d');

        var dates = [];
        var amounts = [];

        /*** Gradient ***/
        var gradient = ctx.createLinearGradient(0, 0, 0, 200);
        gradient.addColorStop(0, 'rgb(32,35,175)');
        gradient.addColorStop(1, 'rgba(46,163,238,0.33)');

        <%
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
                    backgroundColor: gradient,
                    borderColor: 'rgb(41,44,194)',
                    data: amounts,
                    responsive: true,
                    fill: true
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
</div>
</body>
</html>

<%!
%>

