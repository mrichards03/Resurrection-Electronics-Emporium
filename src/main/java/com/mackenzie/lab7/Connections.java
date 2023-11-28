package com.mackenzie.lab7;
import java.sql.*;
public class Connections{
	// User id, password, and server information
	public static final String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	public static final String uid = "sa";
	public static final String pw = "304#sa#pw";
	
	// Do not modify this url
	public static final String urlForLoadData = "jdbc:sqlserver://cosc304_sqlserver:1433;TrustServerCertificate=True";
	
	// Connection
	public Connection con = null;

	public void getConnection() throws SQLException
	{
		try
		{	// Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		}
		catch (java.lang.ClassNotFoundException e)
		{
			throw new SQLException("ClassNotFoundException: " +e);
		}
	
		con = DriverManager.getConnection(url, uid, pw);
		Statement stmt = con.createStatement();
	}
   
	public void closeConnection()
	{
		try {
			if (con != null)
				con.close();
			con = null;
		}
		catch (Exception e)
		{ }
	}
}
