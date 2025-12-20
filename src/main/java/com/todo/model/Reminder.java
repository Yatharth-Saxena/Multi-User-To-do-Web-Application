package com.todo.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Reminder implements Serializable {
    private int id;
    private int taskId;
    private Timestamp reminderTime;
    private boolean isSent;
    private Timestamp createdAt;

    public Reminder() {
    }

    public Reminder(int taskId, Timestamp reminderTime) {
        this.taskId = taskId;
        this.reminderTime = reminderTime;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public Timestamp getReminderTime() {
        return reminderTime;
    }

    public void setReminderTime(Timestamp reminderTime) {
        this.reminderTime = reminderTime;
    }

    public boolean isSent() {
        return isSent;
    }

    public void setSent(boolean sent) {
        isSent = sent;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
