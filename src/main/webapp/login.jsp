<jsp:include page="header.jsp" />

<%
	String loginMsg = "";
	if(session.getAttribute("loginMessage") != null){
		loginMsg = session.getAttribute("loginMessage").toString();
	}
%>
<script>
	window.onbeforeunload = onExit();
	function onExit()
	{
		<%session.setAttribute("loginMessage", "");%>
	}

	function showPW() {
		var x = document.getElementById("inputPassword");
		if (x.type === "password") {
			x.type = "text";
		} else {
			x.type = "password";
		}
	}
</script>
<!DOCTYPE html>
<html>
<head>
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
			<br/>
			<input type="checkbox" class="form-check-input me-1" onclick="showPW()">Show Password
		</div>
		<button type="submit" class="btn btn-primary my-2" name="Submit2" value="Log In">Submit</button>
	</form>
</div>

</body>
</html>

