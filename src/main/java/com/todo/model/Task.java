package com.todo.model;

import java.io.Serializable;

import java.sql.Timestamp;

public class Task implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private int userId;
    private String title;
    private String description;
    private String status;
    private String priority;
    private Timestamp dueDate;
    private Timestamp createdAt;
    private boolean isDeleted = false; // Default to false to match database default
    private java.util.List<Reminder> reminders = new java.util.ArrayList<>();

    public Task() {
    }

    public Task(int userId, String title, String description, String status, String priority, Timestamp dueDate) {
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.status = status;
        this.priority = priority;
        this.dueDate = dueDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public Timestamp getDueDate() {
        return dueDate;
    }

    public void setDueDate(Timestamp dueDate) {
        this.dueDate = dueDate;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }

    public java.util.List<Reminder> getReminders() {
        return reminders;
    }

    public void setReminders(java.util.List<Reminder> reminders) {
        this.reminders = reminders;
    }
}
