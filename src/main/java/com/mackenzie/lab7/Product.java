package com.mackenzie.lab7;

public class Product {
    public int id;
    public String name;
    public double price;
    public String priceStr;
    public int quantity;

    public Product(int id, double price, int quantity, String name){
        this.id = id;
        this.price = price;
        this.priceStr = String.format("$%.2f", price);
        this.quantity = quantity;
        this.name = name;
    }
}
