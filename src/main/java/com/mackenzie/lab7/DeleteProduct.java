package com.mackenzie.lab7;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.SQLException;

@WebServlet(name = "deleteProduct", urlPatterns = {"/delete-Product"})
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
                request.getSession().setAttribute("message", "Product deleted successfully!");
                request.getSession().setAttribute("success", true);
            }else{
                request.getSession().setAttribute("message", "Failed to deleted product!");
                request.getSession().setAttribute("success", false);
            }
            // Forward to listProd.jsp
            response.sendRedirect("listProd.jsp");
        }

    }
}