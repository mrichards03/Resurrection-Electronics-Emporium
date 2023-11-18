<%@ page import="com.mackenzie.lab7.Customer" %>
<%@ include file="jdbc.jsp"%>
<%
    String customerId = request.getParameter("id");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postCode = request.getParameter("postCode");
    String country = request.getParameter("country");
    String userId = request.getParameter("userId");

    Customer cust = createCust(customerId, firstName, lastName, email, phone, address, city, state, postCode, country, userId);
    updateCust(cust);

    response.sendRedirect("customer.jsp");
%>
<%!
    private Customer createCust(String id, String fn, String ln, String email, String phone, String addr, String city,
                                String state, String postCode, String country, String userId){
        int idInt = Integer.parseInt(id);
        Customer cust = new Customer();
        cust.id = idInt;
        cust.firstName = fn;
        cust.lastName = ln;
        cust.email = email;
        cust.phone = phone;
        cust.address = addr;
        cust.city = city;
        cust.state = state;
        cust.postCode = postCode;
        cust.country = country;
        cust.userId = userId;
        return cust;
    }

    private void updateCust(Customer cust){
        try{
            getConnection();

            String query = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?, " +
                    "city = ?, state = ?, postalCode = ?, country = ?, userid = ? where customerId = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, cust.firstName);
            ps.setString(2, cust.lastName);
            ps.setString(3, cust.email);
            ps.setString(4, cust.phone);
            ps.setString(5, cust.address);
            ps.setString(6, cust.city);
            ps.setString(7, cust.state);
            ps.setString(8, cust.postCode);
            ps.setString(9, cust.country);
            ps.setString(10, cust.userId);
            ps.setInt(11, cust.id);
            ps.executeUpdate();

        }catch(SQLException ex){
            System.err.println(ex);
        }
        finally {
            closeConnection();
        }
    }
%>
