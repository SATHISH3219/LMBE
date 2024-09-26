package com.LMBE.LMBE.Producer;

import java.util.Optional;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface ProducerRespitory extends MongoRepository<Producer, String> {
    Optional<Producer> findByEmail(String email);
    Boolean existsByName(String name);
    Boolean existsByEmail(String email);
    boolean existsById(String id);
    Optional<Producer> findByName(String username);
}
