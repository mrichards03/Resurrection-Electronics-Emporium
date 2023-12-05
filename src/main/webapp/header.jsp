<%@ page import="com.mackenzie.lab7.User" %>
<%@ page import="com.mackenzie.lab7.AccessLevel" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%
    String username = session.getAttribute("authenticatedUser") == null ?
            null : session.getAttribute("authenticatedUser").toString();
    onLoginChange(username);
%>

<link rel="stylesheet" type="text/css" href="bootstrap/css/bootstrap.min.css">
<script type="text/javascript" src="bootstrap/js/bootstrap.bundle.js"></script>
<script src="https://kit.fontawesome.com/032953b54f.js" crossorigin="anonymous"></script>
<script src="js/global.js"></script>

<!DOCTYPE html>
<html  data-bs-theme="dark">

<nav class="navbar navbar-expand-lg bg-body-tertiary z-3">
    <div class="container-fluid">
        <a class="navbar-brand" href=<%=isAdmin ? "admin.jsp" : "listProd.jsp"%>>
            <%=isAdmin ? "Home" : "Shop"%></a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbar" aria-controls="navbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbar">
            <div class="col me-4">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <% if(isAdmin){ %>
                    <li class="nav-item">
                        <a class="nav-link" href="listProd.jsp" aria-current="page">Products</a>
                    </li>
                    <% } %>
                    <%if(LoggedIn){ %>
                    <li class="nav-item">
                        <a class="nav-link" href="listorder.jsp" aria-current="page">
                            <%=isAdmin ? "Orders":"My Orders"%>
                        </a>
                    </li>
                    <% } %>
                    <% if(!isAdmin){ %>
                    <li class="nav-item">
                        <a class="nav-link" href="showcart.jsp" aria-current="page">
                            <%
                                HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
                                boolean empty = productList == null || productList.isEmpty();
                            %>
                            Cart
                            <i class="fa-solid fa-cart-shopping <%=empty ? "":"fa-beat"%>" style="color: #ffffff;"></i>
                        </a>
                    </li>
                    <% } %>
                </ul>
            </div>
            <div class="col-8 justify-content-between">
                <form class="d-flex m-auto" role="search" action="listprod.jsp">
                    <input class="form-control me-2" type="search" placeholder="Search" name="productName" aria-label="Search">

                    <button class="btn btn-outline-success btn-success" type="submit">
                        <i class="fa-solid fa-magnifying-glass" style="color: #000000"></i>
                    </button>
                </form>
            </div>
            <div class="d-flex justify-content-end col">
                <% if(LoggedIn){ %>
                <div class="dropdown mx-2 z-3">
                    <button class="btn btn-primary dropdown-toggle z-3" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        Welcome <%=custName%>
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="customer.jsp">Profile</a></li>
                        <li><a class="dropdown-item" href="<%=LoginLink%>"><%=LoginMsg%></a></li>
                    </ul>
                </div>

                <% }else{ %>
                <button class="btn btn-primary">
                    <a class="nav-link" href="<%=LoginLink%>"> <%=LoginMsg%> </a>
                </button>
                <% } %>
            </div>
        </div>
    </div>
</nav>

</html>
<%!
    String LoginMsg = "";
    String LoginLink = "";
    String custName = "";
    boolean LoggedIn = false;
    User user;
    boolean isAdmin = false;

    public void onLoginChange(String username){
        if(username == null || username.isEmpty()){
            LoginMsg = "Login";
            LoginLink = "login.jsp";
            LoggedIn = false;
            isAdmin = false;
            user = null;
        }else{
            user = User.getUserInfo(username);
            LoginMsg = "Logout";
            LoginLink = "logout.jsp";
            custName = user.firstName;
            LoggedIn = true;
            isAdmin = user.accessLevel == AccessLevel.Admin;
        }
    }

%>










