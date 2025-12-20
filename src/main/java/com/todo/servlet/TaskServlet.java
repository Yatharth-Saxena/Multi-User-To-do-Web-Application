package com.todo.servlet;

import com.todo.dao.ReminderDAO;
import com.todo.dao.TaskDAO;
import com.todo.model.Reminder;
import com.todo.model.Task;
import com.todo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/task")
public class TaskServlet extends HttpServlet {
    private TaskDAO taskDAO;
    private ReminderDAO reminderDAO;

    public void init() {
        taskDAO = new TaskDAO();
        reminderDAO = new ReminderDAO();
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
        } else if ("markDone".equals(action)) {
            markTaskDone(request, response, user);
        } else if ("addReminder".equals(action)) {
            addReminder(request, response, user);
        } else if ("deleteReminder".equals(action)) {
            deleteReminder(request, response, user);
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

        System.out.println("Creating task: " + title + ", DueDateStr: " + dueDateStr);

        Timestamp dueDate = null;
        if (dueDateStr != null && !dueDateStr.isEmpty()) {
            // HTML datetime-local format is "yyyy-MM-ddTHH:mm"
            // Timestamp.valueOf expects "yyyy-MM-dd HH:mm:ss"
            String formattedDate = dueDateStr.replace("T", " ") + ":00";
            dueDate = Timestamp.valueOf(formattedDate);
            System.out.println("Parsed DueDate: " + dueDate);
        }

        Task task = new Task(user.getId(), title, description, status, priority, dueDate);
        int taskId = taskDAO.addTask(task);
        System.out.println("Task created with ID: " + taskId);

        // Automatically add a reminder if due date is set
        if (taskId != -1 && dueDate != null) {
            System.out.println("Attempting to add automatic reminder for Task ID: " + taskId);
            Reminder reminder = new Reminder(taskId, dueDate);
            boolean added = reminderDAO.addReminder(reminder);
            System.out.println("Automatic reminder added: " + added);
        } else {
            System.out.println("Skipping automatic reminder. TaskID: " + taskId + ", DueDate: " + dueDate);
        }

        response.sendRedirect("dashboard");
    }

    // ... (updateTask, deleteTask, markTaskDone methods remain unchanged)

    private void updateTask(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");
        String dueDateStr = request.getParameter("dueDate");

        Timestamp dueDate = null;
        if (dueDateStr != null && !dueDateStr.isEmpty()) {
            String formattedDate = dueDateStr.replace("T", " ") + ":00";
            dueDate = Timestamp.valueOf(formattedDate);
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
        // For now, we switch to soft delete
        taskDAO.softDeleteTask(id);
        response.sendRedirect("dashboard");
    }

    private void markTaskDone(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            System.out.println("Processing markDone for task ID: " + id + " User: " + user.getUsername());

            // Get the existing task
            Task task = taskDAO.getTaskById(id);
            if (task != null) {
                if (task.getUserId() == user.getId()) {
                    task.setStatus("DONE");
                    boolean updated = taskDAO.updateTask(task);
                    System.out.println("Task update result: " + updated);
                } else {
                    System.out.println("Unauthorized attempt to mark task done. Task User ID: " + task.getUserId()
                            + ", Current User ID: " + user.getId());
                }
            } else {
                System.out.println("Task not found with ID: " + id);
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid task ID format");
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("Error marking task as done");
            e.printStackTrace();
        }

        response.sendRedirect("dashboard");
    }

    private void addReminder(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        int taskId = Integer.parseInt(request.getParameter("taskId"));
        String reminderTimeStr = request.getParameter("reminderTime");

        Task task = taskDAO.getTaskById(taskId);
        if (task != null && "DONE".equals(task.getStatus())) {
            // Do not add reminder if task is DONE
            response.sendRedirect("dashboard");
            return;
        }

        if (reminderTimeStr != null && !reminderTimeStr.isEmpty()) {
            String formattedDate = reminderTimeStr.replace("T", " ") + ":00";
            Timestamp reminderTime = Timestamp.valueOf(formattedDate);

            Reminder reminder = new Reminder(taskId, reminderTime);
            reminderDAO.addReminder(reminder);
        }
        response.sendRedirect("dashboard");
    }

    private void deleteReminder(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        reminderDAO.deleteReminder(id);
        response.sendRedirect("dashboard");
    }
}
