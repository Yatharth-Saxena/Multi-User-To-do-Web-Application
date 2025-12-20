package com.todo.servlet;

import com.todo.dao.UserDAO;
import com.todo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String role = "USER"; // Default role

        // Server-side validation
        if (username == null || !username.matches("^[a-zA-Z0-9]+$")) {
            request.setAttribute("error", "Invalid username. Alphanumeric characters only.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (password.contains(" ")) {
            request.setAttribute("error", "Password cannot contain spaces.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        try {
            if (userDAO.isUsernameTaken(username)) {
                request.setAttribute("error", "Username already taken");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            User newUser = new User(username, password, email, role);
            if (userDAO.registerUser(newUser)) {
                response.sendRedirect("login?registered=true");
            } else {
                request.setAttribute("error", "Registration failed");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database connection failed. Please check your db.properties configuration.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}
