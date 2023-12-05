package com.mackenzie.lab7;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class User {
    public int id;
    public String firstName;
    public String lastName;
    public String email;
    public String phone;
    public String userName;
    public String password;
    public AccessLevel accessLevel;
    public List<Address> addresses;
    public List<PaymentMethod> paymentMethods;

    public static User getUserInfo(String id) {
        Connections connections = new Connections();
        User user = null;
        try {
            connections.getConnection();

            String sql = "SELECT * FROM users WHERE userId = ?";
            PreparedStatement pstmt = connections.con.prepareStatement(sql);
            pstmt.setString(1, id);
            ResultSet rs = pstmt.executeQuery();
            if(rs.next()){
                user = new User(rs.getInt("userId"), rs.getString("firstName"),
                        rs.getString("lastName"), rs.getString("email"),
                        rs.getString("phonenum"), rs.getString("userName"),
                        rs.getString("password"),
                        AccessLevel.values()[rs.getInt("accessLevel")]);
            }


        }catch (Exception e) {
            System.err.println(e);
        }finally {
            connections.closeConnection();
        }
        return user;
    }

    public User(int id, String fn, String ln, String email, String phone, String userName, String password, AccessLevel accessLevel)
    {
        this.id = id;
        this.firstName = fn;
        this.lastName = ln;
        this.email = email;
        this.phone = phone;
        this.userName = userName;
        this.password = password;
        this.accessLevel = accessLevel;
    }

    public static boolean updateUser(User user) throws SQLException {
        boolean success = false;
        Connections connections = new Connections();
        try{
            connections.getConnection();

            String query = "UPDATE users SET firstName = ?, lastName = ?, email = ?, phonenum = ?, userName = ? where userId = ?";
            PreparedStatement ps = connections.con.prepareStatement(query);
            ps.setString(1, user.firstName);
            ps.setString(2, user.lastName);
            ps.setString(3, user.email);
            ps.setString(4, user.phone);
            ps.setString(5, user.userName);
            ps.setInt(6, user.id);
            success = ps.executeUpdate() > 0;

        }catch(SQLException ex){
            System.err.println(ex);
            throw ex;
        }
        finally {
            connections.closeConnection();
        }
        return success;
    }

    public ArrayList<Address> getAddresses() {
        return (ArrayList<Address>) Address.getAddresses(this.id);
    }
}

