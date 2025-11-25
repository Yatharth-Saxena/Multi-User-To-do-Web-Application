package com.todo.servlet;

import com.todo.dao.TaskDAO;
import com.todo.model.Task;
import com.todo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/task")
public class TaskServlet extends HttpServlet {
    private TaskDAO taskDAO;

    public void init() {
        taskDAO = new TaskDAO();
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

        if ("create".equals(action)) {
            createTask(request, response, user);
        } else if ("update".equals(action)) {
            updateTask(request, response, user);
        } else if ("delete".equals(action)) {
            deleteTask(request, response, user);
        } else {
            response.sendRedirect("dashboard");
        }
    }

    private void createTask(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");
        String dueDateStr = request.getParameter("dueDate");

        Date dueDate = null;
        if (dueDateStr != null && !dueDateStr.isEmpty()) {
            dueDate = Date.valueOf(dueDateStr);
        }

        Task task = new Task(user.getId(), title, description, status, priority, dueDate);
        taskDAO.addTask(task);
        response.sendRedirect("dashboard");
    }

    private void updateTask(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");
        String dueDateStr = request.getParameter("dueDate");

        Date dueDate = null;
        if (dueDateStr != null && !dueDateStr.isEmpty()) {
            dueDate = Date.valueOf(dueDateStr);
        }

        Task task = new Task();
        task.setId(id);
        task.setUserId(user.getId()); // Ensure ownership check in real app
        task.setTitle(title);
        task.setDescription(description);
        task.setStatus(status);
        task.setPriority(priority);
        task.setDueDate(dueDate);

        taskDAO.updateTask(task);
        response.sendRedirect("dashboard");
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        // In a real app, verify that the task belongs to the user before deleting
        taskDAO.deleteTask(id);
        response.sendRedirect("dashboard");
    }
}
