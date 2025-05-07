package com.mycompany.javawebapp.dao;

import com.mycompany.javawebapp.DbConnection;
import com.mycompany.javawebapp.model.Employee;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class EmployeeDAO {
    private static final Logger logger = LoggerFactory.getLogger(EmployeeDAO.class);

    private static final String INSERT = "INSERT INTO employees (name, email, country) VALUES (?, ?, ?)";
    private static final String SELECT_BY_ID = "SELECT * FROM employees WHERE id = ? AND deleted_at IS NULL";
    private static final String SELECT_ALL = "SELECT * FROM employees WHERE (name LIKE ? OR email LIKE ? OR country LIKE ?) AND deleted_at IS NULL ORDER BY %s %s LIMIT ? OFFSET ?";
    private static final String COUNT_EMPLOYEES = "SELECT COUNT(*) FROM employees WHERE (name LIKE ? OR email LIKE ? OR country LIKE ?) AND deleted_at IS NULL";
    private static final String SOFT_DELETE = "UPDATE employees SET deleted_at = CURRENT_TIMESTAMP WHERE id = ? AND deleted_at IS NULL";
    private static final String UPDATE = "UPDATE employees SET name = ?, email = ?, country = ? WHERE id = ? AND deleted_at IS NULL";

    // New queries for the bin
    private static final String SELECT_DELETED = "SELECT * FROM employees WHERE deleted_at IS NOT NULL ORDER BY deleted_at DESC LIMIT ? OFFSET ?";
    private static final String COUNT_DELETED = "SELECT COUNT(*) FROM employees WHERE deleted_at IS NOT NULL";
    private static final String RESTORE = "UPDATE employees SET deleted_at = NULL WHERE id = ? AND deleted_at IS NOT NULL";
    private static final String PERMANENT_DELETE = "DELETE FROM employees WHERE id = ? AND deleted_at IS NOT NULL";
    private static final String CLEANUP_OLD_DELETED = "DELETE FROM employees WHERE deleted_at IS NOT NULL AND deleted_at < ?";

    public void insertEmployee(Employee employee) throws SQLException {
        logger.debug("Inserting employee: {}", employee.getName());
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, employee.getName());
            ps.setString(2, employee.getEmail());
            ps.setString(3, employee.getCountry());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                employee.setId(rs.getInt(1));
            }
            logger.info("Employee {} inserted successfully", employee.getName());
        } catch (SQLException e) {
            logger.error("Error inserting employee: {}", employee.getName(), e);
            throw e;
        }
    }

    public Employee selectEmployee(int id) throws SQLException {
        logger.debug("Selecting employee with ID: {}", id);
        Employee employee = null;
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                employee = new Employee(rs.getInt("id"), rs.getString("name"),
                        rs.getString("email"), rs.getString("country"));
                logger.debug("Found employee: {}", employee.getName());
            } else {
                logger.warn("No employee found with ID: {}", id);
            }
        } catch (SQLException e) {
            logger.error("Error selecting employee with ID: {}", id, e);
            throw e;
        }
        return employee;
    }

    public List<Employee> selectEmployees(String search, String sortBy, String sortOrder, int limit, int offset) throws SQLException {
        logger.debug("Selecting employees with search: '{}', sortBy: {}, sortOrder: {}, limit: {}, offset: {}", 
                     search, sortBy, sortOrder, limit, offset);
        List<Employee> employees = new ArrayList<>();
        String column;
        switch (sortBy.toLowerCase()) {
            case "name": column = "name"; break;
            case "email": column = "email"; break;
            case "country": column = "country"; break;
            case "id":
            default: column = "id"; break;
        }
        String order = sortOrder.equalsIgnoreCase("desc") ? "DESC" : "ASC";
        String sql = String.format(SELECT_ALL, column, order);

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + search + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setInt(4, limit);
            ps.setInt(5, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                employees.add(new Employee(rs.getInt("id"), rs.getString("name"),
                        rs.getString("email"), rs.getString("country")));
            }
            logger.info("Fetched {} employees", employees.size());
        } catch (SQLException e) {
            logger.error("Error selecting employees with search: '{}'", search, e);
            throw e;
        }
        return employees;
    }

    public List<Employee> selectAllEmployees() throws SQLException {
        logger.debug("Selecting all employees");
        return selectEmployees("", "id", "asc", Integer.MAX_VALUE, 0);
    }

    public int getTotalEmployeeCount(String search) throws SQLException {
        logger.debug("Counting employees with search: '{}'", search);
        int count = 0;
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_EMPLOYEES)) {
            String searchPattern = "%" + search + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            logger.debug("Total employees: {}", count);
        } catch (SQLException e) {
            logger.error("Error counting employees with search: '{}'", search, e);
            throw e;
        }
        return count;
    }

    public boolean softDeleteEmployee(int id) throws SQLException {
        logger.debug("Soft deleting employee with ID: {}", id);
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SOFT_DELETE)) {
            ps.setInt(1, id);
            boolean deleted = ps.executeUpdate() > 0;
            if (deleted) {
                logger.info("Employee with ID: {} moved to bin", id);
            } else {
                logger.warn("No employee found to soft delete with ID: {}", id);
            }
            return deleted;
        } catch (SQLException e) {
            logger.error("Error soft deleting employee with ID: {}", id, e);
            throw e;
        }
    }

    public boolean updateEmployee(Employee employee) throws SQLException {
        logger.debug("Updating employee with ID: {}", employee.getId());
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE)) {
            ps.setString(1, employee.getName());
            ps.setString(2, employee.getEmail());
            ps.setString(3, employee.getCountry());
            ps.setInt(4, employee.getId());
            boolean updated = ps.executeUpdate() > 0;
            if (updated) {
                logger.info("Employee with ID: {} updated successfully", employee.getId());
            } else {
                logger.warn("No employee found to update with ID: {}", employee.getId());
            }
            return updated;
        } catch (SQLException e) {
            logger.error("Error updating employee with ID: {}", employee.getId(), e);
            throw e;
        }
    }

    // New methods for the bin
    public List<Employee> selectDeletedEmployees(int limit, int offset) throws SQLException {
        logger.debug("Selecting deleted employees with limit: {}, offset: {}", limit, offset);
        List<Employee> deletedEmployees = new ArrayList<>();
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_DELETED)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Employee employee = new Employee(rs.getInt("id"), rs.getString("name"),
                        rs.getString("email"), rs.getString("country"));
                employee.setDeletedAt(rs.getTimestamp("deleted_at"));
                deletedEmployees.add(employee);
            }
            logger.info("Retrieved {} deleted employees", deletedEmployees.size());
        } catch (SQLException e) {
            logger.error("Error retrieving deleted employees", e);
            throw e;
        }
        return deletedEmployees;
    }

    public int getTotalDeletedEmployeeCount() throws SQLException {
        logger.debug("Counting deleted employees");
        int count = 0;
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_DELETED)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            logger.debug("Total deleted employees: {}", count);
        } catch (SQLException e) {
            logger.error("Error counting deleted employees", e);
            throw e;
        }
        return count;
    }

    public boolean restoreEmployee(int id) throws SQLException {
        logger.debug("Restoring employee with ID: {}", id);
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(RESTORE)) {
            ps.setInt(1, id);
            boolean restored = ps.executeUpdate() > 0;
            if (restored) {
                logger.info("Employee with ID: {} restored successfully", id);
            } else {
                logger.warn("No deleted employee found with ID: {}", id);
            }
            return restored;
        } catch (SQLException e) {
            logger.error("Error restoring employee with ID: {}", id, e);
            throw e;
        }
    }

    public boolean permanentDeleteEmployee(int id) throws SQLException {
        logger.debug("Permanently deleting employee with ID: {}", id);
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(PERMANENT_DELETE)) {
            ps.setInt(1, id);
            boolean deleted = ps.executeUpdate() > 0;
            if (deleted) {
                logger.info("Employee with ID: {} permanently deleted", id);
            } else {
                logger.warn("No deleted employee found with ID: {}", id);
            }
            return deleted;
        } catch (SQLException e) {
            logger.error("Error permanently deleting employee with ID: {}", id, e);
            throw e;
        }
    }

    public void cleanupOldDeletedEmployees() throws SQLException {
        logger.debug("Cleaning up employees deleted more than 30 days ago");
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(CLEANUP_OLD_DELETED)) {
            // Calculate the timestamp for 30 days ago
            long thirtyDaysAgo = System.currentTimeMillis() - (30L * 24 * 60 * 60 * 1000);
            ps.setTimestamp(1, new Timestamp(thirtyDaysAgo));
            int rowsDeleted = ps.executeUpdate();
            logger.info("Permanently deleted {} old employees from the bin", rowsDeleted);
        } catch (SQLException e) {
            logger.error("Error cleaning up old deleted employees", e);
            throw e;
        }
    }
}