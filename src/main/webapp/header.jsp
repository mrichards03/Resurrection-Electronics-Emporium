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

<nav class="navbar navbar-expand-lg bg-body-tertiary">
    <div class="container-fluid">
        <a class="navbar-brand" href=<%=isAdmin ? "admin.jsp" : "listProd.jsp"%>>
            <%=isAdmin ? "Home" : "Shop"%></a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbar" aria-controls="navbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbar">
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
            <div class="d-flex">
                <% if(LoggedIn){ %>
                <div class="dropdown mx-2">
                    <button class="btn btn-primary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
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










