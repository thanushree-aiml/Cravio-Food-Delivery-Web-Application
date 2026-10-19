package com.tap.servlets;

import java.io.IOException;
import java.util.List;
import com.tap.Dao.RestaurantDao;
import com.tap.DaoImpl.RestaurantDaoImpl;
import com.tap.model.Restaurant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RestaurantDao dao = new RestaurantDaoImpl();
        List<Restaurant> all = dao.getAllRestaurants();
        
        // Get the first 4 restaurants as "Featured"
        List<Restaurant> featured = all.size() > 4 ? all.subList(0, 4) : all;
        
        req.setAttribute("featuredRestaurants", featured);
        req.getRequestDispatcher("index.jsp").forward(req, resp);
    }
}