<%
if(session.getAttribute("authenticatedUser") == null){
response.sendRedirect("login.jsp");
}
else{
    String username = session.getAttribute("authenticatedUser").toString();
    int custID = getCustId(username);
    response.sendRedirect("order.jsp?customerId="+custID);
}
%>

<%!
    public int getCustId(String username){
        try{
            return Integer.parseInt(username);
        }catch (Exception e){
            System.err.println(e);
        }

        return -1;
    }
%>