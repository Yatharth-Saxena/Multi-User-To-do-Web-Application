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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username != null && username.contains(" ")) {
            request.setAttribute("error", "Username cannot contain spaces.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (password != null && password.contains(" ")) {
            request.setAttribute("error", "Password cannot contain spaces.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.loginUser(username, password);

        if (user != null) {
            if (!user.isActive()) {
                request.setAttribute("error", "Account is deactivated. Please contact admin.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Redirect admins to admin panel, regular users to dashboard
            String loginType = request.getParameter("loginType");
            System.out.println("DEBUG: loginType=" + loginType + ", role=" + user.getRole());

            if ("admin".equals(loginType) && !"ADMIN".equals(user.getRole())) {
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            if ("user".equals(loginType) && "ADMIN".equals(user.getRole())) {
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("admin");
            } else {
                response.sendRedirect("dashboard");
            }
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
