<%
	String loginMsg = "";
	if(session.getAttribute("loginMessage") != null){
		loginMsg = session.getAttribute("loginMessage").toString();
	}
%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="header.jsp" %>
	<title>Login Screen</title>
</head>
<body>
<div class="d-inline text-center">
	<h3>Please Log in to System</h3>
	<p><%=loginMsg%></p>
	<form name="MyForm" method=post action="validateLogin.jsp">
		<div class="form-group my-2">
			<label for="inputUsername">Username</label>
			<input type="text" class="form-control w-auto d-inline" name="username" id="inputUsername" placeholder="Enter Username">
		</div>
		<div class="form-group">
			<label for="inputPassword">Password</label>
			<input type="password" class="form-control w-auto d-inline" name="password" id="inputPassword" placeholder="Password">
		</div>
		<button type="submit" class="btn btn-primary my-2" name="Submit2" value="Log In">Submit</button>
	</form>
</div>

</body>
</html>

