package com.LMBE.LMBE.Consumer;

import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface UserRepository extends MongoRepository<User, String> {
    Optional<User> findByEmail(String email);  // Corrected to find by email
    Boolean existsByName(String name);
    Boolean existsByEmail(String email);
}
