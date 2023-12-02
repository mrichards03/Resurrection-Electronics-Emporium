package com.mackenzie.lab7;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import java.io.*;

@WebServlet(name = "deleteProduct", urlPatterns = {"/delete-Product"})
@MultipartConfig(maxFileSize = 16177215)    // upload file's size up to 16MB
public class DeleteProduct extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Product.deleteProduct(id);
        response.sendRedirect("listProd.jsp");
    }
}