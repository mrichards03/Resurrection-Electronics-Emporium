<%@ include file="header.jsp"%>

<%
	if(isAdmin){
		response.sendRedirect("admin.jsp");
	}else{
		response.sendRedirect("listProd.jsp");
	}
%>


