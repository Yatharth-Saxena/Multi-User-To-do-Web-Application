package com.todo.servlet;

import com.todo.dao.UserDAO;
import com.todo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        String oldPassword = request.getParameter("oldPassword");

        try {
            // Verify old password is required for any change for security
            if (oldPassword == null || !userDAO.verifyPassword(user.getId(), oldPassword)) {
                request.setAttribute("error", "Incorrect password. Verification failed.");
                request.getRequestDispatcher("profile.jsp").forward(request, response);
                return;
            }

            if ("updateProfile".equals(action)) {
                String username = request.getParameter("username");
                String email = request.getParameter("email");

                if (!user.getUsername().equals(username) && userDAO.isUsernameTaken(username)) {
                    request.setAttribute("error", "Username already taken.");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                    return;
                }

                user.setUsername(username);
                user.setEmail(email);

                if (userDAO.updateUser(user)) {
                    session.setAttribute("user", user); // Update session
                    request.setAttribute("success", "Profile updated successfully!");
                } else {
                    request.setAttribute("error", "Failed to update profile.");
                }

            } else if ("changePassword".equals(action)) {
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");

                if (newPassword == null || newPassword.length() < 4) {
                    request.setAttribute("error", "New password must be at least 4 characters.");
                } else if (!newPassword.equals(confirmPassword)) {
                    request.setAttribute("error", "New passwords do not match.");
                } else {
                    if (userDAO.updatePassword(user.getId(), newPassword)) {
                        // Update password in session object to prevent logout on next action if
                        // implementation checks session pass
                        user.setPassword(newPassword);
                        request.setAttribute("success", "Password changed successfully!");
                    } else {
                        request.setAttribute("error", "Failed to update password.");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred.");
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}
