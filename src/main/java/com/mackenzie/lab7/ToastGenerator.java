package com.mackenzie.lab7;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(urlPatterns = {"/toastGenerator"})
public class ToastGenerator extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ServletException, IOException {
        String message = request.getParameter("message");
        boolean success = Boolean.parseBoolean(request.getParameter("success"));
        request.setAttribute("message", message);
        request.setAttribute("success", success);
        request.getRequestDispatcher("/toast.jsp").forward(request, response);
    }
}