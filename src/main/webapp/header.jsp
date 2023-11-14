
<%
    String authenticated = session.getAttribute("authenticatedUser") == null ?
            null : session.getAttribute("authenticatedUser").toString();
    onLoginChange(authenticated);
%>

<link rel="stylesheet" type="text/css" href="bootstrap/css/bootstrap.min.css">
<header class="d-flex flex-wrap align-items-center justify-content-center justify-content-md-between py-2 bg-dark text-white mb-4 border-bottom">
    <ul class="nav nav-pills">
        <li class="nav-item">
            <a class="nav-link text-white" href="listprod.jsp">Shop</a>
        </li>
        <li class="nav-item">
            <a class="nav-link text-white" href="listorder.jsp">Orders</a>
        </li>
        <li class="nav-item">
            <a class="nav-link text-white" href="showcart.jsp">Cart</a>
        </li>
    </ul>
    <div class="col-md-3 text-end">
        <button class="btn btn-primary">
            <a class="nav-link" href="<%=LoginLink%>"> <%=LoginMsg%> </a>
        </button>
    </div>
</header>

<%!
    String LoginMsg = "";
    String LoginLink = "";

    public void onLoginChange(String authenticated){
        System.out.println("Login change method visited");
        if(authenticated == null || authenticated.equals("")){
            LoginMsg = "Login";
            LoginLink = "login.jsp";
        }else{
            LoginMsg = "Logout";
            LoginLink = "login.jsp?logout=1";
        }
    }

%>










