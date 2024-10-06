package com.LMBE.LMBE.Producer.Products;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.LMBE.LMBE.Producer.Producer;// Fixed the spelling here
import com.LMBE.LMBE.Producer.ProducerRespitory;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProducerRespitory producerRepository;

    // Create a product for a specific producer
    @PostMapping("/create")
    public ResponseEntity<String> createProduct(@RequestBody Products productRequest) {
        // Validate product request
        if (productRequest.getProducerId() == null || productRequest.getProductName() == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Producer ID and Product Name must not be null");
        }

        // Check if the producer exists
        Optional<Producer> producer = producerRepository.findById(productRequest.getProducerId());
        if (producer.isPresent()) {
            try {
                Products product = new Products(
                        productRequest.getProducerId(),
                        productRequest.getProductName(),
                        productRequest.getDescription(),
                        productRequest.getPrice(),
                        productRequest.getQuantity()
                );

                Products savedProduct = productRepository.save(product);
                return ResponseEntity.ok("Product created with ID: " + savedProduct.getId());

            } catch (Exception e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body("Error creating product: " + e.getMessage());
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("Producer not found with ID: " + productRequest.getProducerId());
        }
    }

    // Retrieve all products by a producer ID
    @GetMapping("/producer/{producerId}")
    public ResponseEntity<?> getProductsByProducerId(@PathVariable String producerId) {
        // Check if the producer exists
        Optional<Producer> producer = producerRepository.findById(producerId);
        if (producer.isPresent()) {
            try {
                List<Products> products = productRepository.findByProducerId(producerId);
                if (products.isEmpty()) {
                    return ResponseEntity.status(HttpStatus.NO_CONTENT)
                            .body("No products found for Producer ID: " + producerId);
                }
                return ResponseEntity.ok(products);

            } catch (Exception e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body("Error retrieving products: " + e.getMessage());
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("Producer not found with ID: " + producerId);
        }
    }

    // Retrieve all products from the database
    @GetMapping("/allproducts")
    public ResponseEntity<?> getAllProducts() {
        try {
            List<Products> products = productRepository.findAll(); // Fetch all products
            if (products.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NO_CONTENT).body("No products found");
            }
            return ResponseEntity.ok(products); // Return list of products

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error retrieving products: " + e.getMessage());
        }
    }
}
