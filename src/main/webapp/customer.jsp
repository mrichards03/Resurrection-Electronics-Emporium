<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="header.jsp" %>
<%@ include file="auth.jsp"%>
<%@ page import="com.mackenzie.lab7.User" %>

<%
	String id = (String) session.getAttribute("authenticatedUser");
	User cust = User.getUserInfo(id);
%>

<form method="post" action="custChanged.jsp">
	<table class="table">
		<tbody>
		<tr>
			<td><strong>Id</strong></td>
			<td>
				<input type="hidden" name="id" value="<%=cust.id%>">
				<%=cust.id%>
			</td>
		</tr>
		<tr>
			<td><strong>First Name</strong></td>
			<td>
				<input type="text" name="firstName" value="<%=cust.firstName%>">
			</td>
		</tr>
		<tr>
			<td><strong>Last Name</strong></td>
			<td>
				<input type="text" name="lastName" value="<%=cust.lastName%>">
			</td>
		</tr>
		<tr>
			<td><strong>Email</strong></td>
			<td>
				<input type="email" name="email" value="<%=cust.email%>">
			</td>
		</tr>
		<tr>
			<td><strong>Phone</strong></td>
			<td>
				<input type="tel" name="phone" value="<%=cust.phone%>">
			</td>
		</tr>
		<tr>
			<td><strong>Address</strong></td>
			<td>
				<input type="text" name="address" value="<%=cust.address%>">
			</td>
		</tr>
		<tr>
			<td><strong>City</strong></td>
			<td>
				<input type="text" name="city" value="<%=cust.city%>">
			</td>
		</tr>
		<tr>
			<td><strong>State</strong></td>
			<td>
				<input type="text" name="state" value="<%=cust.state%>">
			</td>
		</tr>
		<tr>
			<td><strong>Postal Code</strong></td>
			<td>
				<input type="text" name="postCode" value="<%=cust.postCode%>">
			</td>
		</tr>
		<tr>
			<td><strong>Country</strong></td>
			<td>
				<input type="text" name="country" value="<%=cust.country%>">
			</td>
		</tr>
		<tr>
			<td><strong>User Id</strong></td>
			<td>
				<input type="text" name="userId" value="<%=cust.userName%>">
			</td>
		</tr>
		</tbody>
	</table>
	<button class="btn btn-success" type="submit">Save</button>
	<button class="btn btn-danger" type="reset">Cancel</button>
</form>


</body>
</html>
