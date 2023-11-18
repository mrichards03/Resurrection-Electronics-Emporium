<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="header.jsp" %>
<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="com.mackenzie.lab7.Customer" %>

<%
	String id = (String) session.getAttribute("authenticatedUser");
	Customer cust = getCustomerInfo(id);
%>

<table class="table">
	<tbody>
		<tr>
			<td><strong>Id</strong></td>
			<td><%=cust.id%></td>
		</tr>
		<tr>
			<td><strong>First Name</strong></td>
			<td><%=cust.firstName%></td>
		</tr>
		<tr>
			<td><strong>Last Name</strong></td>
			<td><%=cust.lastName%></td>
		</tr>
		<tr>
			<td><strong>Email</strong></td>
			<td><%=cust.email%></td>
		</tr>
		<tr>
			<td><strong>Phone</strong></td>
			<td><%=cust.phone%></td>
		</tr>
		<tr>
			<td><strong>Address</strong></td>
			<td><%=cust.address%></td>
		</tr>
		<tr>
			<td><strong>City</strong></td>
			<td><%=cust.city%></td>
		</tr>
		<tr>
			<td><strong>State</strong></td>
			<td><%=cust.state%></td>
		</tr>
		<tr>
			<td><strong>Postal Code</strong></td>
			<td><%=cust.postCode%></td>
		</tr>
		<tr>
			<td><strong>Country</strong></td>
			<td><%=cust.country%></td>
		</tr>
		<tr>
			<td><strong>User Id</strong></td>
			<td><%=cust.userId%></td>
		</tr>
	</tbody>
</table>

</body>
</html>

<%!
	private Customer getCustomerInfo(String id) {
		Customer customer = new Customer();
		try {
			getConnection();

			String sql = "SELECT * FROM customer WHERE customerId = ?";
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			ResultSet rs = pstmt.executeQuery();
			if(rs.next()){
				customer.id = rs.getInt("customerId");
				customer.firstName = rs.getString("firstName");
				customer.lastName = rs.getString("lastName");
				customer.address = rs.getString("address");
				customer.city = rs.getString("city");
				customer.state = rs.getString("state");
				customer.postCode = rs.getString("postalCode");
				customer.phone = rs.getString("phonenum");
				customer.email = rs.getString("email");
				customer.userId = rs.getString("userid");
				customer.country = rs.getString("country");
			}

		}catch (Exception e) {
			System.err.println(e);
		}finally {
			closeConnection();
		}
		return customer;
	}
%>
