package com.mycompany.javawebapp.servlet;

import com.mycompany.javawebapp.dao.EmployeeDAO;
import com.mycompany.javawebapp.model.Employee;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@WebServlet(
   urlPatterns = {"/", "/new", "/insert", "/delete", "/edit", "/update", "/bin", "/restore", "/permanentDelete"}
)
public class EmployeeServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(EmployeeServlet.class);
    private EmployeeDAO employeeDAO;
    private static final int EMPLOYEES_PER_PAGE = 5;

    public EmployeeServlet() {
    }

    public void init() {
        logger.info("Initializing EmployeeServlet");
        this.employeeDAO = new EmployeeDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        logger.debug("Processing request for action: {}", action);

        try {
            // Clean up old deleted employees on each request
            employeeDAO.cleanupOldDeletedEmployees();

            switch (action) {
                case "/new":
                    showNewForm(request, response);
                    break;
                case "/insert":
                    insertEmployee(request, response);
                    break;
                case "/delete":
                    softDeleteEmployee(request, response); // Updated method name
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updateEmployee(request, response);
                    break;
                case "/bin":
                    showBin(request, response);
                    break;
                case "/restore":
                    restoreEmployee(request, response);
                    break;
                case "/permanentDelete":
                    permanentDeleteEmployee(request, response);
                    break;
                default:
                    listEmployees(request, response);
                    break;
            }
        } catch (SQLException var6) {
            logger.error("Database error while processing action: {}", action, var6);
            throw new ServletException(var6);
        } catch (IOException | ServletException var7) {
            logger.error("Unexpected error while processing action: {}", action, var7);
            throw new ServletException(var7);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    private void listEmployees(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        int page = 1;
        String search = request.getParameter("search");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");

        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "id";
        }

        if (sortOrder == null || sortOrder.isEmpty()) {
            sortOrder = "asc";
        }

        int offset = (page - 1) * EMPLOYEES_PER_PAGE;
        List<Employee> listEmployees;
        int totalEmployees;

        if (search != null && !search.trim().isEmpty()) {
            listEmployees = employeeDAO.selectEmployees(search, sortBy, sortOrder, EMPLOYEES_PER_PAGE, offset);
            totalEmployees = employeeDAO.getTotalEmployeeCount(search);
        } else {
            listEmployees = employeeDAO.selectEmployees("", sortBy, sortOrder, EMPLOYEES_PER_PAGE, offset);
            totalEmployees = employeeDAO.getTotalEmployeeCount("");
        }

        int totalPages = (int) Math.ceil((double) totalEmployees / EMPLOYEES_PER_PAGE);

        request.setAttribute("listEmployees", listEmployees);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/employee-list.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/employee-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Employee existingEmployee = employeeDAO.selectEmployee(id);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/employee-form.jsp");
        request.setAttribute("employee", existingEmployee);
        dispatcher.forward(request, response);
    }

    private void insertEmployee(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String country = request.getParameter("country");

        List<String> errors = new ArrayList<>();

        if (name == null || name.trim().isEmpty()) {
            errors.add("Name is required");
        }

        if (email == null || !email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            errors.add("Please enter a valid email");
        }

        if (country == null || country.trim().isEmpty()) {
            errors.add("Country is required");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("employee", new Employee(name, email, country));
            RequestDispatcher dispatcher = request.getRequestDispatcher("/employee-form.jsp");
            dispatcher.forward(request, response);
            return;
        }

        Employee newEmployee = new Employee(name, email, country);
        employeeDAO.insertEmployee(newEmployee);
        response.sendRedirect(request.getContextPath() + "/");
    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String country = request.getParameter("country");

        List<String> errors = new ArrayList<>();

        if (name == null || name.trim().isEmpty()) {
            errors.add("Name is required");
        }

        if (email == null || !email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            errors.add("Please enter a valid email");
        }

        if (country == null || country.trim().isEmpty()) {
            errors.add("Country is required");
        }

        if (!errors.isEmpty()) {
            Employee employee = new Employee(id, name, email, country);
            request.setAttribute("errors", errors);
            request.setAttribute("employee", employee);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/employee-form.jsp");
            dispatcher.forward(request, response);
            return;
        }

        Employee employee = new Employee(id, name, email, country);
        employeeDAO.updateEmployee(employee);
        response.sendRedirect(request.getContextPath() + "/");
    }

    private void softDeleteEmployee(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        employeeDAO.softDeleteEmployee(id); // Updated to call the new method
        response.sendRedirect(request.getContextPath() + "/");
    }

    private void showBin(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int page = 1;
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        int offset = (page - 1) * EMPLOYEES_PER_PAGE;
        List<Employee> deletedEmployees = employeeDAO.selectDeletedEmployees(EMPLOYEES_PER_PAGE, offset);
        int totalDeletedEmployees = employeeDAO.getTotalDeletedEmployeeCount();
        int totalPages = (int) Math.ceil((double) totalDeletedEmployees / EMPLOYEES_PER_PAGE);

        request.setAttribute("deletedEmployees", deletedEmployees);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/bin.jsp");
        dispatcher.forward(request, response);
    }

    private void restoreEmployee(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        employeeDAO.restoreEmployee(id);
        response.sendRedirect(request.getContextPath() + "/bin");
    }

    private void permanentDeleteEmployee(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        employeeDAO.permanentDeleteEmployee(id);
        response.sendRedirect(request.getContextPath() + "/bin");
    }
}