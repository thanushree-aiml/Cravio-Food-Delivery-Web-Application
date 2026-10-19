package com.tap.servlets;

import java.io.IOException;

import com.tap.Dao.MenuDao;
import com.tap.DaoImpl.MenuDaoImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    // ==========================================
    // DO GET: Just show the cart page
    // ==========================================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        req.setAttribute("cart", cart);
        req.getRequestDispatcher("cart.jsp").forward(req, resp);
    }

    // ==========================================
    // DO POST: Handle Add, Update, Remove, Clear
    // ==========================================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        String action = req.getParameter("action");
        String source = req.getParameter("source"); // "menu" or "cart"
        
        // To know where to redirect back if source is "menu"
        String restaurantIdStr = req.getParameter("restaurantId"); 

        if (action == null) {
            resp.sendRedirect("cart");
            return;
        }

        try {
            int menuId = 0;
            int quantity = 1;

            if (req.getParameter("menuId") != null) {
                menuId = Integer.parseInt(req.getParameter("menuId"));
            }
            if (req.getParameter("quantity") != null) {
                quantity = Integer.parseInt(req.getParameter("quantity"));
            }

            // ================= ADD ITEM =================
            if ("add".equals(action)) {
                MenuDao menuDao = new MenuDaoImpl();
                Menu menu = menuDao.getMenu(menuId);

                if (menu != null) {
                    if (cart == null) {
                        cart = new Cart();
                    }
                    
                    // Ensure the cart only holds items from ONE restaurant
                    int reqRestaurantId = Integer.parseInt(restaurantIdStr);
                    if (cart.getRestaurantId() != 0 && cart.getRestaurantId() != reqRestaurantId) {
                        // Cart has items from another restaurant. Send error.
                        resp.sendRedirect("menu?restaurantId=" + reqRestaurantId + "&error=restaurant_mismatch");
                        return;
                    }

                    cart.setRestaurantId(reqRestaurantId);
                    CartItem cartItem = new CartItem(menu, quantity);
                    cart.addItem(cartItem);
                    session.setAttribute("cart", cart);
                }
            } 
            
            // ================= UPDATE QUANTITY =================
            else if ("update".equals(action)) {
                if (cart != null) {
                    cart.updateQuantity(menuId, quantity);
                    session.setAttribute("cart", cart);
                }
            } 
            
            // ================= REMOVE ITEM =================
            else if ("remove".equals(action)) {
                if (cart != null) {
                    cart.removeItem(menuId);
                    if (cart.getItems().isEmpty()) {
                        cart.setRestaurantId(0); // Reset restaurant if cart is empty
                    }
                    session.setAttribute("cart", cart);
                }
            } 
            
            // ================= CLEAR CART =================
            else if ("clear".equals(action)) {
                if (cart != null) {
                    cart.getItems().clear();
                    cart.setRestaurantId(0);
                    session.setAttribute("cart", cart);
                }
            }

            // ================= REDIRECT LOGIC =================
            // If the request came from the menu page, stay on the menu page!
            if ("menu".equals(source) && restaurantIdStr != null && !restaurantIdStr.isEmpty()) {
                
                if ("add".equals(action)) {
                    // Pass added=true and qty to trigger the Toast Notification
                    resp.sendRedirect("menu?restaurantId=" + restaurantIdStr + "&added=true&qty=" + quantity);
                } else {
                    // For update (+/- buttons), just stay on the menu page without the toast
                    resp.sendRedirect("menu?restaurantId=" + restaurantIdStr);
                }
                
            } else {
                // Otherwise, go to the cart page
                resp.sendRedirect("cart");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("cart?error=something_went_wrong");
        }
    }
}