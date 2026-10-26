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

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("loggedInUser");
        
        if (currentUser == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // Get updated details from the form
        String username = req.getParameter("username");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        // Update the user object
        currentUser.setUsername(username);
        currentUser.setPhone(phone);
        currentUser.setAddress(address);

        // Save to database
        UserDao userDao = new UserDaoImpl();
        userDao.updateUser(currentUser);

        // Update the session with the new user object
        session.setAttribute("loggedInUser", currentUser);

        // Redirect back to profile with a success message
        resp.sendRedirect("profile?success=true");
    }
}