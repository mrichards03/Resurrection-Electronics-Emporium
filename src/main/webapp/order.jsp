<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="javax.xml.transform.Result" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<%@ include file="header.jsp" %>
<head>
<title>YOUR NAME Grocery Order Processing</title>
</head>
<body>

<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw";

        try ( Connection con = DriverManager.getConnection(url, uid, pw);
        Statement stmt = con.createStatement();)
        {
                boolean hasCustId = custId != null && !custId.equals("");
                PreparedStatement custQuery = null;
                ResultSet custs = null;
                int intCustId = 0;
                String custName = "";
                NumberFormat currFormat = NumberFormat.getCurrencyInstance();

                if(hasCustId && productList != null && !productList.isEmpty()){
                        intCustId = Integer.parseInt(custId);
                        custQuery = con.prepareStatement("Select * from customer where customerId = ?");
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
                PreparedStatement pstmt = con.prepareStatement("insert into ordersummary (orderdate, totalAmount, customerId) values(?, 00.00, ?);", Statement.RETURN_GENERATED_KEYS);

                pstmt.setTimestamp(1, new java.sql.Timestamp(cal.getTimeInMillis()));
                pstmt.setInt(2, intCustId);
                pstmt.execute();
                ResultSet keys = pstmt.getGeneratedKeys();
                keys.next();
                int orderId = keys.getInt(1);
                Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
                double total = 0;

                StringBuilder output = new StringBuilder("Your Order Summary</h1><table><tr><th>Product Id</th>" +
                        "<th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");
                while (iterator.hasNext())
                {
                        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                        ArrayList<Object> product = entry.getValue();
                        int productId = Integer.parseInt(product.get(0).toString());
                        double price = Double.parseDouble((String) product.get(2));
                        int qty = Integer.parseInt(product.get(3).toString());
                        double pricetimesqty = price * qty;

                        PreparedStatement prod = con.prepareStatement("Insert into orderproduct values(?, ?, ?, ?)");
                        prod.setInt(1, orderId);
                        prod.setInt(2, productId);
                        prod.setInt(3, qty);
                        prod.setDouble(4, price);
                        prod.execute();

                        total += pricetimesqty;

                        PreparedStatement prodQuery = con.prepareStatement("Select productname from product where productId = ?");
                        prodQuery.setInt(1, productId);
                        ResultSet prodName = prodQuery.executeQuery();
                        prodName.next();
                        String name = prodName.getString("productname");
                        output.append(String.format("<tr><td>%d</td><td>%s</td><td align=\"center\">%d</td>" +
                                "<td align=\"right\">%s</td><td align=\"right\">%s</td></tr>\n", productId, name,
                                qty, currFormat.format(price), currFormat.format(pricetimesqty)));
                }
                PreparedStatement orderUpdate = con.prepareStatement("Update ordersummary set totalAmount = ? where orderid = ?");
                orderUpdate.setDouble(1, total);
                orderUpdate.setInt(2, orderId);
                orderUpdate.execute();
                output.append(String.format("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>" +
                        "<td aling=\"right\">%s</td></tr>\n" +
                        "</table>\n", currFormat.format(total)));

                output.append(String.format("<h1>Order completed.  Will be shipped soon...</h1>\n" +
                        "<h1>Your order reference number is: %d</h1>\n" +
                        "<h1>Shipping to customer: %d Name: %s</h1>", orderId, intCustId, custName));

                out.println(output);
                session.invalidate(); // Clear cart if order placed successfully

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

                out.print("<p><a href=\"checkout.jsp\">Return to checkout</a></p>");

        }


%>
</body>
</html>

