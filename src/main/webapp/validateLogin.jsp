<%@ page language="java" import="java.io.*"%>
<%@ page import="java.sql.*" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("showcart.jsp");	// Successful login
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

		// Could make a database connection here and check password but for now just checking for single password

		//if (username.equals("test") && password.equals("test"))
		//	retStr = username;

		// Login using database version
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        	String uid = "sa";
        	String pw = "304#sa#pw";
        try ( Connection con = DriverManager.getConnection(url, uid, pw);
                Statement stmt = con.createStatement();)
                {

                    // Make database connection

                    PreparedStatement CIDQuery = con.prepareStatement("SELECT customerId FROM Customer WHERE userid = ? AND password = ?");
                    CIDQuery.setString(1, username);
                    CIDQuery.setString(2, password);
                    ResultSet rst = CIDQuery.executeQuery();
                    rst.next();
                    retStr = rst.getString("customerId");


		}
		catch(SQLException e)
		{	out.println(e);}
		finally {
			// Close database connection
		}


		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
		}
		else{
			session.setAttribute("loginMessage","Invalid username/password");
			out.print(retStr);}

		return retStr;
	}
%>