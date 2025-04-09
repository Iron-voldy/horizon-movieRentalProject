package com.movierental.servlet.user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movierental.model.user.User;
import com.movierental.model.user.UserManager;

/**
 * Servlet for handling user login
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the login form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // User is already logged in, redirect to home page
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Forward to the login page
        request.getRequestDispatcher("/user/login.jsp").forward(request, response);
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

        System.out.println("LoginServlet: Login attempt for user: " + username);

        // Validate input
        if (username == null || password == null ||
                username.trim().isEmpty() || password.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Username and password are required");
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
            return;
        }

        try {
            // Create UserManager and attempt authentication
            UserManager userManager = new UserManager(getServletContext());
            User user = userManager.authenticateUser(username, password);

            System.out.println("LoginServlet: Authentication result for " + username + ": " + (user != null ? "Success" : "Failed"));

            if (user != null) {
                // Create session and add user
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getUsername());

                System.out.println("LoginServlet: User logged in successfully: " + username);

                // Redirect to home page
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                // Authentication failed
                System.out.println("LoginServlet: Authentication failed for user: " + username);
                request.setAttribute("errorMessage", "Invalid username or password");
                request.getRequestDispatcher("/user/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Log any exceptions
            System.err.println("LoginServlet: Exception occurred during login:");
            e.printStackTrace();

            request.setAttribute("errorMessage", "An error occurred during login: " + e.getMessage());
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
        }
    }

    /**
     * Handles logout requests
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the current session
        HttpSession session = request.getSession(false);

        // Invalidate session if it exists
        if (session != null) {
            session.invalidate();
        }

        // Redirect to login page
        response.sendRedirect(request.getContextPath() + "/login");
    }
}