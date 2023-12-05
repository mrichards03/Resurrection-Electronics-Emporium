package com.mackenzie.lab7;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.SQLException;

@WebServlet(name = "addAddress", urlPatterns = {"/add-Address"})
@MultipartConfig
public class AddAddress extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        boolean success = false;
        try {
            String fn = request.getParameter("fn");
            String ln = request.getParameter("ln");
            String country = request.getParameter("country");
            String address = request.getParameter("address");
            String state = request.getParameter("state");
            String city = request.getParameter("city");
            String postCode = request.getParameter("postCode");
            int userId = Integer.parseInt(request.getParameter("userId"));

            Address addr = new Address(fn, ln, country, address, state, city, postCode, userId);

            success = Address.addAddress(addr);

        } catch (SQLException e) {
            System.err.println(e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Set error status code
        }finally {
            if(success){
                response.setStatus(HttpServletResponse.SC_OK); // Set status code 200
            }else{
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Set error status code
            }
        }

    }

}
