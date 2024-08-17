package com.LMBE.LMBE.Producer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProducerService {

    @Autowired
    private ProducerRespitory producerRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // Register a new producer with encrypted password
    public Producer registerProducer(Producer producer) {
        producer.setPassword(passwordEncoder.encode(producer.getPassword()));
        return producerRepository.save(producer);
    }

    // Authenticate producer during login
    public Producer loginProducer(String email, String password) {
        Producer producer = producerRepository.findByEmail(email)
            .orElseThrow(() -> new RuntimeException("Producer not found"));

        if (passwordEncoder.matches(password, producer.getPassword())) {
            return producer;
        } else {
            throw new RuntimeException("Invalid login details");
        }
    }

    // Fetch all producers
    public List<Producer> getAllProducers() {
        return producerRepository.findAll();
    }

    // Check if a username already exists
    public boolean existsByName(String name) {
        return producerRepository.existsByName(name);
    }

    // Check if an email already exists
    public boolean existsByEmail(String email) {
        return producerRepository.existsByEmail(email);
    }

    public Optional<Producer> getProducerByName(String username) {
        return producerRepository.findByName(username);
    }
}
