package com.mackenzie.lab7;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
public class PaymentMethod {
    public int id;
    public String cardNumber;
    public String nameOnCard;
    public LocalDate expirationDate;
    public String securityCode;
    public int userId;

    public PaymentMethod(int id, String cardNumber,  String nameOnCard, LocalDate expirationDate, String securityCode, int userId)
    {
        this.id = id;
        this.cardNumber = cardNumber;
        this.nameOnCard = nameOnCard;
        this.expirationDate = expirationDate;
        this.securityCode = securityCode;
        this.userId = userId;
    }

    public PaymentMethod(String cardNumber,  String nameOnCard, LocalDate expirationDate, String securityCode, int userId)
    {
        this.cardNumber = cardNumber;
        this.nameOnCard = nameOnCard;
        this.expirationDate = expirationDate;
        this.securityCode = securityCode;
        this.userId = userId;
    }

    public static List<PaymentMethod> getPaymentMethods(int userId){
        Connections connections = new Connections();
        List<PaymentMethod> paymentMethods = new ArrayList<>();
        try{
            connections.getConnection();

            String sql = "SELECT * FROM paymentmethod join users on paymentmethod.customerId = users.userId WHERE customerId = ?";
            PreparedStatement pstmt = connections.con.prepareStatement(sql);
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while(rs.next()){
                PaymentMethod paymentMethod = new PaymentMethod(rs.getInt("paymentMethodId"),
                        rs.getString("paymentNumber"),
                        rs.getString("nameOnCard"),
                        LocalDate.parse(rs.getString("paymentExpiryDate")),
                        rs.getString("securityCode"),
                        rs.getInt("customerId"));
                paymentMethods.add(paymentMethod);
            }

        }catch (Exception e) {
            System.err.println(e);
        }finally {
            connections.closeConnection();
        }
        return paymentMethods;
    }

    public static boolean addMethod(PaymentMethod pay) throws SQLException {
        Connections connections = new Connections();
        boolean success = false;
        try {
            connections.getConnection();
            String sql = "INSERT INTO paymentmethod (paymentNumber, nameOnCard, paymentExpiryDate, securityCode, customerId) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = connections.con.prepareStatement(sql);
            pstmt.setString(1, pay.cardNumber);
            pstmt.setString(2, pay.nameOnCard);
            pstmt.setString(3, pay.expirationDate.toString());
            pstmt.setString(4, pay.securityCode);
            pstmt.setInt(5, pay.userId);
            success = pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println(e);
            throw e;
        } finally {
            connections.closeConnection();
        }
        return success;
    }
}
