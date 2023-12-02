package com.mackenzie.lab7;

import java.io.InputStream;
import java.sql.Blob;
import java.sql.PreparedStatement;

public class Product {
    public int id;
    public String name;
    public double price;
    public String priceStr;
    public int quantity;
    public String desc;
    public InputStream image;
    public Category category;
    public Brand brand;


    public Product(int id, double price, int quantity, String name){
        this.id = id;
        this.price = price;
        this.priceStr = String.format("$%.2f", price);
        this.quantity = quantity;
        this.name = name;
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

    public static boolean addProduct(Product product){
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
            pstmt.executeUpdate();
            success = true;

        }catch (Exception e) {
            System.err.println(e);
        }finally {
            connections.closeConnection();
        }
        return success;
    }

    public static boolean deleteProduct(int id){
        Connections connections = new Connections();
        boolean success = false;
        try {
            connections.getConnection();

            String sql = "DELETE FROM product WHERE productId = ?";

            PreparedStatement pstmt = connections.con.prepareStatement(sql);
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            success = true;

        }catch (Exception e) {
            System.err.println(e);
        }finally {
            connections.closeConnection();
        }
        return success;
    }
}
