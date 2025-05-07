package com.mycompany.javawebapp.dao;

import com.mycompany.javawebapp.DbConnection;
import com.mycompany.javawebapp.model.User;
import java.sql.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UserDAO {
    private static final Logger logger = LoggerFactory.getLogger(UserDAO.class);

    private static final String INSERT_USER = "INSERT INTO users (username, password, email) VALUES (?, ?, ?)";
    private static final String SELECT_BY_USERNAME = "SELECT * FROM users WHERE username = ?";
    private static final String SELECT_BY_EMAIL = "SELECT * FROM users WHERE email = ?"; // New query for finding user by email
    private static final String UPDATE_PASSWORD = "UPDATE users SET password = ? WHERE email = ?"; // New query for updating password

    public void registerUser(User user) throws SQLException {
        logger.debug("Registering user: {}", user.getUsername());
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_USER)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.executeUpdate();
            logger.info("User {} registered successfully", user.getUsername());
        } catch (SQLException e) {
            logger.error("Error registering user: {}", user.getUsername(), e);
            throw e;
        }
    }

    public User findUserByUsername(String username) throws SQLException {
        logger.debug("Finding user with username: {}", username);
        User user = null;
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_USERNAME)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User(rs.getInt("id"), rs.getString("username"),
                        rs.getString("password"), rs.getString("email"));
                logger.debug("Found user: {}", username);
            } else {
                logger.warn("No user found with username: {}", username);
            }
        } catch (SQLException e) {
            logger.error("Error finding user with username: {}", username, e);
            throw e;
        }
        return user;
    }

    public User findUserByEmail(String email) throws SQLException {
        logger.debug("Finding user with email: {}", email);
        User user = null;
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_EMAIL)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User(rs.getInt("id"), rs.getString("username"),
                        rs.getString("password"), rs.getString("email"));
                logger.debug("Found user with email: {}", email);
            } else {
                logger.warn("No user found with email: {}", email);
            }
        } catch (SQLException e) {
            logger.error("Error finding user with email: {}", email, e);
            throw e;
        }
        return user;
    }

    public void updatePassword(String email, String newPassword) throws SQLException {
        logger.debug("Updating password for user with email: {}", email);
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_PASSWORD)) {
            ps.setString(1, newPassword);
            ps.setString(2, email);
            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                logger.info("Password updated successfully for email: {}", email);
            } else {
                logger.warn("No user found with email: {} for password update", email);
            }
        } catch (SQLException e) {
            logger.error("Error updating password for email: {}", email, e);
            throw e;
        }
    }
}