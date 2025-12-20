package com.todo.util;

import com.todo.dao.ReminderDAO;
import com.todo.dao.TaskDAO;
import com.todo.model.Reminder;
import com.todo.model.Task;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class ReminderScheduler implements ServletContextListener {

    private ScheduledExecutorService scheduler;
    private ReminderDAO reminderDAO = new ReminderDAO();
    private TaskDAO taskDAO = new TaskDAO();

    @Override
    public void contextInitialized(ServletContextEvent event) {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        // Check every minute
        scheduler.scheduleAtFixedRate(this::checkReminders, 0, 1, TimeUnit.MINUTES);
        System.out.println("Reminder Scheduler started.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        if (scheduler != null) {
            scheduler.shutdownNow();
        }
        System.out.println("Reminder Scheduler stopped.");
    }

    private void checkReminders() {
        try {
            List<Reminder> dueReminders = reminderDAO.getDueUnsentReminders();
            for (Reminder reminder : dueReminders) {
                Task task = taskDAO.getTaskById(reminder.getTaskId());
                if (task != null) {
                    // Skip if task is already done
                    if ("DONE".equals(task.getStatus())) {
                        reminderDAO.markAsSent(reminder.getId());
                        continue;
                    }

                    String userEmail = getUserEmail(task.getUserId());
                    if (userEmail != null) {
                        String subject = "Reminder: " + task.getTitle();
                        String message = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; border-radius: 5px; background-color: #f9f9f9;'>"
                                +
                                "<h2 style='color: #333;'>" + task.getTitle() + "</h2>" +
                                "<p style='color: #555; font-size: 16px;'>" + task.getDescription() + "</p>" +
                                "<p style='font-size: 14px; color: #777;'>Due Date: <strong style='color: #d9534f; font-size: 16px;'>"
                                + task.getDueDate() + "</strong></p>" +
                                "<hr style='border: 0; border-top: 1px solid #eee; margin: 20px 0;'>" +
                                "<p style='font-size: 12px; color: #aaa;'>This is an automated reminder from your To-Do App.</p>"
                                +
                                "</div>";

                        boolean sent = EmailService.sendEmail(userEmail, subject, message);
                        if (sent) {
                            reminderDAO.markAsSent(reminder.getId());
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String getUserEmail(int userId) {
        String sql = "SELECT email FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("email");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
