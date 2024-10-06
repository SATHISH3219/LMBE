package com.LMBE.LMBE.Producer.Products;

import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface ProductRepository extends MongoRepository<Products, String> {
    List<Products> findByProducerId(String producerId);
    List<Products> findByProductNameContaining(String productName);
}
