package com.mycompany.javawebapp.servlet;

import com.mycompany.javawebapp.dao.UserDAO;
import com.mycompany.javawebapp.model.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@WebServlet(
   urlPatterns = {"/login", "/register", "/logout", "/forgot-password", "/reset-password"}
)
public class UserServlet extends HttpServlet {
   private static final Logger logger = LoggerFactory.getLogger(UserServlet.class);
   private UserDAO userDAO;

   public UserServlet() {
   }

   public void init() {
      logger.info("Initializing UserServlet");
      this.userDAO = new UserDAO();
   }

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String action = request.getServletPath();
      logger.debug("Processing request for action: {}", action);

      try {
         switch (action) {
            case "/login":
               this.showLoginForm(request, response);
               break;
            case "/register":
               this.showRegisterForm(request, response);
               break;
            case "/logout":
               this.logoutUser(request, response);
               break;
            case "/forgot-password":
               this.showForgotPasswordForm(request, response);
               break;
            case "/reset-password":
               this.showResetPasswordForm(request, response);
               break;
            default:
               response.sendRedirect(request.getContextPath() + "/login");
         }

      } catch (IOException | ServletException var6) {
         logger.error("Unexpected error while processing action: {}", action, var6);
         throw new ServletException(var6);
      }
   }

   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String action = request.getServletPath();
      logger.debug("Processing POST request for action: {}", action);

      try {
         switch (action) {
            case "/login":
               this.loginUser(request, response);
               break;
            case "/register":
               this.registerUser(request, response);
               break;
            case "/forgot-password":
               this.requestPasswordReset(request, response);
               break;
            case "/reset-password":
               this.resetPassword(request, response);
               break;
            default:
               response.sendRedirect(request.getContextPath() + "/login");
         }

      } catch (SQLException var6) {
         logger.error("Database error while processing action: {}", action, var6);
         throw new ServletException(var6);
      } catch (IOException | ServletException var7) {
         logger.error("Unexpected error while processing action: {}", action, var7);
         throw new ServletException(var7);
      }
   }

   private void showLoginForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
      dispatcher.forward(request, response);
   }

   private void showRegisterForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      RequestDispatcher dispatcher = request.getRequestDispatcher("/register.jsp");
      dispatcher.forward(request, response);
   }

   private void showForgotPasswordForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      RequestDispatcher dispatcher = request.getRequestDispatcher("/forgot-password.jsp");
      dispatcher.forward(request, response);
   }

   private void showResetPasswordForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String token = request.getParameter("token");
      if (token == null || token.isEmpty()) {
         request.setAttribute("error", "Invalid or missing reset token");
         RequestDispatcher dispatcher = request.getRequestDispatcher("/forgot-password.jsp");
         dispatcher.forward(request, response);
         return;
      }
      // In a real app, validate the token against the database
      RequestDispatcher dispatcher = request.getRequestDispatcher("/reset-password.jsp");
      dispatcher.forward(request, response);
   }

   private void loginUser(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
      String username = request.getParameter("username");
      String password = request.getParameter("password");
      User user = this.userDAO.findUserByUsername(username);
      if (user != null && user.getPassword().equals(password)) {
         logger.info("User {} logged in successfully", username);
         HttpSession session = request.getSession();
         session.setAttribute("user", user);
         response.sendRedirect(request.getContextPath() + "/");
      } else {
         logger.warn("Login failed for username: {}", username);
         request.setAttribute("error", "Invalid username or password");
         RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
         dispatcher.forward(request, response);
      }
   }

   private void registerUser(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
      String username = request.getParameter("username");
      String email = request.getParameter("email");
      String password = request.getParameter("password");
      List<String> errors = new ArrayList();
      if (username == null || username.trim().isEmpty()) {
         errors.add("Username is required");
      }

      if (email == null || !email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
         errors.add("Please enter a valid email");
      }

      if (password == null || password.trim().isEmpty()) {
         errors.add("Password is required");
      }

      User existingUser = this.userDAO.findUserByUsername(username);
      if (existingUser != null) {
         errors.add("Username already exists");
      }

      if (!errors.isEmpty()) {
         logger.warn("Validation errors during registration: {}", errors);
         request.setAttribute("errors", errors);
         RequestDispatcher dispatcher = request.getRequestDispatcher("/register.jsp");
         dispatcher.forward(request, response);
      } else {
         User newUser = new User(username, password, email);
         this.userDAO.registerUser(newUser);
         logger.info("User {} registered successfully", username);
         response.sendRedirect(request.getContextPath() + "/login");
      }
   }

   private void requestPasswordReset(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
    String email = request.getParameter("email");
    User user = this.userDAO.findUserByEmail(email);

    if (user == null) {
        logger.warn("No user found with email: {}", email);
        request.setAttribute("error", "No account found with that email address");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/forgot-password.jsp");
        dispatcher.forward(request, response);
        return;
    }

    // Simulate generating a reset token and sending an email
    String resetToken = UUID.randomUUID().toString();
    // In a real app, store the token in the database with an expiration time
    // For simulation, store the email in the session (not secure, just for simulation)
    HttpSession session = request.getSession();
    session.setAttribute("resetEmail", email); // Store email temporarily

    String resetLink = request.getContextPath() + "/reset-password?token=" + resetToken;
    logger.info("Password reset requested for email: {}. Reset link: {}", email, resetLink);

    // Simulate email sent
    request.setAttribute("success", "A password reset link has been sent to your email. Check your inbox (simulated).");
    RequestDispatcher dispatcher = request.getRequestDispatcher("/forgot-password.jsp");
    dispatcher.forward(request, response);
}
   
   private void resetPassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
    String token = request.getParameter("token");
    String newPassword = request.getParameter("password");

    if (token == null || token.isEmpty()) {
        request.setAttribute("error", "Invalid or missing reset token");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/forgot-password.jsp");
        dispatcher.forward(request, response);
        return;
    }

    if (newPassword == null || newPassword.trim().isEmpty()) {
        request.setAttribute("error", "New password is required");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/reset-password.jsp");
        dispatcher.forward(request, response);
        return;
    }

    // In a real app, validate the token against the database and retrieve the associated email
    // For this simulation, we'll assume the token was stored with the email in the session or database
    // Since we don't have a token-email mapping, we'll need to simulate this part
    // For now, let's assume the email was stored in the session during the forgot-password request (not secure, just for simulation)
    HttpSession session = request.getSession(false);
    String email = (String) session.getAttribute("resetEmail"); // Simulated email retrieval

    if (email == null) {
        request.setAttribute("error", "Invalid or expired reset token");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/forgot-password.jsp");
        dispatcher.forward(request, response);
        return;
    }

    // Update the password
    this.userDAO.updatePassword(email, newPassword);
    logger.info("Password reset successful for email: {}", email);

    // Clear the session attribute (simulated token-email mapping)
    session.removeAttribute("resetEmail");

    // Redirect to login with a success message
    request.setAttribute("success", "Password reset successful. Please sign in with your new password.");
    RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
    dispatcher.forward(request, response);
}
   private void logoutUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
      HttpSession session = request.getSession(false);
      if (session != null) {
         session.invalidate();
         logger.info("User logged out successfully");
      }

      response.sendRedirect(request.getContextPath() + "/login");
   }
}