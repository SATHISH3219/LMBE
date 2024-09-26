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
    public ResponseEntity<?> register(@RequestBody UserOrProducer request) {
        try {
            if ("Consumer".equalsIgnoreCase(request.getRole())) {
                User user = new User(request.getName(), request.getEmail(), request.getPassword());
                if (userService.existsByEmail(user.getEmail()) || userService.existsByName(user.getName())) {
                    return ResponseEntity.badRequest().body(new RegisterResponse("User with this email or name already exists.", null));
                }
                User savedUser = userService.registerUser(user);
                return ResponseEntity.ok(new RegisterResponse("User registered successfully.", savedUser.getId()));
            } else if ("Producer".equalsIgnoreCase(request.getRole())) {
                Producer producer = new Producer(request.getName(), request.getEmail(), request.getPassword());
                if (producerService.existsByEmail(producer.getEmail()) || producerService.existsByName(producer.getName())) {
                    return ResponseEntity.badRequest().body(new RegisterResponse("Producer with this email or name already exists.", null));
                }
                Producer savedProducer = producerService.registerProducer(producer);
                return ResponseEntity.ok(new RegisterResponse("Producer registered successfully.", savedProducer.getId()));
            } else {
                return ResponseEntity.badRequest().body(new RegisterResponse("Invalid role specified.", null));
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body(new RegisterResponse("Error occurred during registration.", null));
        }
    }

    // Login a user or producer
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody UserOrProducer request) {
        try {
            if ("Consumer".equalsIgnoreCase(request.getRole())) {
                User user = userService.loginUser(request.getEmail(), request.getPassword());
                return ResponseEntity.ok(new LoginResponse("User logged in successfully.", user.getId()));
            } else if ("Producer".equalsIgnoreCase(request.getRole())) {
                Producer producer = producerService.loginProducer(request.getEmail(), request.getPassword());
                return ResponseEntity.ok(new LoginResponse("Producer logged in successfully.", producer.getId()));
            } else {
                return ResponseEntity.badRequest().body(new LoginResponse("Invalid role specified.", null));
            }
        } catch (RuntimeException e) {
            return ResponseEntity.status(401).body(new LoginResponse(e.getMessage(), null));
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

    // Response class for registration
    public static class RegisterResponse {
        private String message;
        private String userId;

        public RegisterResponse(String message, String userId) {
            this.message = message;
            this.userId = userId;
        }

        // Getters and Setters
        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public String getUserId() {
            return userId;
        }

        public void setUserId(String userId) {
            this.userId = userId;
        }
    }

    // Response class for login
    public static class LoginResponse {
        private String message;
        private String userId;

        public LoginResponse(String message, String userId) {
            this.message = message;
            this.userId = userId;
        }

        // Getters and Setters
        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public String getUserId() {
            return userId;
        }

        public void setUserId(String userId) {
            this.userId = userId;
        }
    }
}
