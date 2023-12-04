<%@ page import="com.mackenzie.lab7.User" %>
<%@ page import="com.mackenzie.lab7.AccessLevel" %>
<%
    String username = session.getAttribute("authenticatedUser") == null ?
            null : session.getAttribute("authenticatedUser").toString();
    onLoginChange(username);
%>

<link rel="stylesheet" type="text/css" href="bootstrap/css/bootstrap.min.css">
<script type="text/javascript" src="bootstrap/js/bootstrap.bundle.js"></script>
<!--  keeps track of history without duplicates so login can go to previous page -->
<script>
    var url = window.location.pathname;
    addPage(url);

    // Back button function
    function back(){
        var pageHistory = JSON.parse(sessionStorage.pageHistory || '[]');

        // Find this page in history
        var thisPageIndex = pageHistory.indexOf(url);
        if(thisPageIndex > 1 )
            window.location.href = pageHistory[thisPageIndex - 2];
    }

    function addPage(url){
        var pageHistory = JSON.parse(sessionStorage.pageHistory || '[]');

        // Find this page in history
        var thisPageIndex = pageHistory.indexOf(url);

        if(url === "/shop/addcart.jsp"){ //don't include in-between pages
            url = "/shop/showcart.jsp";
        }
        // If this page was not in the history, add it to the top of the stack
        if( thisPageIndex < 0){
            pageHistory.push(url);
            thisPageIndex = pageHistory.length -1;

            // Wipe the forward history
        }else if(thisPageIndex < pageHistory.length -1){
            for(; thisPageIndex < pageHistory.length -1;)
                pageHistory.pop();
        }

        // Store history array
        sessionStorage.pageHistory = JSON.stringify(pageHistory);
    }

</script>

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
            <div class="col">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <% if(isAdmin){ %>
                    <li class="nav-item">
                        <a class="nav-link" href="listProd.jsp" aria-current="page">Products</a>
                    </li>
                    <% } %>
                    <li class="nav-item">
                        <a class="nav-link" href="listorder.jsp" aria-current="page">
                            <%=isAdmin ? "Orders":"My Orders"%>
                        </a>
                    </li>
                    <% if(!isAdmin){ %>
                    <li class="nav-item">
                        <a class="nav-link" href="showcart.jsp" aria-current="page">Cart</a>
                    </li>
                    <% } %>
                </ul>
            </div>
            <div class="col-10 justify-content-between">
                <form class="d-flex m-auto" role="search" action="listprod.jsp">
                    <input class="form-control me-2" type="search" placeholder="Search" name="productName" aria-label="Search">

                    <button class="btn btn-outline-success btn-success" type="submit">
                        <svg xmlns="http://www.w3.org/2000/svg" height="16" width="16" viewBox="0 0 512 512">
                            <path d="M416 208c0 45.9-14.9 88.3-40 122.7L502.6 457.4c12.5 12.5 12.5 32.8 0 45.3s-32.8 12.5-45.3 0L330.7 376c-34.4 25.2-76.8 40-122.7 40C93.1 416 0 322.9 0 208S93.1 0 208 0S416 93.1 416 208zM208 352a144 144 0 1 0 0-288 144 144 0 1 0 0 288z"/>
                        </svg>
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










