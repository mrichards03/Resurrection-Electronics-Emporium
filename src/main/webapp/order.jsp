<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="javax.xml.transform.Result" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ page import="com.mackenzie.lab7.Connections" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="header.jsp" %>
<title>YOUR NAME Grocery Order Processing</title>
</head>
<body>

<%
// Get user id
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
Connections con = new Connections();
        try
        {
                con.getConnection();

                String custId = request.getParameter("customerId");
                boolean hasCustId = custId != null && !custId.isEmpty() && !custId.equals("-1");
                PreparedStatement custQuery;
                ResultSet custs;
                int intCustId;
                String custName;
                NumberFormat currFormat = NumberFormat.getCurrencyInstance();

                if(hasCustId && productList != null && !productList.isEmpty()){
                        intCustId = Integer.parseInt(custId);
                        custQuery = con.con.prepareStatement("Select * from users where userId = ?");
                        custQuery.setInt(1, intCustId);
                        custs = custQuery.executeQuery();
                        if(!custs.next()){throw new Exception("No Customers matching that ID");}
                        custName = custs.getString("firstname") + " " + custs.getString("lastname");
                }else if(!hasCustId){
                        throw new Exception("No ID entered");
                }else{
                        throw new Exception("No products in cart.");
                }

                Calendar cal = Calendar.getInstance();
                PreparedStatement pstmt = con.con.prepareStatement("insert into ordersummary (orderdate, totalAmount, userId) values(?, 00.00, ?);", Statement.RETURN_GENERATED_KEYS);

                pstmt.setTimestamp(1, new java.sql.Timestamp(cal.getTimeInMillis()));
                pstmt.setInt(2, intCustId);
                pstmt.execute();
                ResultSet keys = pstmt.getGeneratedKeys();
                keys.next();
                int orderId = keys.getInt(1);
                Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
                double total = 0;

                %>
<h1>Your Order Summary</h1>
<table class="table table-striped">
        <tr>
                <th>Product Id</th>
                <th>Product Name</th>
                <th>Quantity</th>
                <th>Price</th>
                <th>Subtotal</th>
        </tr>

<%

                StringBuilder output = new StringBuilder();
                while (iterator.hasNext())
                {
                        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                        ArrayList<Object> product = entry.getValue();
                        int productId = Integer.parseInt(product.get(0).toString());
                        double price = Double.parseDouble((String) product.get(2));
                        int qty = Integer.parseInt(product.get(3).toString());
                        double pricetimesqty = price * qty;

                        PreparedStatement prod = con.con.prepareStatement("Insert into orderproduct values(?, ?, ?, ?)");
                        prod.setInt(1, orderId);
                        prod.setInt(2, productId);
                        prod.setInt(3, qty);
                        prod.setDouble(4, price);
                        prod.execute();

                        total += pricetimesqty;

                        PreparedStatement prodQuery = con.con.prepareStatement("Select productname from product where productId = ?");
                        prodQuery.setInt(1, productId);
                        ResultSet prodName = prodQuery.executeQuery();
                        prodName.next();
                        String name = prodName.getString("productname");
                        %>

        <tr>
                <td><%=productId%></td>
                <td><%=name%></td>
                <td><%=qty%></td>
                <td><%=currFormat.format(price)%></td>
                <td ><%=currFormat.format(pricetimesqty)%></td>
        </tr>

        <%
                }
                PreparedStatement orderUpdate = con.con.prepareStatement("Update ordersummary set totalAmount = ? where orderid = ?");
                orderUpdate.setDouble(1, total);
                orderUpdate.setInt(2, orderId);
                orderUpdate.execute();
                %>

        <tr>
                <td colspan="4"><b>Order Total</b></td>
                <td><%=currFormat.format(total)%></td>
        </tr>
</table>

        <h1>Order completed.  Will be shipped soon...</h1>
        <h1>Your order reference number is: <%=orderId%></h1>
        <h1>Shipping to user: <%=intCustId%> Name: <%=custName%></h1>

        <%
                session.setAttribute("productList", new HashMap<String, ArrayList<Object>>()); // Clear cart if order placed successfully

        }
        catch (Exception ex)
        {
                if(ex instanceof SQLException){
                        out.println("SQLException: " + ex);
                }
                else if(ex instanceof NumberFormatException){
                        out.println("Invalid Customer ID. Please enter a number.");
                }
                else{
                        out.println("Invalid: " + ex.getMessage());
                }
%>
<p><a href="showcart.jsp">Return to checkout</a></p>
<%

        }
finally {
                con.closeConnection();
        }

%>
</body>
</html>

