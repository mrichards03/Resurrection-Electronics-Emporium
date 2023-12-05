<%@ page import="com.mackenzie.lab7.Address" %>
<%@ page import="java.util.List" %>
<%
    int userId = (int) session.getAttribute("userId");
    List<Address> addresses = Address.getAddresses(userId);
%>
<div>
    <h5>Your Address</h5>
    <ul class="list-group">
        <% for (Address address : addresses) { %>
            <li class="list-group-item">
                <input class="form-check-input me-1" type="radio" name="listGroupRadio" value="" id="firstRadio" checked>
                <div class="form-check-label">
                    <%= address.firstName %> <%= address.lastName %><br>
                    <%= address.address %><br>
                    <%= address.city %>, <%= address.state %> <%= address.postCode %><br>
                    <%= address.country %>
                </div>

            </li>
        <% } %>

    </ul>
    <form action="checkout.jsp" method="post">
        <input type="text" name="first_name" required>
        <input type="text" name="last_name" required>
        <input type="text" name="address" required>
        <input type="text" name="city" required>
        <input type="text" name="state" required>
        <input type="text" name="zip" required>
        <input type="text" name="country" required>
        <button type="submit" class="btn btn-success">Save</button>
    </form>
</div>
