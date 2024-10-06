package com.LMBE.LMBE.Cart;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CartService {

    @Autowired
    private CartRepository cartRepository;

    // Retrieve the cart for a specific user
    public Cart getCart(String userId) {
        return cartRepository.findByUserId(userId);
    }

    // Add a new item to the cart
    public Cart addToCart(String userId, CartItem newItem) {
        Cart cart = cartRepository.findByUserId(userId);

        // Create a new cart if none exists for the user
        if (cart == null) {
            cart = new Cart(userId);
        }

        // Check if the item already exists in the cart
        boolean itemExists = false;
        for (CartItem item : cart.getItems()) {
            if (item.getProductId().equals(newItem.getProductId())) {
                // Update the quantity if the item is already in the cart
                item.setQuantity(item.getQuantity() + 1);
                itemExists = true;
                break;
            }
        }

        // If the item does not exist in the cart, add it
        if (!itemExists) {
            cart.getItems().add(newItem);
        }

        // Save and return the updated cart
        return cartRepository.save(cart);
    }

    // Checkout process
    public void checkout(String userId) {
        // Optionally, you can add logic here to process the order before clearing the cart
        cartRepository.deleteById(userId); // Clear the cart after checkout
    }

    // Add product to cart
    public CartItem addProductToCart(String userId, CartItem cartItem) {
        // Fetch user cart, add the item, and save back to database
        Cart cart = cartRepository.findByUserId(userId);
        if (cart == null) {
            cart = new Cart();
            cart.setUserId(userId);
        }
        cart.getItems().add(cartItem); // Add item to the cart
        cartRepository.save(cart); // Save cart to the database
        return cartItem;
    }

    // Remove product from cart
    public void removeProductFromCart(String userId, CartItem cartItem) {
        Cart cart = getCart(userId);
        if (cart != null) {
            cart.getItems().removeIf(item -> item.getProductId().equals(cartItem.getProductId()));
            // Save the updated cart to the database
            cartRepository.save(cart);
        }
    }
}
