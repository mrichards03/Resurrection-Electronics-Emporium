<%@ page import="java.io.IOException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%
    String authenticatedUser = null;

    try
    {
        updateProduct(request,session);
        response.sendRedirect("showcart.jsp");
    }
    catch(IOException e)
    {	System.err.println(e); }
%>
<%!
    public void updateProduct(HttpServletRequest request, HttpSession session) throws IOException
    {

            // reading the user input
            String qty = request.getParameter("qty");
            String key = request.getParameter("key");
            HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

            productList.get(key).set(3, qty);
            session.setAttribute("productList", productList);
        }

%>