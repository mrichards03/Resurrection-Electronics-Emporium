/**
 * Created with help from https://www.codejava.net/coding/upload-files-to-database-servlet-jsp-mysql
 */

package com.mackenzie.lab7;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet(name = "saveProduct", urlPatterns = {"/save-Product"})
@MultipartConfig(maxFileSize = 16177215)
public class SaveProduct extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        boolean success = false;
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            double price = Double.parseDouble(request.getParameter("price"));
            String description = request.getParameter("desc");
            int categoryId = Integer.parseInt(request.getParameter("category"));
            int brandId = Integer.parseInt(request.getParameter("brand"));

            InputStream inputStream = null;
            // obtains the upload file part in this multipart request
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                // obtains input stream of the upload file
                inputStream = filePart.getInputStream();

            }

            Optional<Category> cat = Category.getCategories().stream().filter(f -> f.id == categoryId).findFirst();
            Optional<Brand> brand = Brand.getBrands().stream().filter(f -> f.id == brandId).findFirst();

            Product prod = new Product(id, price, name, description, inputStream,
                    cat.orElse(null),
                    brand.orElse(null));

            success = Product.saveProduct(prod);
        } catch (SQLException e) {
            System.err.println(e);
        }finally {
            if(success){
                request.getSession().setAttribute("message", "Product saved successfully!");
                request.getSession().setAttribute("success", true);
            }else{
                request.getSession().setAttribute("message", "Failed to saved product!");
                request.getSession().setAttribute("success", false);
            }
            // Forward to listProd.jsp
            response.sendRedirect("listProd.jsp");
        }

    }

}
