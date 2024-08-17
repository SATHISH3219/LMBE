// package com.LMBE.LMBE.Producer;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.http.HttpStatus;
// import org.springframework.http.ResponseEntity;
// import org.springframework.web.bind.annotation.*;


// @RestController
// @RequestMapping("/api")
// public class ProducerController {

//     @Autowired
//     private ProducerService userService;

//     @PostMapping("/register")
//     public ResponseEntity<?> registerUser(@RequestBody Producer producer) {
//         if (userService.existsByName(producer.getName())) {
//             return ResponseEntity.badRequest().body("Username is already taken!");
//         }
//         if (userService.existsByEmail(producer.getEmail())) {
//             return ResponseEntity.badRequest().body("Email is already in use!");
//         }
//         return ResponseEntity.ok(ProducerService.registerUser(producer));
//     }

//     @PostMapping("/login")
//     public ResponseEntity<?> loginUser(@RequestBody Producer user) {
//         try {
//             Producer authenticatedUser = userService.loginUser(user.getEmail(),user.getPassword());
//             return ResponseEntity.ok(authenticatedUser);
//         } catch (Exception e) {
//             return ResponseEntity.badRequest().body("Invalid credentials!");
//         }
//     }
    
// }
