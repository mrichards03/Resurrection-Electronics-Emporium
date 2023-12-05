package com.mackenzie.lab7;
import java.util.*;
import java.sql.*;
public class OrderProduct {
    public Product product;
    public int quantity;

    public static List<OrderProduct> getOrderProducts(int orderId){
        List<OrderProduct> orderProducts = new ArrayList<>();
        Connections con = new Connections();
        try{
            con.getConnection();
            PreparedStatement prodsQuery = con.con.prepareStatement("select * from orderproduct op join product p on op.productId = p.productId where orderId = ?");
            prodsQuery.setInt(1, orderId);
            ResultSet prods = prodsQuery.executeQuery();

            while (prods.next()) {
                OrderProduct op = new OrderProduct();
                op.product = new Product(
                        prods.getInt("productId"),
                        prods.getDouble("productPrice"),
                        prods.getString("productName"),
                        prods.getString("productDesc"),
                        prods.getBinaryStream("productImage"),
                        Category.getCategory(prods.getInt("categoryId")),
                        Brand.getBrand(prods.getInt("brandId"))
                );
                op.quantity = prods.getInt("quantity");
                orderProducts.add(op);
            }
        }catch (Exception e) {
            System.err.println(e);
        }finally {
            con.closeConnection();
        }
        return orderProducts;
    }

}
