package com.tap.servlets;

import java.io.IOException;
import java.util.List;

import com.tap.Dao.MenuDao;
import com.tap.Dao.RestaurantDao;
import com.tap.DaoImpl.MenuDaoImpl;
import com.tap.DaoImpl.RestaurantDaoImpl;
import com.tap.model.Menu;
import com.tap.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        // 1. Get the restaurantId from the URL query parameter
        String restaurantIdStr = req.getParameter("restaurantId");
        
        if (restaurantIdStr == null || restaurantIdStr.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Restaurant ID is required");
            return;
        }
        
        try {
            int restaurantId = Integer.parseInt(restaurantIdStr);
            
            // 2. Fetch the Restaurant details (to show the name at the top)
            RestaurantDao restaurantDao = new RestaurantDaoImpl();
            Restaurant restaurant = restaurantDao.getRestaurant(restaurantId);
            
            if (restaurant == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Restaurant not found");
                return;
            }
            
            // 3. Fetch the Menu items for this restaurant
            MenuDao menuDao = new MenuDaoImpl();
            List<Menu> menuList = menuDao.getMenuByRestaurant(restaurantId);
            
            // 4. Pass the data to the JSP
            req.setAttribute("restaurant", restaurant);
            req.setAttribute("menuList", menuList);
            
            // 5. Forward to menu.jsp
            RequestDispatcher rd = req.getRequestDispatcher("menu.jsp");
            rd.forward(req, resp);
            
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Restaurant ID format");
        }
    }
}