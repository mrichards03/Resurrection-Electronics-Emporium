package com.mackenzie.lab7;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;

@WebServlet(name = "addPayment", urlPatterns = {"/add-Payment"})
@MultipartConfig
public class AddPayment extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        boolean success = false;
        try {
            String cardNum = request.getParameter("cardNum");
            String name = request.getParameter("name");
            String expir = request.getParameter("expir");
            String cvv = request.getParameter("cvv");
            int userId = Integer.parseInt(request.getParameter("userId"));

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/yy");
            YearMonth yearMonth = YearMonth.parse(expir, formatter);
            LocalDate date = yearMonth.atDay(1);

            PaymentMethod pay = new PaymentMethod(cardNum, name, date, cvv, userId);

            success = PaymentMethod.addMethod(pay);

        } catch (Exception e) {
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
