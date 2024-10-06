package com.LMBE.LMBE.Order;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import com.LMBE.LMBE.Cart.CartItem;

import java.time.Instant;
import java.util.List;

@Document(collection = "orders")
public class Order {

    @Id
    private String id;
    private String userId;
    private List<CartItem> items; // Assuming CartItem is already defined
    private String status; // e.g., "Placed", "Completed", "Cancelled"
    private String timestamp;

    // Constructor with all fields
    public Order(String id, String userId, List<CartItem> items, String status, String timestamp) {
        this.id = id;
        this.userId = userId;
        this.items = items;
        this.status = status;
        this.timestamp = timestamp;
    }

    // Default constructor
    public Order() {
        this.timestamp = Instant.now().toString(); // Default timestamp to current time
    }

    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = items;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public String toString() {
        return "Order{" +
                "id='" + id + '\'' +
                ", userId='" + userId + '\'' +
                ", items=" + items +
                ", status='" + status + '\'' +
                ", timestamp='" + timestamp + '\'' +
                '}';
    }
}
