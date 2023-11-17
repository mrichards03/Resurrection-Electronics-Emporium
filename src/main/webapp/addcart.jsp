<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	// No products currently in list.  Create a list.
	productList = new HashMap<String, ArrayList<Object>>();
}

// Add new product selected
// Get product information
String id = request.getParameter("id");
String name = request.getParameter("name");
String price = request.getParameter("price");
Integer quantity = Integer.valueOf(1);

// Store product information in an ArrayList
ArrayList<Object> product = new ArrayList<Object>();
product.add(id);
product.add(name);
product.add(price);
product.add(quantity);

// Update quantity if add same item to order again
if (productList.containsKey(id))
{	product = productList.get(id);
	int curAmount = Integer.parseInt(product.get(3).toString());
	product.set(3, Integer.valueOf(curAmount + 1));
}
else
	productList.put(id,product);

session.setAttribute("productList", productList);
%>
<jsp:forward page="showcart.jsp" />