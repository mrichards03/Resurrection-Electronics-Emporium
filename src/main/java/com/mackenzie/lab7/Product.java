package com.mackenzie.lab7;

import java.io.InputStream;
import java.io.Serializable;
import java.sql.*;
import java.util.*;

public class Product {
    public int id;
    public String name;
    public double price;
    public String priceStr;
    public String desc;
    public InputStream image;
    public Category category;
    public Brand brand;


    public Product(int id, double price, String name, String desc, InputStream image, Category category, Brand brand){
        this.id = id;
        this.price = price;
        this.name = name;
        this.priceStr = String.format("$%.2f", price);
        this.desc = desc;
        this.image = image;
        this.category = category;
        this.brand = brand;
    }

    public Product(double price, String name, String desc, InputStream image, Category category, Brand brand){
        this.price = price;
        this.priceStr = String.format("$%.2f", price);
        this.name = name;
        this.desc = desc;
        this.image = image;
        this.category = category;
        this.brand = brand;

    }
    public Product(){}

    public static boolean addProduct(Product product) throws SQLException {
        Connections connections = new Connections();
        boolean success = false;
        try {
            connections.getConnection();

            String sql = "INSERT INTO product " +
                    "(productName, productPrice, productDesc, productImage, categoryId, brandId) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";

            PreparedStatement pstmt = connections.con.prepareStatement(sql);
            pstmt.setString(1, product.name);
            pstmt.setDouble(2, product.price);
            pstmt.setString(3, product.desc);
            pstmt.setBlob(4, product.image);
            pstmt.setInt(5, product.category.id);
            pstmt.setInt(6, product.brand.id);
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

    public static boolean deleteProduct(int id) throws SQLException {
        Connections connections = new Connections();
        boolean success = false;
        try {
            connections.getConnection();

            String sql = "DELETE FROM product WHERE productId = ?";

            PreparedStatement pstmt = connections.con.prepareStatement(sql);
            pstmt.setInt(1, id);
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

    public static List<Product> getProducts(String search){
        Connections con = new Connections();
        List<Product> prods = new ArrayList<>();
        try {
            con.getConnection();

            PreparedStatement prodsQuery;
            boolean hasName = search != null && !search.isEmpty();
            if (hasName) {
                search = "%" + search + "%";
                prodsQuery = con.con.prepareStatement("select * from product where productName like ? and is_deleted = 'FALSE'");
                prodsQuery.setString(1, search);
            } else {
                prodsQuery = con.con.prepareStatement("select * from product where is_deleted = 'FALSE'");
            }
            ResultSet rsprods = prodsQuery.executeQuery();

            while (rsprods.next()) {
                prods.add(new Product(
                        rsprods.getInt("productId"),
                        rsprods.getDouble("productPrice"),
                        rsprods.getString("productName"),
                        rsprods.getString("productDesc"),
                        rsprods.getBinaryStream("productImage"),
                        Category.getCategory(rsprods.getInt("categoryId")),
                        Brand.getBrand(rsprods.getInt("brandId"))
                ));

            }
        }catch (Exception e) {
            System.err.println(e);
        }finally {
            con.closeConnection();
        }
        return prods;
    }

    public static boolean saveProduct(Product prod) throws SQLException {
        Connections con = new Connections();
        boolean success = false;
        try {
            con.getConnection();

            PreparedStatement pstmt = con.con.prepareStatement("UPDATE product SET productName = ?, " +
                    "productPrice = ?, productDesc = ?, categoryId = ?, brandId = ? WHERE productId = ?");
            pstmt.setString(1, prod.name);
            pstmt.setDouble(2, prod.price);
            pstmt.setString(3, prod.desc);
            pstmt.setInt(4, prod.category.id);
            pstmt.setInt(5, prod.brand.id);
            pstmt.setInt(6, prod.id);
            int count = pstmt.executeUpdate();
            success = count > 0;
            if(prod.image != null){
                pstmt = con.con.prepareStatement("UPDATE product SET productImage = ? WHERE productId = ?");
                pstmt.setBlob(1, prod.image);
                pstmt.setInt(2, prod.id);
                count = pstmt.executeUpdate();
                success = count > 0;
            }

        }catch (Exception e) {
            System.err.println(e);
            throw e;
        }finally {
            con.closeConnection();
        }
        return success;
    }

    public int getInvQuant(){
        Connections con = new Connections();
        int quantity = 0;
        try{
            con.getConnection();
            PreparedStatement stmt = con.con.prepareStatement("select quantity from productinventory where productId = ?");
            stmt.setInt(1, id);
            ResultSet rst = stmt.executeQuery();
            rst.next();
            quantity = rst.getInt("quantity");
        }catch (Exception e){
            System.err.println("SQLException: " + e);
        }
        finally {
            con.closeConnection();
        }
        return quantity;
    }
}
