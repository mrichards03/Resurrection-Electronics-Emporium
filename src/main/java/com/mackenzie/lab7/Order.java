package com.mackenzie.lab7;

import java.sql.*;
import java.text.NumberFormat;
import java.text.ParseException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Order {
    public int id;
    public LocalDateTime date;
    public int custId;
    public String custName;
    public String totalStr;
    public double total;
    public boolean isShipped;
    public ArrayList<OrderProduct> products;

    public Order(int id, LocalDateTime date, int custId, String custName, String totalStr, double total, boolean isShipped) {
        this.id = id;
        this.date = date;
        this.custId = custId;
        this.custName = custName;
        this.totalStr = totalStr;
        this.total = total;
        this.isShipped = isShipped;
        products = new ArrayList<>();
    }
    public static List<Order> getOrders(){

        List<Order> orders = new ArrayList<>();
        Connections con = new Connections();
        try{
            con.getConnection();

            NumberFormat currFormat = NumberFormat.getCurrencyInstance();
            PreparedStatement stmt = con.con.prepareStatement("SELECT * FROM ordersummary " +
                    "join users on ordersummary.userID = users.userId " +
                    "left join shipment on ordersummary.orderId = shipment.orderId");
            ResultSet rst = stmt.executeQuery();

            while (rst.next()) {
                double total = rst.getDouble("totalAmount");
                Order order = new Order(rst.getInt("orderId"),
                        rst.getTimestamp("orderDate").toLocalDateTime(),
                        rst.getInt("userId"),
                        rst.getString("firstname") + " " + rst.getString("lastname"),
                        currFormat.format(total), total,
                        rst.getString("shipmentId") != null);

                PreparedStatement prodsQuery = con.con.prepareStatement("select * from orderproduct op join product p on op.productId = p.productId where orderId = ?");
                prodsQuery.setInt(1, order.id);
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
                    order.products.add(op);
                }

                orders.add(order);
            }

        }catch (Exception e){
            System.err.println("SQLException: " + e);
        }
        finally {
            con.closeConnection();
        }

        return orders;
    }

    public static List<Map.Entry<LocalDate, Double>> getDailySales(){
        List<Map.Entry<LocalDate, Double>> groupedOrders = new ArrayList<>();

        try{
            List<Order> o = getOrders();
            groupedOrders = o.stream()
                    .collect(Collectors.groupingBy(
                            order -> order.date.toLocalDate(), //
                            Collectors.summingDouble(order -> order.total) // Sum total for each group
                    )).entrySet()
                    .stream()
                    .filter(entry -> entry.getValue() > 0) // Filter out empty totals
                    .sorted(Map.Entry.comparingByKey())
                    .map(entry -> Map.entry(entry.getKey(), entry.getValue()))
                    .collect(Collectors.toList());

        }catch (Exception e){
            System.err.println(e);
        }

        return groupedOrders;
    }
}
