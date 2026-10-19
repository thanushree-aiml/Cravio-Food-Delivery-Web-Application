package com.tap.servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.tap.Dao.RestaurantDao;
import com.tap.DaoImpl.RestaurantDaoImpl;
import com.tap.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/restaurant")
public class restaurantServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	    String query = req.getParameter("q"); // Search by name/cuisine
	    String location = req.getParameter("location"); // Search by area
	    
	    RestaurantDao restaurantDao = new RestaurantDaoImpl();
	    List<Restaurant> allRestaurants = restaurantDao.getAllRestaurants();
	    List<Restaurant> displayedRestaurants = new ArrayList<>();
	    
	    for (Restaurant r : allRestaurants) {
	        boolean matchesQuery = true;
	        boolean matchesLocation = true;
	        
	        if (query != null && !query.trim().isEmpty()) {
	            String q = query.toLowerCase();
	            matchesQuery = (r.getName() != null && r.getName().toLowerCase().contains(q)) || 
	                           (r.getCuisineType() != null && r.getCuisineType().toLowerCase().contains(q));
	        }
	        
	        if (location != null && !location.trim().isEmpty()) {
	            // Check if the restaurant's address contains the location name
	            matchesLocation = (r.getAddress() != null && r.getAddress().toLowerCase().contains(location.toLowerCase()));
	        }
	        
	        if (matchesQuery && matchesLocation) {
	            displayedRestaurants.add(r);
	        }
	    }
	    
	    req.setAttribute("restaurants", displayedRestaurants);
	    if (query != null) req.setAttribute("searchQuery", query);
	    if (location != null) req.setAttribute("searchLocation", location);
	    
	    req.getRequestDispatcher("restaurant.jsp").forward(req, resp);
	}
}