package com.todo.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.io.InputStream;
import java.io.IOException;
import java.util.Properties;

public class DBConnection {
    private static Properties properties = new Properties();

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
                if (input == null) {
                    System.err.println("CRITICAL ERROR: db.properties file not found in classpath!");
                    throw new RuntimeException("db.properties not found");
                } else {
                    properties.load(input);
                }
            }
        } catch (ClassNotFoundException | IOException e) {
            System.err.println("CRITICAL ERROR: Failed to initialize database connection settings.");
            e.printStackTrace();
            throw new RuntimeException("Error initializing DB connection", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                properties.getProperty("db.url"),
                properties.getProperty("db.user"),
                properties.getProperty("db.password"));
    }
}
