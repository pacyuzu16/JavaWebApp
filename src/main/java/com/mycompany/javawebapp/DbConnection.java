package com.mycompany.javawebapp;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DbConnection {
    private static final Logger logger = LoggerFactory.getLogger(DbConnection.class);

    // Database credentials for XAMPP
    private static final String URL = "jdbc:mysql://localhost:3306/employee_db?socket=/opt/lampp/var/mysql/mysql.sock";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // Empty for XAMPP default

    /**
     * Establishes and returns a connection to the XAMPP MySQL database.
     * @return Connection object
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        try {
            // Load MySQL JDBC Driver (optional in Java 8+)
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Establish connection
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            logger.info("Database Connected Successfully!");
            return conn;
        } catch (ClassNotFoundException e) {
            logger.error("JDBC Driver not found: {}", e.getMessage());
            throw new SQLException("Database driver not found", e);
        } catch (SQLException e) {
            logger.error("Database Connection Failed: {}", e.getMessage());
            throw e;
        }
    }

    // For standalone testing
    public static void main(String[] args) {
        try {
            Connection conn = getConnection();
            if (conn != null) {
                conn.close();
                logger.info("Connection closed.");
            }
        } catch (SQLException e) {
            logger.error("Error in main: {}", e.getMessage());
        }
    }
}