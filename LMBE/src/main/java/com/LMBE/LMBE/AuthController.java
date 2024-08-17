package com.LMBE.LMBE;

import com.LMBE.LMBE.Consumer.User;
import com.LMBE.LMBE.Consumer.UserService;
import com.LMBE.LMBE.Producer.Producer;
import com.LMBE.LMBE.Producer.ProducerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private ProducerService producerService;

    // Register a new user or producer
    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody UserOrProducer request) {
        if ("Consumer".equalsIgnoreCase(request.getRole())) {
            User user = new User(request.getName(), request.getEmail(), request.getPassword());
            if (userService.existsByEmail(user.getEmail()) || userService.existsByName(user.getName())) {
                return ResponseEntity.badRequest().body("User with this email or name already exists.");
            }
            userService.registerUser(user);
            return ResponseEntity.ok("User registered successfully.");
        } else if ("Producer".equalsIgnoreCase(request.getRole())) {
            Producer producer = new Producer(request.getName(), request.getEmail(), request.getPassword());
            if (producerService.existsByEmail(producer.getEmail()) || producerService.existsByName(producer.getName())) {
                return ResponseEntity.badRequest().body("Producer with this email or name already exists.");
            }
            producerService.registerProducer(producer);
            return ResponseEntity.ok("Producer registered successfully.");
        } else {
            return ResponseEntity.badRequest().body("Invalid role specified.");
        }
    }

    // Login a user or producer
    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody UserOrProducer request) {
        try {
            if ("Consumer".equalsIgnoreCase(request.getRole())) {
                userService.loginUser(request.getEmail(), request.getPassword());
                return ResponseEntity.ok("User logged in successfully.");
            } else if ("Producer".equalsIgnoreCase(request.getRole())) {
                producerService.loginProducer(request.getEmail(), request.getPassword());
                return ResponseEntity.ok("Producer logged in successfully.");
            } else {
                return ResponseEntity.badRequest().body("Invalid role specified.");
            }
        } catch (RuntimeException e) {
            return ResponseEntity.status(401).body(e.getMessage());
        }
    }

    // Helper class for request body
    public static class UserOrProducer {
        private String name;
        private String email;
        private String password;
        private String role;  // "Consumer" or "Producer"

        // Getters and Setters
        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getPassword() {
            return password;
        }

        public void setPassword(String password) {
            this.password = password;
        }

        public String getRole() {
            return role;
        }

        public void setRole(String role) {
            this.role = role;
        }
    }
}
