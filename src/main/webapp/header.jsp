<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 11/8/2023
  Time: 12:03 PM
  To change this template use File | Settings | File Templates.
--%>
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
            <%
                String authenticated = session.getAttribute("authenticatedUser") == null ?
                        null : session.getAttribute("authenticatedUser").toString();
                if(authenticated == null || authenticated.equals("")){
            %>
            <a class="nav-link" href="login.jsp?logout=0"> Login  </a>
            <%
            }
            else{
            %>
            <a class="nav-link" href="login.jsp?logout=0"> Logout  </a>
            <%
                }

            %>

        </button>
    </div>
</header>











