<%@ include file="jdbc.jsp"%>
<%
    String authenticated = session.getAttribute("authenticatedUser") == null ?
            null : session.getAttribute("authenticatedUser").toString();
    onLoginChange(authenticated);
%>

<link rel="stylesheet" type="text/css" href="bootstrap/css/bootstrap.min.css">
<script type="text/javascript" src="bootstrap/js/bootstrap.bundle.js"></script>

<!--  keeps track of history without duplicates so login can go to previous page -->
<script>
    // Load or create a history array
    var pageHistory = JSON.parse(sessionStorage.pageHistory || '[]');

    // Find this page in history
    var thisPageIndex = pageHistory.indexOf(window.location.pathname);

    // If this page was not in the history, add it to the top of the stack
    if( thisPageIndex < 0){
        pageHistory.push(window.location.pathname);
        thisPageIndex = pageHistory.length -1;

    // Wipe the forward history
    }else if(thisPageIndex < pageHistory.length -1){
        for(; thisPageIndex < pageHistory.length -1;)
            pageHistory.pop();
    }

    // Store history array
    sessionStorage.pageHistory = JSON.stringify(pageHistory);

    // Back button function
    function back(){
        if(thisPageIndex > 0 )
            window.location.href = pageHistory[thisPageIndex - 2];
    }
</script>
<!DOCTYPE html>
<html  data-bs-theme="dark">

<nav class="navbar navbar-expand-lg bg-body-tertiary">
    <div class="container-fluid">
        <a class="navbar-brand" href="index.jsp">Home</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbar" aria-controls="navbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="listprod.jsp" aria-current="page">Shop</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="listorder.jsp" aria-current="page">Orders</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="showcart.jsp" aria-current="page">Cart</a>
                </li>
            </ul>
            <div class="d-flex">
                <% if(LoggedIn){ %>
                <div class="dropdown mx-2">
                    <button class="btn btn-primary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        Welcome <%=custName%>
                    </button>
                    <ul class="dropdown-menu">
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

    public void onLoginChange(String authenticated){
        System.out.println("Login change method visited " + authenticated);
        if(authenticated == null || authenticated.isEmpty()){
            LoginMsg = "Login";
            LoginLink = "login.jsp";
            LoggedIn = false;
        }else{
            LoginMsg = "Logout";
            LoginLink = "logout.jsp";
            custName = getCustName(authenticated);
            LoggedIn = true;
        }
    }

    public String getCustName(String authenticated){
        try{
            getConnection();

            String query = "SELECT firstname FROM customer WHERE userid = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, authenticated);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                return rs.getString("firstname");
            }

        }catch (Exception e){
            System.err.println(e);
        }
        finally {
            closeConnection();
        }

        return null;
    }
%>










