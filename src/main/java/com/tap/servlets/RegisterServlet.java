package com.tap.servlets;

import java.io.IOException;
import com.tap.Dao.UserDao;
import com.tap.DaoImpl.UserDaoImpl;
import com.tap.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// IMPORT BCRYPT
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        String username = req.getParameter("username");
        String plainPassword = req.getParameter("password");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String role = "CUSTOMER"; // Default role

        // 1. ENCRYPT THE PASSWORD
        // BCrypt.gensalt() adds a random salt to make every hash unique
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());

        // 2. Create User object with the HASHED password
        User newUser = new User(0, username, hashedPassword, email, phone, address, role);
        
        UserDao userDao = new UserDaoImpl();
        
        // Optional: Check if email already exists before inserting
        if (userDao.getUserByUsername(email) != null) {
            req.setAttribute("errorMessage", "An account with this email already exists.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        userDao.addUser(newUser);

        resp.sendRedirect("login.jsp?registration=success");
    }
}