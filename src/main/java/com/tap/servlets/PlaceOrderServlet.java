package com.tap.servlets;

import java.io.IOException;
import java.util.Collection;

import com.tap.Dao.OrderDao;
import com.tap.Dao.OrderItemDao;
import com.tap.DaoImpl.OrderDaoImpl;
import com.tap.DaoImpl.OrderItemDaoImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/placeOrder")
public class PlaceOrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        Cart cart = (Cart) session.getAttribute("cart");

        if (user == null || cart == null || cart.isEmpty()) {
            resp.sendRedirect("restaurant");
            return;
        }

        int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));
        double totalAmount = Double.parseDouble(req.getParameter("totalAmount"));
        String paymentMode = req.getParameter("paymentMode");

        Order order = new Order();
        order.setUserId(user.getUserId());
        order.setRestaurantId(restaurantId);
        order.setTotalAmount(totalAmount);
        order.setStatus("PENDING");
        order.setPaymentMode(paymentMode);
        
        Order order1 = new Order();
     // ... set other details ...
     order1.setStatus("PLACED"); // Changed from PENDING

        OrderDao orderDao = new OrderDaoImpl();
        int orderId = orderDao.addOrder(order1); // Make sure this returns the generated ID!

        OrderItemDao orderItemDao = new OrderItemDaoImpl();
        Collection<CartItem> cartItems = cart.getCartItems();

        for (CartItem item : cartItems) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(orderId);
            orderItem.setMenuId(item.getMenu().getMenuId());
            orderItem.setQuantity(item.getQuantity());
            orderItem.setTotalAmount(item.getSubtotal());
            orderItemDao.addOrderItem(orderItem);
        }

        session.removeAttribute("cart");

        req.setAttribute("orderId", orderId);
        req.getRequestDispatcher("order_success.jsp").forward(req, resp);
    }
}