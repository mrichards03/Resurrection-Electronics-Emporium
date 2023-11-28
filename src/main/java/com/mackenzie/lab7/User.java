package com.mackenzie.lab7;

import java.sql.*;

public class User {
    public int id;
    public String firstName;
    public String lastName;
    public String email;
    public String phone;
    public String address;
    public String city;
    public String state;
    public String postCode;
    public String country;
    public String userName;
    public String password;
    public AccessLevel accessLevel;

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
                        rs.getString("phonenum"), rs.getString("address"),
                        rs.getString("city"), rs.getString("state"),
                        rs.getString("postalCode"), rs.getString("country"),
                        rs.getString("userName"), rs.getString("password"),
                        AccessLevel.values()[rs.getInt("accessLevel")]);
            }


        }catch (Exception e) {
            System.err.println(e);
        }finally {
            connections.closeConnection();
        }
        return user;
    }

    public User(int id, String fn, String ln, String email, String phone, String addr, String city,
                String state, String postCode, String country, String userName, String password, AccessLevel accessLevel)
    {
        this.id = id;
        this.firstName = fn;
        this.lastName = ln;
        this.email = email;
        this.phone = phone;
        this.address = addr;
        this.city = city;
        this.state = state;
        this.postCode = postCode;
        this.country = country;
        this.userName = userName;
        this.password = password;
        this.accessLevel = accessLevel;
    }

    public static void updateUser(User user){
        Connections connections = new Connections();
        try{
            connections.getConnection();

            String query = "UPDATE users SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?, " +
                    "city = ?, state = ?, postalCode = ?, country = ?, userName = ? where userId = ?";
            PreparedStatement ps = connections.con.prepareStatement(query);
            ps.setString(1, user.firstName);
            ps.setString(2, user.lastName);
            ps.setString(3, user.email);
            ps.setString(4, user.phone);
            ps.setString(5, user.address);
            ps.setString(6, user.city);
            ps.setString(7, user.state);
            ps.setString(8, user.postCode);
            ps.setString(9, user.country);
            ps.setString(10, user.userName);
            ps.setInt(11, user.id);
            ps.executeUpdate();

        }catch(SQLException ex){
            System.err.println(ex);
        }
        finally {
            connections.closeConnection();
        }
    }
}

