package com.todo.dao;

import com.todo.model.Reminder;
import com.todo.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReminderDAO {

    public boolean addReminder(Reminder reminder) {
        String sql = "INSERT INTO reminders (task_id, reminder_time) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reminder.getTaskId());
            pstmt.setTimestamp(2, reminder.getReminderTime());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Reminder> getRemindersByTaskId(int taskId) {
        List<Reminder> reminders = new ArrayList<>();
        String sql = "SELECT * FROM reminders WHERE task_id = ? ORDER BY reminder_time ASC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, taskId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Reminder reminder = new Reminder();
                    reminder.setId(rs.getInt("id"));
                    reminder.setTaskId(rs.getInt("task_id"));
                    reminder.setReminderTime(rs.getTimestamp("reminder_time"));
                    reminder.setSent(rs.getBoolean("is_sent"));
                    reminder.setCreatedAt(rs.getTimestamp("created_at"));
                    reminders.add(reminder);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reminders;
    }

    public boolean deleteReminder(int id) {
        String sql = "DELETE FROM reminders WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Reminder> getDueUnsentReminders() {
        List<Reminder> reminders = new ArrayList<>();
        String sql = "SELECT * FROM reminders WHERE reminder_time <= NOW() AND is_sent = FALSE";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Reminder reminder = new Reminder();
                reminder.setId(rs.getInt("id"));
                reminder.setTaskId(rs.getInt("task_id"));
                reminder.setReminderTime(rs.getTimestamp("reminder_time"));
                reminder.setSent(rs.getBoolean("is_sent"));
                reminder.setCreatedAt(rs.getTimestamp("created_at"));
                reminders.add(reminder);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reminders;
    }

    public boolean markAsSent(int id) {
        String sql = "UPDATE reminders SET is_sent = TRUE WHERE id = ?";
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
