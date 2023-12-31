<%@ page language="java" import="java.io.*"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.mackenzie.lab7.Connections" %>
<%@ include file="header.jsp"%>


<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null){
		request.setAttribute("loginMessage", null);
		%>
		<script>
			redirect();
		</script>
		<%
	}
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;
		session.removeAttribute("loginMessage");

		if(username == null || password == null || username.isEmpty() || password.isEmpty()){
			session.setAttribute("loginMessage","Invalid username/password");
			return null;
		}
		Connections con = new Connections();
        try
		{
					con.getConnection();  // Make database connection

                    PreparedStatement CIDQuery = con.con.prepareStatement("SELECT userId FROM users WHERE userName = ? AND password = ?");
                    CIDQuery.setString(1, username);
                    CIDQuery.setString(2, password);
                    ResultSet rst = CIDQuery.executeQuery();
                    rst.next();
                    retStr = rst.getString("userId");


		}
		catch(SQLException e)
		{
			out.println(e);
		}
		finally {
			con.closeConnection(); // Close database connection
		}


		if(retStr != null)
		{
			session.setAttribute("authenticatedUser",retStr);
		}
		else{
			session.setAttribute("loginMessage","Invalid username/password");
		}

		return retStr;
	}
%>