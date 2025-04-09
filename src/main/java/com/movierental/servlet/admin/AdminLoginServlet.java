package com.movierental.servlet.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movierental.model.admin.Admin;
import com.movierental.model.admin.AdminManager;

/**
 * Servlet for handling admin login
 */
@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the login form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if admin is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("admin") != null) {
            // Admin is already logged in, redirect to dashboard
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        // Forward to the login page
        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the login form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("AdminLoginServlet: Login attempt for admin: " + username);

        // Validate input
        if (username == null || password == null ||
                username.trim().isEmpty() || password.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Username and password are required");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        try {
            // Create AdminManager and attempt authentication
            AdminManager adminManager = new AdminManager(getServletContext());
            Admin admin = adminManager.authenticateAdmin(username, password);

            System.out.println("AdminLoginServlet: Authentication result for " + username + ": " + (admin != null ? "Success" : "Failed"));

            if (admin != null) {
                // Create session and add admin
                HttpSession session = request.getSession(true);
                session.setAttribute("admin", admin);
                session.setAttribute("adminId", admin.getAdminId());
                session.setAttribute("adminUsername", admin.getUsername());
                session.setAttribute("adminRole", admin.getRole());

                System.out.println("AdminLoginServlet: Admin logged in successfully: " + username);

                // Redirect to dashboard
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                // Authentication failed
                System.out.println("AdminLoginServlet: Authentication failed for admin: " + username);
                request.setAttribute("errorMessage", "Invalid username or password");
                request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Log any exceptions
            System.err.println("AdminLoginServlet: Exception occurred during login:");
            e.printStackTrace();

            request.setAttribute("errorMessage", "An error occurred during login: " + e.getMessage());
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
        }
    }
}