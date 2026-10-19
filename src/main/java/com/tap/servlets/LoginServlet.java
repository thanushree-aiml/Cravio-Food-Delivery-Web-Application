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
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        String email = req.getParameter("email");
        String plainPassword = req.getParameter("password");

        System.out.println("--- LOGIN ATTEMPT ---");
        System.out.println("Email entered: " + email);
        System.out.println("Password entered: " + plainPassword);

        UserDao userDao = new UserDaoImpl();
        User user = userDao.getUserByEmail(email);

        if (user == null) {
            System.out.println("ERROR: No user found in database with email: " + email);
            req.setAttribute("errorMessage", "Invalid email or password");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        System.out.println("User found in DB!");
        System.out.println("DB Hashed Password: " + user.getPassword());

        // THE CRITICAL CHECK
        boolean passwordMatches = false;
        try {
            passwordMatches = BCrypt.checkpw(plainPassword, user.getPassword());
        } catch (IllegalArgumentException e) {
            System.out.println("ERROR: The password stored in DB is not a valid BCrypt hash!");
        }

        System.out.println("Does password match? " + passwordMatches);
        System.out.println("---------------------");

        if (passwordMatches) {
            HttpSession session = req.getSession();
            session.setAttribute("loggedInUser", user);
            resp.sendRedirect("home"); 
        } else {
            req.setAttribute("errorMessage", "Invalid email or password");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}