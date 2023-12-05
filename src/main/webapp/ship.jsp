<%@ page import="com.mackenzie.lab7.Order" %>
<%@ page import="java.util.List" %>
<%@ page import="com.mackenzie.lab7.OrderProduct" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp"%>
<html>
<head>
    <title>Ship</title>
    <!-- Script from https://jsfiddle.net/bubencode/dn6xc932/ !-->
    <script>
        // Countdown timer for redirecting to another URL after several seconds

        var seconds = 5; // seconds for HTML
        var foo; // variable for clearInterval() function

        function redirect() {
            document.location.href = 'admin.jsp';
        }

        function updateSecs() {
            document.getElementById("seconds").innerHTML = seconds;
            seconds--;
            if (seconds == -1) {
                clearInterval(foo);
                redirect();
            }
        }

        function countdownTimer() {
            foo = setInterval(function () {
                updateSecs()
            }, 1000);
        }

    </script>
</head>
<body>
<%
    List<Order> orders = Order.readyToShip();
    if(orders.isEmpty()){%>
        <script>
            countdownTimer();
        </script>
        <div class="m-4">
            <h1>No Orders to Ship</h1>
            <p>You should be automatically redirected in <span id="seconds">5</span> seconds.</p>
        </div>
    <%}else{%>
<div class="m-4">
    <h1>Orders </h1>
    <table class="table border-dark border-1 table-striped">
        <thead class="table-dark">
        <tr>
            <th>Order Id</th>
            <th>Order Date</th>
            <th>Customer Id</th>
            <th>Customer Name</th>
            <th>Total Amount</th>
            <th></th>
        </tr>
        </thead>

        <%
            for (Order o : orders){
        %>
        <tr>
            <td><%=o.id%></td>
            <td><%=o.date.toLocalDate()%> <%=o.date.toLocalTime()%></td>
            <td><%=o.custId%></td>
            <td><%=o.custName%></td>
            <td><%=o.totalStr%></td>
            <td>
                <button class="btn btn-primary" onclick="location.href='shipProd.jsp?orderId=<%=o.id%>'">Ship</button>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <table class="table table-sm mx-5">
                    <thead class="table-dark">
                    <tr>
                        <th>Product Id</th>
                        <th>Product Name</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Inventory Quantity</th>
                    </tr>
                    </thead>
                    <%
                        for (OrderProduct p : o.products){
                    %>
                    <tr>
                        <td><%=p.product.id%></td>
                        <td><%=p.product.name%></td>
                        <td><%=p.quantity%></td>
                        <td><%=p.product.priceStr%></td>
                        <td><%=p.product.getInvQuant()%></td>
                    </tr>
                    <%
                        }
                    %>
                </table>
            </td>
        </tr>
        <%
            }
        %>
    </table>
</div>
<%}%>
</body>
</html>
