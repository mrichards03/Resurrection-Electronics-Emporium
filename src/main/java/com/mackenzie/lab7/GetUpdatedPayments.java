package com.mackenzie.lab7;

import com.mackenzie.lab7.Address;
import com.mackenzie.lab7.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/getUpdatedPayments")
public class GetUpdatedPayments extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId")); // Retrieve userId from request
        List<PaymentMethod> payments = PaymentMethod.getPaymentMethods(userId); // Method to fetch addresses

        request.setAttribute("payments", payments); // Set addresses in request scope
        request.getRequestDispatcher("/paymentsList.jsp").forward(request, response); // Forward to JSP that generates HTML list
    }
}
