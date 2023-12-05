<%@ page import="java.util.List" %>
<%@ page import="com.mackenzie.lab7.Address" %>

<%
    List<Address> addresses = (List<Address>) request.getAttribute("addresses");
    for (Address address : addresses) {
%>
<li class="list-group-item">
    <input class="form-check-input me-1" type="radio" name="addressNum" id="address<%=address.id%>" value="<%=address.id%>" checked>
    <label for="address<%=address.id%>" class="form-check-label">
        <%= address.firstName %> <%= address.lastName %><br>
        <%= address.address %><br>
        <%= address.city %>, <%= address.state %> <%= address.postCode %><br>
        <%= address.country %>
    </label>

</li>
<% } %>
<li class="list-group-item">
    <button type="button" data-bs-toggle="modal" data-bs-target="#addAddress" class="btn btn-secondary">
        <i class="fa-solid fa-plus" style="color: #ffffff;"></i>
        Add New Address
    </button>
</li>