package com.mackenzie.lab7;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class Category {
    public int id;
    public String name;

    public Category(int id, String name){
        this.id = id;
        this.name = name;
    }

    public static List<Category> getCategories() {
        Connections connections = new Connections();
        List<Category> categories = new ArrayList<>();
        try {
            connections.getConnection();

            String sql = "SELECT * FROM category";
            PreparedStatement pstmt = connections.con.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                categories.add(new Category(rs.getInt("categoryId"), rs.getString("categoryName")));
            }
        }catch(Exception e) {
            System.err.println(e);
        }finally {
            connections.closeConnection();
        }
        return categories;
    }
}
