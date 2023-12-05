<%@ page import="java.util.List" %>
<%@ page import="com.mackenzie.lab7.PaymentMethod" %>
<%@ page import="java.time.LocalDate" %>

<% List<PaymentMethod> payments = (List<PaymentMethod>) request.getAttribute("payments");
if(payments == null){
    int id = Integer.parseInt(request.getParameter("id"));
    payments = PaymentMethod.getPaymentMethods(id);
}
    PaymentMethod firstValid = payments.stream().filter(f -> f.expirationDate.isAfter(LocalDate.now()))
            .findFirst().orElse(null);
    int first = firstValid == null ? -1 : firstValid.id;
for (PaymentMethod pm : payments) {
    boolean expired = pm.expirationDate.getMonth().getValue() < LocalDate.now().getMonth().getValue()
            && pm.expirationDate.getYear() <= LocalDate.now().getYear();

%>
<li class="list-group-item">
    <input <%=expired ? "disabled":""%>
            class="form-check-input me-1" type="radio" name="paymentNum"
            id="payment<%=pm.id%>" value="<%=pm.id%>" <%=pm.id == first? "checked": ""%>>
    <label for="payment<%=pm.id%>" class="form-check-label">
        <%= pm.paymentType %> ending in <%= pm.cardNumber.substring(pm.cardNumber.length() - 4) %><br>
        Expires <%=pm.expirationDate.getMonth().getValue()%>/<%=pm.expirationDate.getYear()%>
        <% if(expired){%>
        <span class="text-danger">Expired</span>
        <%}%>
    </label>
</li>
<% } %>
<li class="list-group-item">
    <button type="button" data-bs-toggle="modal" data-bs-target="#addPayment" class="btn btn-secondary">
        <i class="fa-solid fa-plus" style="color: #ffffff;"></i>
        Add New Payment Method
    </button>
</li>
