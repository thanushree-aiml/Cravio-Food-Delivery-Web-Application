package com.tap.servlets;

import java.io.IOException;
import com.tap.model.Cart;
import com.tap.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        Cart cart = (Cart) session.getAttribute("cart");

        // 1. Check if user is logged in
        if (loggedInUser == null) {
            resp.sendRedirect("login.jsp?error=Please login to checkout");
            return;
        }

        // 2. Check if cart is empty
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect("cart");
            return;
        }

        req.getRequestDispatcher("checkout.jsp").forward(req, resp);
    }
}