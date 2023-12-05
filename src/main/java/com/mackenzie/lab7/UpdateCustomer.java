package com.mackenzie.lab7;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.SQLException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * validators built with the help of https://chat.openai.com/share/7cd08880-e21a-452b-afcc-c903d08b0b7c
 */
@WebServlet(name = "updateCustomer", urlPatterns = {"/update-Customer"})
@MultipartConfig
public class UpdateCustomer extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        boolean success = false;
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String userName = request.getParameter("userName");
            if(userName == null || userName.isEmpty() || firstName == null || firstName.isEmpty() ||
                    lastName == null || lastName.isEmpty() || !isValidEmail(email) ||
                    !isValidPhoneNumber(phone)){
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Set error status code
                return;
            }

            User cust = new User(userId, firstName, lastName, email, phone, userName, null, null);
            success = User.updateUser(cust);

        } catch (SQLException e) {
            System.err.println(e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Set error status code
        }finally {
            if(success){
                response.setStatus(HttpServletResponse.SC_OK); // Set status code 200
            }else if(response.getStatus() != HttpServletResponse.SC_BAD_REQUEST){
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Set error status code
            }
        }

    }

    private static boolean isValidPhoneNumber(String phoneNumber) {
        String regex = "(\\+\\d{1,2} )?\\(?\\d{3}\\)?-\\d{3}-\\d{4}";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(phoneNumber);

        return matcher.matches();
    }

    public static boolean isValidEmail(String email) {
        String regex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(email);

        return matcher.matches();
    }

}
