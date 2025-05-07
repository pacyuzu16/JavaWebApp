package com.mycompany.javawebapp.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author pacyuzu
 */
@WebFilter(urlPatterns = {"/", "/new", "/insert", "/edit", "/update", "/delete", "/bulkAdd", "/bulkInsert", "/department", "/department/new", "/department/insert", "/department/edit", "/department/update", "/department/delete"})
public class AuthFilter implements Filter {
    private static final Logger logger = LoggerFactory.getLogger(AuthFilter.class);

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("Initializing AuthFilter");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        String requestURI = httpRequest.getRequestURI();

        // Allow access to login, register, and logout pages without authentication
        if (requestURI.endsWith("/login") || requestURI.endsWith("/register") || requestURI.endsWith("/logout")) {
            chain.doFilter(request, response);
            return;
        }

        // Check if user is logged in
        if (session != null && session.getAttribute("user") != null) {
            chain.doFilter(request, response); // User is authenticated, proceed
        } else {
            logger.warn("Unauthorized access attempt to: {}", requestURI);
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        }
    }

    @Override
    public void destroy() {
        logger.info("Destroying AuthFilter");
    }
}