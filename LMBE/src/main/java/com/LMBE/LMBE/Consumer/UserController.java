// package com.LMBE.LMBE.Consumer;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.http.HttpStatus;
// import org.springframework.http.ResponseEntity;
// import org.springframework.web.bind.annotation.*;


// @RestController
// @RequestMapping("/api")
// public class UserController {

//     @Autowired
//     private UserService userService;

//     @PostMapping("/register")
//     public ResponseEntity<?> registerUser(@RequestBody User user) {
//         if (userService.existsByName(user.getName())) {
//             return ResponseEntity.badRequest().body("Username is already taken!");
//         }
//         if (userService.existsByEmail(user.getEmail())) {
//             return ResponseEntity.badRequest().body("Email is already in use!");
//         }
//         return ResponseEntity.ok(userService.registerUser(user));
//     }

//     @PostMapping("/login")
//     public ResponseEntity<?> loginUser(@RequestBody User user) {
//         try {
//             User authenticatedUser = userService.loginUser(user.getEmail(),user.getPassword());
//             return ResponseEntity.ok(authenticatedUser);
//         } catch (Exception e) {
//             return ResponseEntity.badRequest().body("Invalid credentials!");
//         }
//     }
    
// }
