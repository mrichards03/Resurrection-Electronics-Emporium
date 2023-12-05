<%@ page trimDirectiveWhitespaces="true" import="java.sql.*,java.io.*" %>
<%@ page import="com.mackenzie.lab7.Connections" %>
<%

// Indicate that we are sending a JPG picture

// Get the image id
String id = request.getParameter("id");

if (id == null)
	return;

int idVal = -1;
try{
	idVal = Integer.parseInt(id);
}
catch(Exception e)
{	out.println("Invalid image id: "+id+" Error: "+e);
	return;
}

String sql = "SELECT productImage FROM Product P  WHERE productId = ?";
Connections con = new Connections();
try
{
	con.getConnection();

	PreparedStatement stmt = con.con.prepareStatement(sql);
	stmt.setInt(1,idVal);

	ResultSet rst = stmt.executeQuery();

	int BUFFER_SIZE = 10000;
	byte[] data = new byte[BUFFER_SIZE];
	InputStream istream = null;

	if (rst.next()) {
		istream = rst.getBinaryStream(1);
	}

	response.reset();
	response.setContentType("image/jpeg");

	if (istream == null) {
		// Load the default image if no image data is found
		String defaultImagePath = request.getServletContext().getRealPath("/")+"img/noImage.jpg";
		File defaultImage = new File(defaultImagePath);
		istream = new FileInputStream(defaultImage);
	}

	try (OutputStream ostream = response.getOutputStream()) {
		if (ostream == null) {
			out.println("Error obtaining output stream.");
			return;
		}

		int count;
		while ((count = istream.read(data, 0, BUFFER_SIZE)) != -1) {
			ostream.write(data, 0, count);
		}
	}catch(Exception e)
	{
		out.println("Error: "+e);
	}
} catch (Exception e) {
	out.println("Image retrieval failed");
	out.println(e);
}finally
{
	con.closeConnection();
}
%>