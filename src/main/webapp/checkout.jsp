<%@ include file="jdbc.jsp"%>

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
            getConnection();
            String query = "SELECT customerId as id FROM customer WHERE userid = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                return rs.getInt("id");
            }
        }catch (Exception e){
            System.err.println(e);
        }
        finally {
            closeConnection();
        }

        return -1;
    }
%>