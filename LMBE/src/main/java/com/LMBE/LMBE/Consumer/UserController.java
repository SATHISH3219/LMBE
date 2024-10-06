package com.LMBE.LMBE.Consumer;

import com.LMBE.LMBE.Producer.Products.ProductRepository;
import com.LMBE.LMBE.Producer.Products.Products;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/consumer")
public class UserController {

    @Autowired
    private ProductRepository productRepository; // Autowire the ProductRepository

    @GetMapping("/allproducts")
    public ResponseEntity<?> getAllProducts() {
        try {
            // Retrieve all products
            List<Products> products = productRepository.findAll();

            // Check if no products were found
            if (products.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NO_CONTENT)
                                     .body("No products found in the database.");
            }

            // Return the list of products
            return ResponseEntity.ok(products);
        } catch (Exception e) {
            // Catch and log the exception
            e.printStackTrace();
            // Return the error message with a 500 status code
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("Error retrieving products: " + e.getMessage());
        }
    }
}
