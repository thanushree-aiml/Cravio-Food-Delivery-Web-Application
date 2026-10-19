package com.tap.Dao;

import java.util.List;
import com.tap.model.Order;

public interface OrderDao {
    // Change void to int
    int addOrder(Order order); 
    
    Order getOrder(int orderId);
    void updateOrder(Order order);
    void deleteOrder(int orderId);
    List<Order> getAllOrders();
    List<Order> getOrdersByUser(int userId);
}