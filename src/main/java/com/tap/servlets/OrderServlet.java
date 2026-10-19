package com.tap.servlets;

import java.io.IOException;
import java.util.List;

import com.tap.Dao.OrderDao;
import com.tap.DaoImpl.OrderDaoImpl;
import com.tap.model.Order;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// This maps the URL /orders to this servlet
@WebServlet("/orders")
public class OrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        // 1. Get the existing session (do not create a new one if it doesn't exist)
        HttpSession session = req.getSession(false);
        
        // 2. Check if the user is logged in
        User loggedInUser = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (loggedInUser == null) {
            // If not logged in, send them to the login page
            resp.sendRedirect("login.jsp");
            return;
        }

        // 3. Fetch the orders for this specific user from the database
        OrderDao orderDao = new OrderDaoImpl();
        List<Order> userOrders = orderDao.getOrdersByUser(loggedInUser.getUserId());

        // 4. Pass the list of orders to the JSP page
        req.setAttribute("ordersList", userOrders);

        // 5. Forward the request to orders.jsp
        req.getRequestDispatcher("orders.jsp").forward(req, resp);
    }
}