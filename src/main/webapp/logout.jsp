<%@include file="header.jsp"%>
<%
	// Remove the user from the session to log them out
	session.setAttribute("authenticatedUser",null);
	onLoginChange("");
	response.sendRedirect("index.jsp");		// Re-direct to main page
%>

