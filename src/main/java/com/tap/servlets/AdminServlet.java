package com.tap.servlets;

import java.io.IOException;
import java.util.List;
import com.tap.Dao.OrderDao;
import com.tap.DaoImpl.OrderDaoImpl;
import com.tap.model.Order;
import com.tap.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");

        // Security Check
        if (user == null || !"ADMIN".equals(user.getRole())) {
            resp.sendRedirect("login.jsp?error=Unauthorized");
            return;
        }

        OrderDao orderDao = new OrderDaoImpl();
        List<Order> allOrders = orderDao.getAllOrders(); // Fetch ALL orders for admin

        req.setAttribute("allOrders", allOrders);
        req.getRequestDispatcher("admin_dashboard.jsp").forward(req, resp);
    }
}