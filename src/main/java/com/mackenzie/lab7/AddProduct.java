/**
 * Created with help from https://www.codejava.net/coding/upload-files-to-database-servlet-jsp-mysql
 */

package com.mackenzie.lab7;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import java.io.*;
import java.util.Optional;

@WebServlet(name = "addProduct", urlPatterns = {"/add-Product"})
@MultipartConfig(maxFileSize = 16177215)    // upload file's size up to 16MB
public class AddProduct extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");
        int categoryId = Integer.parseInt(request.getParameter("category"));
        int brandId = Integer.parseInt(request.getParameter("brand"));

        InputStream inputStream = null;
        // obtains the upload file part in this multipart request
        Part filePart = request.getPart("image");
        if (filePart != null) {
            // obtains input stream of the upload file
            inputStream = filePart.getInputStream();

        }

        Optional<Category> cat = Category.getCategories().stream().filter(f -> f.id == categoryId).findFirst();
        Optional<Brand> brand = Brand.getBrands().stream().filter(f -> f.id == brandId).findFirst();

        Product prod = new Product(price, name, description, inputStream,
                cat.orElse(null),
                brand.orElse(null));
        Product.addProduct(prod);
        response.sendRedirect("listProd.jsp");

    }

}
