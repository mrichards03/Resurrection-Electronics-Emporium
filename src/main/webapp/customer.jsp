
<%@ include file="header.jsp" %>
<%@ include file="auth.jsp"%>
<%@ page import="com.mackenzie.lab7.User" %>

<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
	<script>
		function updateCustomer(){
			var formData = new FormData(document.getElementById('cust'));

			var xhr = new XMLHttpRequest();
			xhr.open('POST', 'update-Customer', true);

			xhr.onload = function() {
				if (xhr.status === 200) {
					showToast("Profile updated successfully", true);
				} else if(xhr.status === 400) {
					showToast("Failed to update profile. Invalid inputs", false);
				}else{
					showToast("Failed to update profile", false);
				}
			};

			xhr.send(formData); // Send the form data to the server
		}
	</script>
</head>
<body>
<div id="toastContainer"></div>
<%
	String id = (String) session.getAttribute("authenticatedUser");
	User cust = User.getUserInfo(id);
%>

<form method="post" id="cust">
	<table class="table input-group">
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
			<td><strong>User Name</strong></td>
			<td>
				<input type="text" name="userName" value="<%=cust.userName%>">
			</td>
		</tr>
		</tbody>
	</table>
	<br/>

	<button class="btn btn-success" type="button" onclick="updateCustomer()">Save</button>
	<button class="btn btn-danger" type="reset">Cancel</button>
</form>


</body>
</html>
