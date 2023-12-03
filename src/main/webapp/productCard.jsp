<%@ page import="java.util.List" %>
<%@ page import="com.mackenzie.lab7.Product" %>
<%@ page import="com.mackenzie.lab7.Category" %>
<%@ page import="com.mackenzie.lab7.Brand" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">

<script>
    function deleteProd(id) {
        if (confirm("Are you sure you want to delete this product?")) {
            window.location.href = "delete-Product?id=" + id;
        }
    }
    // Function to trigger file input when the current image is clicked
    function triggerUpload(id) {
        document.getElementById('imageUpload'+id).click();
    }

    // Function to display the new image as a preview
    function previewImage(id) {
        var file = document.getElementById('imageUpload'+id).files[0];
        var reader = new FileReader();
        reader.onloadend = function() {
            document.getElementById('currentImage'+id).src = reader.result;
        };
        if (file) {
            reader.readAsDataURL(file); // Read the image file as a data URL.
        } else {
            document.getElementById('currentImage'+id).src = ""; // Default image or action
        }
    }
</script>
<html>
<head>
    <title>New Product</title>
</head>
<body>
<%
    boolean isAdmin = (Boolean)request.getAttribute("isAdmin");
    List<Category> cats = Category.getCategories();
    List<Brand> brands = Brand.getBrands();
    Product prod= new Product(-1, 1.00, "newProduct", "", null,
            cats.stream().findFirst().isPresent() ? cats.stream().findFirst().get() : null,
            brands.stream().findFirst().isPresent() ? brands.stream().findFirst().get() : null);

    Object obj = request.getAttribute("prod");
    if(obj instanceof Product) {
        prod = (Product) obj;
    }

    if(isAdmin){%>
        <div class="col">
            <form id="productForm<%=prod.id%>" action="<%=prod.id < 0 ? "add-Product":"save-Product"%>" method="post" enctype="multipart/form-data" class="card h-100">
                <!-- Hidden input to store the product ID -->
                <input type="hidden" name="id" value="<%= prod.id %>" />

                <!-- Image Upload -->
                <!-- Current Image -->
                <img onclick="triggerUpload(<%=prod.id%>)" id="currentImage<%=prod.id%>" src="displayImage.jsp?id=<%= prod.id %>" class="card-img-top" alt="Product Image" style="cursor:pointer;">

                <!-- Hidden File Input -->
                <input type="file" id="imageUpload<%=prod.id%>" name="image" style="display:none;" onchange="previewImage(<%=prod.id%>);">


                <!-- Card Body -->
                <div class="card-body d-flex flex-column justify-content-end">
                    <!-- Category Dropdown -->
                    <div class="form-group">
                        <label for="categorySelect">Category:</label>
                        <select class="form-control" id="categorySelect" name="category">
                            <%-- Iterate over categories to create options --%>
                            <% for(Category cat : cats) { %>
                            <option value="<%= cat.id %>" <%= cat.id == prod.category.id ? "selected" : "" %>><%= cat.name %></option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Brand Dropdown -->
                    <div class="form-group">
                        <label for="brandSelect">Brand:</label>
                        <select class="form-control" id="brandSelect" name="brand">
                            <%-- Iterate over brands to create options --%>
                            <% for(Brand br : brands) { %>
                            <option value="<%= br.id %>" name="brandId" <%= br.id == prod.brand.id ? "selected" : "" %>><%= br.name %></option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Product Name -->
                    <label for="name">Name:</label>
                    <input type="text" id="name" class="form-control mb-2" name="name" value="<%= prod.name %>" required>

                    <!-- Description -->
                    <label for="desc">Description:</label>
                    <textarea class="form-control mb-2" id="desc" name="desc" style="max-height: 5rem;"><%= prod.desc %></textarea>

                    <!-- Price -->
                    <label for="price">Price:</label>
                    <input type="number" min="0" class="form-control mb-2" id="price" name="price" value="<%= prod.price %>" required>

                    <!-- Buttons -->
                    <% if (prod.id > -1) { %>
                    <div class="d-flex justify-content-between">
                        <button type="submit" class="btn btn-primary mb-2">Save</button>
                        <button type="reset" class="btn btn-secondary mb-2">Cancel</button>
                        <button type="button" class="btn btn-danger mb-2" onclick="deleteProd(<%=prod.id%>)">
                            <i class="fa fa-trash"></i>
                        </button>
                    </div>
                    <% }%>
                </div>
            </form>
        </div>


    <%}else{%>
<div class="col">
    <div class="card h-100">
        <img src="displayImage.jsp?id=<%=prod.id%>" class="card-img-top" alt="">
        <div class="card-body d-flex flex-column justify-content-end">
            <div>
                <span class="badge badge-primary"><%=prod.category.name%></span>
                <span class="badge badge-secondary"><%=prod.brand.name%></span>
            </div>
            <h5 class="card-title"><%=prod.name%></h5>
            <p class="card-text overflow-auto" style="max-height: 5rem;"><%=prod.desc%></p>
            <p class="card-text"><%=prod.priceStr%></p>
            <a href="addcart.jsp?id=<%=prod.id%>&name=<%=prod.name%>&price=<%=prod.price%>" class="btn btn-success">Add to Cart</a>
        </div>
    </div>
</div>
    <%}%>

</body>
</html>
