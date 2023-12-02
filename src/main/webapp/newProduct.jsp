<%@ page import="java.util.List" %>
<%@ page import="com.mackenzie.lab7.*" %>
<%@ page import="java.sql.Blob" %>
<%@ page import="java.io.InputStream" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>
<html>
<head>
    <title>New Product</title>
</head>
<body>
<%
    List<Category> cats = Category.getCategories();
    List<Brand> brands = Brand.getBrands();
    Product prod = new Product(0, "newProduct", "", null,
            cats.stream().findFirst().isPresent() ? cats.stream().findFirst().get() : null,
            brands.stream().findFirst().isPresent() ? brands.stream().findFirst().get() : null);
%>
<form method="post" action="add-Product" enctype="multipart/form-data">
    <table class="table">
        <tbody>
        <tr>
            <td><strong>Name</strong></td>
            <td>
                <input type="text" name="name" value="<%=prod.name%>">
            </td>
        </tr>
        <tr>
            <td><strong>Price</strong></td>
            <td>
                <input type="number" name="price" value="<%=prod.price%>">
            </td>
        </tr>
        <tr>
            <td><strong>Description</strong></td>
            <td>
                <input type="text" name="description" value="<%=prod.desc%>">
            </td>
        </tr>
        <tr>
            <td><strong>Category</strong></td>
            <td>
                <select name="category">
                    <% for (Category cat : cats) { %>
                        <option value="<%=cat.id%>" <%=cat.id == prod.category.id ? "selected" : ""%>><%=cat.name%></option>
                    <% } %>
                </select>
            </td>
        </tr>
        <tr>
            <td><strong>Brand</strong></td>
            <td>
                <select name="brand">
                    <% for (Brand brand : brands) { %>
                        <option value="<%=brand.id%>" <%=brand.id == prod.brand.id ? "selected" : ""%>><%=brand.name%></option>
                    <% } %>
                </select>
            </td>
        </tr>
        <tr>
            <td><strong>Image</strong></td>
            <td>
                <input type="file" name="image">
            </td>
        </tr>
        </tbody>
    </table>
    <button class="btn btn-success" type="submit">Save</button>
    <button class="btn btn-danger">
        <a href="listprod.jsp" class="link-underline link-underline-opacity-0 text-white"> Cancel</a>
    </button>
</form>
</body>
</html>
