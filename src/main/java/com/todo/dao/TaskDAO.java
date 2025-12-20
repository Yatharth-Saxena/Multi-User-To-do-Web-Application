package com.todo.dao;

import com.todo.model.Task;
import com.todo.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TaskDAO {
    private ReminderDAO reminderDAO = new ReminderDAO();

    public int addTask(Task task) {
        String sql = "INSERT INTO tasks (user_id, title, description, status, priority, due_date) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, task.getUserId());
            pstmt.setString(2, task.getTitle());
            pstmt.setString(3, task.getDescription());
            pstmt.setString(4, task.getStatus());
            pstmt.setString(5, task.getPriority());
            pstmt.setTimestamp(6, task.getDueDate());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
            return -1;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    public List<Task> getTasksByUserId(int userId) {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT * FROM tasks WHERE user_id = ? AND is_deleted = FALSE ORDER BY due_date ASC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Task task = new Task();
                    task.setId(rs.getInt("id"));
                    task.setUserId(rs.getInt("user_id"));
                    task.setTitle(rs.getString("title"));
                    task.setDescription(rs.getString("description"));
                    task.setStatus(rs.getString("status"));
                    task.setPriority(rs.getString("priority"));
                    task.setDueDate(rs.getTimestamp("due_date"));
                    task.setCreatedAt(rs.getTimestamp("created_at"));
                    task.setReminders(reminderDAO.getRemindersByTaskId(task.getId()));
                    tasks.add(task);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // ... (existing methods)

    public List<Task> getAllTasks() {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT * FROM tasks ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Task task = new Task();
                task.setId(rs.getInt("id"));
                task.setUserId(rs.getInt("user_id"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setStatus(rs.getString("status"));
                task.setPriority(rs.getString("priority"));
                task.setDueDate(rs.getTimestamp("due_date"));
                task.setCreatedAt(rs.getTimestamp("created_at"));
                task.setReminders(reminderDAO.getRemindersByTaskId(task.getId()));
                tasks.add(task);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    public boolean softDeleteTask(int id) {
        String sql = "UPDATE tasks SET is_deleted = TRUE WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean reassignTask(int taskId, int newUserId) {
        String sql = "UPDATE tasks SET user_id = ? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, newUserId);
            pstmt.setInt(2, taskId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Task getTaskById(int id) {
        String sql = "SELECT * FROM tasks WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Task task = new Task();
                    task.setId(rs.getInt("id"));
                    task.setUserId(rs.getInt("user_id"));
                    task.setTitle(rs.getString("title"));
                    task.setDescription(rs.getString("description"));
                    task.setStatus(rs.getString("status"));
                    task.setPriority(rs.getString("priority"));
                    task.setDueDate(rs.getTimestamp("due_date"));
                    task.setCreatedAt(rs.getTimestamp("created_at"));
                    task.setReminders(reminderDAO.getRemindersByTaskId(task.getId()));
                    return task;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateTask(Task task) {
        String sql = "UPDATE tasks SET title=?, description=?, status=?, priority=?, due_date=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, task.getTitle());
            pstmt.setString(2, task.getDescription());
            pstmt.setString(3, task.getStatus());
            pstmt.setString(4, task.getPriority());
            pstmt.setTimestamp(5, task.getDueDate());
            pstmt.setInt(6, task.getId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteTask(int id) {
        String sql = "DELETE FROM tasks WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
