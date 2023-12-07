<%@ page import="com.mackenzie.lab7.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.time.LocalDate" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Checkout</title>
    <script>
        function addAddress(userid){
            var formData = new FormData(document.getElementById('formAddAddress'));

            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'add-Address', true);

            xhr.onload = function() {
                if (xhr.status === 200) {
                    showToast("Address added successfully", true);
                    updateAddressList(userid);
                } else {
                    showToast("Failed to add address", false);
                }
            };

            xhr.send(formData); // Send the form data to the server
        }
        function updateAddressList(userid) {
            var xhr = new XMLHttpRequest();
            xhr.open('GET', '/shop/getUpdatedAddresses?userId=' + encodeURIComponent(userid), true);

            xhr.onload = function() {
                if (xhr.status === 200) {
                    document.getElementById('addressList').innerHTML = xhr.responseText; // Replace the list
                }
            };

            xhr.send();
        }

        function addPayment(userid){
            var myModal = bootstrap.Modal.getInstance(document.getElementById('addPayment'));

            if (!validateFormPayment()) {
                return;
            }
            myModal.hide();
            var formData = new FormData(document.getElementById('formAddPayment'));
            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'add-Payment', true);

            xhr.onload = function() {
                if (xhr.status === 200) {
                    showToast("Payment added successfully", true);
                    updatePaymentList(userid);
                } else {
                    showToast("Failed to add payment", false);
                }
            };

            xhr.send(formData); // Send the form data to the server
        }

        function validateFormPayment() {
            var isValid = true;

            var nameElement = document.getElementById('name');
            var cardName = nameElement.value;
            var numElement = document.getElementById('cardNum');
            var cardNumber = numElement.value;
            var expirElement = document.getElementById('expir');
            var expir = expirElement.value;
            var cvvElement = document.getElementById('cvv');
            var cvv = cvvElement.value;

            // Clear any previous custom validity messages
            nameElement.setCustomValidity("");
            numElement.setCustomValidity("");
            expirElement.setCustomValidity("");
            cvvElement.setCustomValidity("");

            // Validate Cardholder's Name
            if (!cardName.trim()) {
                nameElement.setCustomValidity("Cardholder's name is required.");
                isValid = false;
            }

            // Validate Card Number (16 digits)
            if (!/^\d{16}$/.test(cardNumber)) {
                numElement.setCustomValidity("Card number must be 16 digits.");
                isValid = false;
            }

            var regex = /^(0[1-9]|1[0-2])\/\d{2}$/;
            // Validate Expiration Month (1-12)
            if (!regex.test(expir)) {
                expirElement.setCustomValidity("Expiration date is invalid.");
                isValid = false;
            }

            // Validate CVV (3 digits)
            if (!/^\d{3}$/.test(cvv)) {
                cvvElement.setCustomValidity("CVV must be 3 digits.");
                isValid = false;
            }

            // Trigger the browser's default validity UI
            if (!isValid) {
                nameElement.reportValidity();
                numElement.reportValidity();
                expirElement.reportValidity();
                cvvElement.reportValidity();
            }

            return isValid;
        }


    function updatePaymentList(userid) {
            var xhr = new XMLHttpRequest();
            xhr.open('GET', '/shop/getUpdatedPayments?userId=' + encodeURIComponent(userid), true);

            xhr.onload = function() {
                if (xhr.status === 200) {
                    document.getElementById('paymentList').innerHTML = xhr.responseText; // Replace the list
                }
            };

            xhr.send();
        }
    </script>
</head>
<%
    if(!LoggedIn){
        response.sendRedirect("login.jsp");
        return;
    }
    if(user.addresses == null || user.addresses.isEmpty()){
        user.addresses = Address.getAddresses(user.id);
    }
    if(user.paymentMethods == null || user.paymentMethods.isEmpty()){
        user.paymentMethods = PaymentMethod.getPaymentMethods(user.id);
    }

    // Get the current list of products
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    if(productList == null){ %>

<script>
    countdownTimer('listProd.jsp');
</script>
<div class="m-4">
    <h1>No products in cart</h1>
    <p>You should be automatically redirected in <span id="seconds">5</span> seconds.</p>
</div>

<%
        return;
    }
%>

<body>
<div id="toastContainer"></div>
<div class="m-4 row">
    <div class="col-10">
        <h1>Checkout</h1>

        <form action="order.jsp" method="post">
            <!-- Shipping Addresses -->
            <h5>Your Addresses</h5>
            <ul class="list-group input-group" id="addressList">
                <% for (Address address : user.addresses) { %>
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
            </ul>
            <br/>
            <h5>Payment Method</h5>
            <ul class="list-group input-group" id="paymentList">
                <% PaymentMethod firstValid = user.paymentMethods.stream().filter(f -> f.expirationDate.isAfter(LocalDate.now()))
                        .findFirst().orElse(null);
                    int first = firstValid == null ? -1 : firstValid.id;

                %>

                <jsp:include page="paymentsList.jsp">
                    <jsp:param name="id" value="<%=user.id%>"/>
                </jsp:include>

            </ul>
            <br/>
            <input type="submit" class="btn btn-success" value="Place Order">
            <button type="button" class="btn btn-secondary" onclick="window.location.href='showCart.jsp'">Back to Cart</button>
        </form>

    </div>

    <!-- Cart -->
    <div class="col border">
        <h5 class="mt-2">Your Cart</h5>
        <ul class="list-group list-group-flush">
            <%
                double total = 0;
                Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
                while (iterator.hasNext())
                {	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                    ArrayList<Object> product = entry.getValue();
                    if (product.size() < 4)
                    {
                        out.println("Expected product with four entries. Got: "+product);
                        continue;
                    }
                    Object price = product.get(2);
                    Object itemqty = product.get(3);
                    double pr = 0;
                    int qty = 0;

                    try
                    {
                        pr = Double.parseDouble(price.toString());
                    }
                    catch (Exception e)
                    {
                        out.println("Invalid price for product: "+product.get(0)+" price: "+price);
                    }
                    try
                    {
                        qty = Integer.parseInt(itemqty.toString());
                    }
                    catch (Exception e)
                    {
                        out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
                    }
            %>

            <li class="list-group-item d-flex justify-content-between">
                <p><%=product.get(1)%>(<%=product.get(3)%>)</p>
                <p><%=currFormat.format(pr)%></p>
            </li>
            <%
                    total = total +pr*qty;
                }
            %>
            <li class="list-group-item">
                <div class="d-flex justify-content-between">
                    <p><b>Order Total</b></p>
                    <p><%=currFormat.format(total)%></p>
                </div>

            </li>
        </ul>
    </div>
</div>

<!--add Address modal!-->
<div class="modal fade" id="addAddress" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="staticBackdropLabel">Modal title</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form class="row g-3" id="formAddAddress" novalidate>
                    <input hidden name="userId" value="<%=user.id%>">
                    <div class="col-md-4">
                        <label for="fn" class="form-label">First name</label>
                        <input name="fn" type="text" class="form-control" id="fn" required>
                    </div>
                    <div class="col-md-4">
                        <label for="ln" class="form-label">Last name</label>
                        <input name="ln" type="text" class="form-control" id="ln" required>
                    </div>
                    <div class="col-md-4">
                        <label for="country" class="form-label">Country</label>
                        <input name="country" type="text" class="form-control" id="country" required>
                    </div>
                    <div class="col-md-6">
                        <label for="address" class="form-label">Address</label>
                        <input name="address" type="text" class="form-control" id="address" required>
                    </div>
                    <div class="col-md-6">
                        <label for="city" class="form-label">City</label>
                        <input name="city" type="text" class="form-control" id="city" required>
                    </div>
                    <div class="col-md-3">
                        <label for="state" class="form-label">State/Province</label>
                        <input name="state" type="text" class="form-select" id="state" required>
                    </div>
                    <div class="col-md-3">
                        <label for="postCode" class="form-label">Postal Code</label>
                        <input name="postCode" type="text" class="form-control" id="postCode" required>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success mb-2" data-bs-dismiss="modal" onclick="addAddress(<%=user.id%>)">Add</button>
                <button class="btn btn-secondary mb-2" data-bs-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>

<!--add Payment modal!-->
<div class="modal fade" id="addPayment" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="staticBackdropLabel1">Modal title</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form class="row g-3" id="formAddPayment" novalidate>
                    <input hidden name="userId" value="<%=user.id%>">
                    <div class="">
                        <label for="name" class="form-label">Name on Card</label>
                        <input name="name" type="text" class="form-control" id="name" required>
                    </div>
                    <div class="">
                        <label for="cardNum" class="form-label">Card Number</label>
                        <input name="cardNum" type="text" class="form-control" id="cardNum">
                    </div>
                    <div class="row mt-2">
                        <div class="col">
                            <label for="expir" class="form-label">Expiration Date(MM/YY)</label>
                            <input type="text" placeholder="MM/YY" name="expir" id="expir" class="form-control" />
                        </div>
                        <div class="col">
                            <label for="cvv" class="form-label">Security Code</label>
                            <input name="cvv" type="text" class="form-control" id="cvv">
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-success mb-2" onclick="addPayment(<%=user.id%>)">Add</button>
                        <button class="btn btn-secondary mb-2" data-bs-dismiss="modal">Cancel</button>
                    </div>

                </form>
            </div>
        </div>
    </div>
</div>


</body>
</html>

