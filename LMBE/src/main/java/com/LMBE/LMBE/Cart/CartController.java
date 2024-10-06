package com.LMBE.LMBE.Cart;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @GetMapping("/{userId}")
    public ResponseEntity<Cart> getCart(@PathVariable String userId) {
        Cart cart = cartService.getCart(userId);
        return ResponseEntity.ok(cart);
    }

    @PostMapping("/{userId}/add")
    public ResponseEntity<CartItem> addProductToCart(@PathVariable String userId, @RequestBody CartItem cartItem) {
        try {
            CartItem addedItem = cartService.addProductToCart(userId, cartItem);
            return ResponseEntity.ok(addedItem);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    // New endpoint to remove a product from the cart
    @PostMapping("/{userId}/remove")
    public ResponseEntity<Void> removeProductFromCart(@PathVariable String userId, @RequestBody CartItem cartItem) {
        try {
            cartService.removeProductFromCart(userId, cartItem);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/{userId}/checkout")
    public ResponseEntity<Void> checkout(@PathVariable String userId) {
        cartService.checkout(userId);
        return ResponseEntity.ok().build();
    }
}
