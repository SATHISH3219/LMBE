package com.LMBE.LMBE.Cart;

import org.springframework.data.mongodb.core.mapping.Field;

public class CartItem {

    @Field("product_id")
    private String productId;

    @Field("product_name")
    private String productName;

    @Field("price")
    private double price;

    @Field("quantity")
    private int quantity;

    public CartItem() {
    }

    public CartItem(String productId, String productName, double price, int quantity) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
