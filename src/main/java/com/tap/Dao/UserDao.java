package com.tap.Dao;

import java.util.List;
import com.tap.model.User;

public interface UserDao {
    void addUser(User user);
    User getUser(int userId);
    List<User> getAllUsers();
    void updateUser(User user);
    void deleteUser(int userId);
    User getUserByUsername(String username);
    User getUserByEmail(String email); // Needed for Login & Forgot Password
    boolean updateUserPassword(String email, String newPasswordHash); // Needed for Forgot Password
}