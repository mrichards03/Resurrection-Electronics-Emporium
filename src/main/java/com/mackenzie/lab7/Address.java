package com.mackenzie.lab7;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Address {
    public int id;
    public String firstName;
    public String lastName;
    public String address;
    public String city;
    public String state;
    public String postCode;
    public String country;
    public int userId;

    /***
     *
     * @param id
     * @param fn
     * @param ln
     * @param address
     * @param city
     * @param state
     * @param postCode
     * @param country
     * @param userId
     */
    public Address(int id, String fn, String ln, String address, String city, String state, String postCode, String country, int userId)
    {
        this.id = id;
        this.firstName = fn;
        this.lastName = ln;
        this.address = address;
        this.city = city;
        this.state = state;
        this.postCode = postCode;
        this.country = country;
        this.userId = userId;
    }

    public Address(String fn, String ln, String address, String city, String state, String postCode, String country, int userId)
    {
        this.firstName = fn;
        this.lastName = ln;
        this.address = address;
        this.city = city;
        this.state = state;
        this.postCode = postCode;
        this.country = country;
        this.userId = userId;
    }

    public static boolean updateAddress(Address address){
        boolean success = false;
        Connections connections = new Connections();
        try{
            connections.getConnection();

            String sql = "UPDATE address SET firstName = ?, lastName = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ? WHERE addressId = ?";
            PreparedStatement pstmt = connections.con.prepareStatement(sql);
            pstmt.setString(1, address.firstName);
            pstmt.setString(2, address.lastName);
            pstmt.setString(3, address.address);
            pstmt.setString(4, address.city);
            pstmt.setString(5, address.state);
            pstmt.setString(6, address.postCode);
            pstmt.setString(7, address.country);
            pstmt.setInt(8, address.id);
            int count = pstmt.executeUpdate();
            success = count > 0;

        }catch (Exception e) {
            System.err.println(e);
        }finally {
            connections.closeConnection();
        }
        return success;
    }

    public static boolean deleteAddress(Address address){
        boolean success = false;
        Connections connections = new Connections();
        try{
            connections.getConnection();

            String sql = "DELETE FROM address WHERE addressId = ?";
            PreparedStatement pstmt = connections.con.prepareStatement(sql);
            pstmt.setInt(1, address.id);
            int count = pstmt.executeUpdate();
            success = count > 0;

        }catch (Exception e) {
            System.err.println(e);
        }finally {
            connections.closeConnection();
        }
        return success;
    }

    public static boolean addAddress(Address address) throws SQLException {
        boolean success = false;
        Connections connections = new Connections();
        try{
            connections.getConnection();

            String sql = "INSERT INTO address (firstName, lastName, address, city, state, postalCode, country, customerId) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = connections.con.prepareStatement(sql);
            pstmt.setString(1, address.firstName);
            pstmt.setString(2, address.lastName);
            pstmt.setString(3, address.address);
            pstmt.setString(4, address.city);
            pstmt.setString(5, address.state);
            pstmt.setString(6, address.postCode);
            pstmt.setString(7, address.country);
            pstmt.setInt(8, address.userId);
            int count = pstmt.executeUpdate();
            success = count > 0;

        }catch (Exception e) {
            System.err.println(e);
            throw e;
        }finally {
            connections.closeConnection();
        }
        return success;
    }

    public static List<Address> getAddresses(int userId){
        Connections connections = new Connections();
        List<Address> addresses = new ArrayList<>();
        try {
            connections.getConnection();

            String sql = "SELECT * FROM address WHERE customerId = ?";
            PreparedStatement pstmt = connections.con.prepareStatement(sql);
            pstmt.setInt(1, userId);
            ResultSet rst = pstmt.executeQuery();
            while (rst.next()){
                addresses.add(new Address(rst.getInt("addressId"), rst.getString("firstName"),
                        rst.getString("lastName"), rst.getString("address"),
                        rst.getString("city"), rst.getString("state"),
                        rst.getString("postalCode"), rst.getString("country"),
                        rst.getInt("customerId")));
            }

        }catch (Exception e) {
            System.err.println(e);
        }finally {
            connections.closeConnection();
        }
        return addresses;
    }
}
