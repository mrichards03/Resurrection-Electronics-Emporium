<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<!DOCTYPE html>
<html>
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script>
	$(document).ready(function() {
		$('form input').on('input', function() {
			$(this).closest('form').submit();
		});
	});

</script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
<head>
<%@ include file="header.jsp" %>
<title>Your Shopping Cart</title>
</head>
<body>

<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
String prodID = request.getParameter("delete");
if(prodID != null && !prodID.equals("")){
	productList.remove(prodID);
}

if (productList == null || productList.isEmpty())
{	out.println("<H1>Your shopping cart is empty!</H1>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
%>
<h1>Your Shopping Cart</h1>
<table class="table">
	<tr>
		<th>Product Id</th>
		<th>Product Name</th>
		<th>Quantity</th>
		<th>Price</th>
		<th>Subtotal</th>
	</tr>
<%
	double total = 0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		%>

	<tr>
		<td><%=product.get(0)%></td>
		<td><%=product.get(1)%></td>
		<td>
			<form method=post action="qtyChanged.jsp" class="w-25">
				<input name="qty" class="form-control" min="1" type="number" value="<%=product.get(3)%>"/>
				<input hidden name="key" value="<%=entry.getKey()%>" />
			</form>
		</td>

			<%
		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;
		
		try
		{
			pr = Double.parseDouble(price.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid price for product: "+product.get(0)+" price: "+price);
		}
		try
		{
			qty = Integer.parseInt(itemqty.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
		}		
%>
		<td><%=currFormat.format(pr)%></td>
		<td><%=currFormat.format(pr*qty)%></td>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="showcart.jsp?delete=<%=entry.getKey()%>" class="btn btn-danger">
				<i class="fa fa-trash-o"></i>
			</a>
		</td>
	</tr>
			<%
		total = total +pr*qty;
	}
	%>
	<tr>
		<td colspan="4"><b>Order Total</b></td>
		<td><%=currFormat.format(total)%></td>
	</tr>
</table>
<button class="btn btn-secondary">
	<a class="text-decoration-none text-white" href="checkout.jsp">Check Out</a>
</button>
		<%
}
%>
<button class="btn btn-secondary">
	<a class="text-decoration-none text-white" href="listprod.jsp">Continue Shopping</a>
</button>
</body>
</html>
