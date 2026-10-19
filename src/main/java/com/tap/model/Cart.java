package com.tap.model;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart {

    private int restaurantId;
    private Map<Integer, CartItem> items;

    public Cart() {
        items = new LinkedHashMap<>();
        restaurantId=0;
    }

    public Cart(int restaurantId) {
        this.restaurantId = restaurantId;
        items = new LinkedHashMap<>();
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public Map<Integer, CartItem> getItems() {
        return items;
    }

    public void setItems(Map<Integer, CartItem> items) {
        this.items = items;
    }

    // Add item to cart
    public void addItem(CartItem cartItem) {

        int menuId = cartItem.getMenu().getMenuId();

        if (items.containsKey(menuId)) {

            CartItem existingItem = items.get(menuId);

            existingItem.setQuantity(
                    existingItem.getQuantity() + cartItem.getQuantity()
            );

        } else {

            items.put(menuId, cartItem);
        }
    }

    // Get a particular cart item
    public CartItem getItem(int menuId) {
        return items.get(menuId);
    }

    // Get quantity of a particular menu item
    public int getQuantity(int menuId) {

        CartItem cartItem = items.get(menuId);

        if (cartItem != null) {
            return cartItem.getQuantity();
        }

        return 0;
    }

    // Update quantity
    public void updateQuantity(int menuId, int quantity) {

        CartItem cartItem = items.get(menuId);

        if (cartItem != null) {

            if (quantity > 0) {
                cartItem.setQuantity(quantity);
            } else {
                removeItem(menuId);
            }
        }
    }

    // Remove item from cart
    public void removeItem(int menuId) {
        items.remove(menuId);
    }

    // Calculate subtotal
    public double getSubtotal() {

        double subtotal = 0;

        for (CartItem cartItem : items.values()) {
            subtotal = subtotal + cartItem.getSubtotal();
        }

        return subtotal;
    }

    // Get total number of items
    public int getItemCount() {

        int count = 0;

        for (CartItem cartItem : items.values()) {
            count = count + cartItem.getQuantity();
        }

        return count;
    }

    // Check whether cart is empty
    public boolean isEmpty() {
        return items.isEmpty();
    }

    // Clear cart
    public void clear() {
        items.clear();
    }

    // Get all cart items
    public Collection<CartItem> getCartItems() {
        return items.values();
    }

    @Override
    public String toString() {

        return "Cart [restaurantId=" + restaurantId
                + ", items=" + items
                + ", subtotal=" + getSubtotal()
                + ", itemCount=" + getItemCount()
                + "]";
    }
}