package com.mackenzie.lab7;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class Brand {
    public int id;
    public String name;

    public Brand(int id, String name){
        this.id = id;
        this.name = name;
    }

    public static List<Brand> getBrands(){
        Connections connections = new Connections();
        List<Brand> brands = new ArrayList<>();
        try {
            connections.getConnection();

            String sql = "SELECT * FROM brand";
            PreparedStatement pstmt = connections.con.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                brands.add(new Brand(rs.getInt("brandId"), rs.getString("brandName")));
            }
        }catch(Exception e) {
            System.err.println(e);
        }finally {
            connections.closeConnection();
        }
        return brands;
    }
}
