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

    public Order(int id, LocalDateTime date, int custId, String custName, double total, boolean isShipped) {
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        this.id = id;
        this.date = date;
        this.custId = custId;
        this.custName = custName;
        this.totalStr = currFormat.format(total);
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
                        total,
                        rst.getString("shipmentId") != null);

                        order.products = (ArrayList<OrderProduct>) OrderProduct.getOrderProducts(order.id);

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
        List<Map.Entry<LocalDate, Double>> finalList = new ArrayList<>();

        try{
            List<Order> o = getOrders();
            LocalDate startDate = o.stream().map(order -> order.date.toLocalDate()).min(LocalDate::compareTo).get();
            LocalDate endDate = LocalDate.now();

            Map<LocalDate, Double> groupedOrders = o.stream()
                    .collect(Collectors.groupingBy(
                            order -> order.date.toLocalDate(),
                            Collectors.summingDouble(order -> order.total)
                    ));

            Map<LocalDate, Double> completeOrders = startDate.datesUntil(endDate.plusDays(1))
                    .collect(Collectors.toMap(
                            date -> date,
                            date -> groupedOrders.getOrDefault(date, 0.0)
                    ));

            finalList = completeOrders.entrySet().stream()
                    .sorted(Map.Entry.comparingByKey())
                    .collect(Collectors.toList());

        }catch (Exception e){
            System.err.println(e);
        }

        return finalList;
    }

    public static List<Order> readyToShip(){
        Connections con = new Connections();
        List<Order> orders = new ArrayList<>();
        try{
            con.getConnection();
            //get all orders that have sufficient inventory and haven't been shipped
            PreparedStatement stmt = con.con.prepareStatement("""
                    SELECT *
                    FROM ordersummary os join users u on os.userId = u.userId
                    WHERE os.orderId IN (
                            SELECT op.orderId
                            FROM orderproduct op
                            LEFT JOIN productinventory prodInv ON op.productId = prodInv.productId
                            GROUP BY op.orderId
                            HAVING SUM(CASE WHEN op.quantity <= prodInv.quantity THEN 1 ELSE 0 END) = COUNT(*)
            )
            AND os.orderId NOT IN (
                    SELECT orderId FROM shipment
            )
            """);
            ResultSet rst = stmt.executeQuery();
            while(rst.next()){
                Order order = new Order(rst.getInt("orderId"),
                        rst.getTimestamp("orderDate").toLocalDateTime(),
                        rst.getInt("userId"),
                        rst.getString("firstname") + " " + rst.getString("lastname"),
                        rst.getDouble("totalAmount"),
                        false);
                order.products = (ArrayList<OrderProduct>) OrderProduct.getOrderProducts(order.id);
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

    public static List<Order> cantShip(){
        List<Order> orders = new ArrayList<>();
        Connections con = new Connections();
        try{
            con.getConnection();
            //count all orders that don't have sufficient inventory and haven't been shipped
            PreparedStatement stmt = con.con.prepareStatement("""
                            
                    select * from (SELECT os.orderId
                            FROM ordersummary os join users u on os.userId = u.userId
                            WHERE EXISTS (
                                SELECT 1
                                FROM orderproduct op
                                         JOIN productinventory prodInv ON op.productId = prodInv.productId
                                WHERE op.orderId = os.orderId AND op.quantity > prodInv.quantity
                            )
                              AND NOT EXISTS (
                                SELECT 1
                                FROM shipment
                                WHERE shipment.orderId = os.orderId
                            )
                            group by os.orderId) o join ordersummary os on o.orderId = os.orderId join users u on os.userId = u.userId;
                            """);
            ResultSet rst = stmt.executeQuery();
            while(rst.next()){
                Order order = new Order(rst.getInt("orderId"),
                        rst.getTimestamp("orderDate").toLocalDateTime(),
                        rst.getInt("userId"),
                        rst.getString("firstname") + " " + rst.getString("lastname"),
                        rst.getDouble("totalAmount"),
                        false);
                order.products = (ArrayList<OrderProduct>) OrderProduct.getOrderProducts(order.id);
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

    public static int shipped(){
        int count = 0;
        Connections con = new Connections();
        try{
            con.getConnection();
            //count all orders that have been shipped
            PreparedStatement stmt = con.con.prepareStatement("""
                            select count(*) count from ordersummary 
                            join shipment on ordersummary.orderId = shipment.orderId
                            """);
            ResultSet rst = stmt.executeQuery();
            if(rst.next()){
                count = rst.getInt("count");
            }
        }catch (Exception e){
            System.err.println("SQLException: " + e);
        }
        finally {
            con.closeConnection();
        }
        return count;
    }
}
