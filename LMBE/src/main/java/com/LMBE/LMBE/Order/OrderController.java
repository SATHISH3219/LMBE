package com.LMBE.LMBE.Order;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.List;

@RestController
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderService orderService; // Autowire the OrderService

    @PostMapping("/place")
    public ResponseEntity<?> placeOrder(@RequestBody Order order) {
        order.setStatus("Placed");
        order.setTimestamp(Instant.now().toString());
        orderRepository.save(order);
        return ResponseEntity.ok("Order placed successfully!");
    }

    @GetMapping("/{userId}")
    public List<Order> getUserOrders(@PathVariable String userId) {
        return orderRepository.findByUserId(userId);
    }

    @DeleteMapping("/{orderId}")
    public ResponseEntity<Void> deleteOrder(@PathVariable String orderId) {
        boolean isDeleted = orderService.deleteOrderById(orderId); // Call instance method
        return isDeleted ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }
}
