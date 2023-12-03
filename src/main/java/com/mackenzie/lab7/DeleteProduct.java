package com.mackenzie.lab7;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.SQLException;

@WebServlet(name = "deleteProduct", urlPatterns = {"/delete-Product"})
@MultipartConfig(maxFileSize = 16177215)    // upload file's size up to 16MB
public class DeleteProduct extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        boolean success = false;
        try{
            int id = Integer.parseInt(request.getParameter("id"));
            success = Product.deleteProduct(id);

        }catch (SQLException e){
            System.err.println(e);
        }finally {
            if(success){
                request.setAttribute("message", "Product deleted successfully!");
                request.setAttribute("success", true);
            }else{
                request.setAttribute("message", "Failed to delete product!");
                request.setAttribute("success", false);
            }
            // Forward to listProd.jsp
            request.getRequestDispatcher("/listProd.jsp").forward(request, response);
        }

    }
}