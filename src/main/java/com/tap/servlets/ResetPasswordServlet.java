package com.tap.servlets;

import java.io.IOException;
import com.tap.Dao.UserDao;
import com.tap.DaoImpl.UserDaoImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/resetPassword")
public class ResetPasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email"); // Passed via hidden field
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        // 1. Validate passwords match
        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("resetEmail", email);
            req.setAttribute("errorMessage", "Passwords do not match. Try again.");
            req.getRequestDispatcher("reset_password.jsp").forward(req, resp);
            return;
        }

        // 2. Encrypt the new password
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

        // 3. Update the database
        UserDao userDao = new UserDaoImpl();
        boolean isUpdated = userDao.updateUserPassword(email, hashedPassword);

        if (isUpdated) {
            resp.sendRedirect("login.jsp?reset=success");
        } else {
            req.setAttribute("resetEmail", email);
            req.setAttribute("errorMessage", "Something went wrong. Please try again.");
            req.getRequestDispatcher("reset_password.jsp").forward(req, resp);
        }
    }
}