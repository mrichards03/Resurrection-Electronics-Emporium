<!DOCTYPE html>
<html>
<head>
<%@ include file="header.jsp" %>
<title>Ray's Grocery CheckOut Line</title>
</head>
<body>
<%
if(session.getAttribute("authenticatedUser") == null){
response.sendRedirect("login.jsp");
}
else{
response.sendRedirect("order.jsp?customerId");
}
%>

<input type="text" name="customerId" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset">
</form>

</body>
</html>

