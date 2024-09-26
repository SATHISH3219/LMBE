package com.LMBE.LMBE.Consumer;

import com.LMBE.LMBE.Producer.Products.Product;
import com.LMBE.LMBE.Producer.Products.ProductRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/consumer")
public class UserController {

    @Autowired
    private ProductRepository productRepository; // Autowire the ProductRepository

    @GetMapping("/allproducts")
    public ResponseEntity<?> getAllProducts() {
        try {
            List<Product> products = productRepository.findAll(); // Retrieve all products

            if (products.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NO_CONTENT).body("No products found");
            }

            return ResponseEntity.ok(products);
        } catch (Exception e) {
            // Catch any exception and return a 500 error
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving products: " + e.getMessage());
        }
    }
}
