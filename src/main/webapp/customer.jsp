<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="header.jsp" %>
<%@ include file="auth.jsp"%>
<%@ page import="com.mackenzie.lab7.User" %>
<%@ page import="com.mackenzie.lab7.Address" %>

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
		<tr>
			<td><strong>User Id</strong></td>
			<td>
				<input type="text" name="userId" value="<%=cust.userName%>">
			</td>
		</tr>
		</tbody>
	</table>
	<br/>
	<!-- Addresses !-->
	<h3>Addresses</h3>
	<table class="table">
		<thead>
		<tr>
			<th>Street</th>
			<th>City</th>
			<th>State</th>
			<th>Zip</th>
			<th>Country</th>
		</tr>
		</thead>
		<tbody>
		<%
			ArrayList<Address> addresses = cust.getAddresses();
			for (Address address : addresses) {
		%>
		<tr>
			<td>
				<input type="text" name="street" value="<%=address.address%>">
			</td>
			<td>
				<input type="text" name="city" value="<%=address.city%>">
			</td>
			<td>
				<input type="text" name="state" value="<%=address.state%>">
			</td>
			<td>
				<input type="text" name="zip" value="<%=address.postCode%>">
			</td>
			<td>
				<input type="text" name="country" value="<%=address.country%>">
			</td>
		</tr>
		<% } %>
		</tbody>
	<button class="btn btn-success" type="submit">Save</button>
	<button class="btn btn-danger" type="reset">Cancel</button>
</form>


</body>
</html>
