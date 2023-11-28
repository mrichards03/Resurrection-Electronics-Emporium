<%@ page import="com.mackenzie.lab7.User" %>
<%
    int userId = Integer.parseInt(request.getParameter("id"));
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postCode = request.getParameter("postCode");
    String country = request.getParameter("country");
    String userName = request.getParameter("userId");

    User cust = new User(userId, firstName, lastName, email, phone, address, city, state, postCode, country, userName, null, null);
    User.updateUser(cust);

    response.sendRedirect("customer.jsp");
%>
<%!

%>
