<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 11/8/2023
  Time: 12:03 PM
  To change this template use File | Settings | File Templates.
--%>
<style>
    header{
        background-color: #6494d5;
        display: flex;
        justify-content: space-around;
        align-items: center;
        border-style: solid;
        height: 1.75rem;
    }
    header a {
        text-decoration: none;
        color: black;
    }

    header a:hover{
        background-color: #5472d7;
        padding: 0.25rem;
    }

</style>
<header class="header">
    <a href="listprod.jsp">Shop</a>
    <a href="listorder.jsp">Orders</a>
    <a href="showcart.jsp">Cart</a>
    <a href="login.jsp">
        <%
            String authenticated = session.getAttribute("authenticatedUser") == null ?
                    null : session.getAttribute("authenticatedUser").toString();
            if(authenticated == null || authenticated.equals("")){
                authenticated = "Login";
            }
            out.print("Welcome " + authenticated);

        %>

    </a>
</header>


