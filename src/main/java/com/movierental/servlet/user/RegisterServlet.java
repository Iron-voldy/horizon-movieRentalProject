package com.movierental.servlet.user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.movierental.model.user.RegularUser;
import com.movierental.model.user.UserManager;

/**
 * Servlet for handling user registration
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the registration form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to the registration page
        request.getRequestDispatcher("/user/register.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the registration form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");

        // Debug logging
        System.out.println("RegisterServlet: Processing registration for user: " + username);
        System.out.println("RegisterServlet: Email: " + email);
        System.out.println("RegisterServlet: Full Name: " + fullName);

        // Validate input
        if (username == null || password == null || email == null || fullName == null ||
                username.trim().isEmpty() || password.trim().isEmpty() ||
                email.trim().isEmpty() || fullName.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }

        // Create UserManager
        UserManager userManager = new UserManager(getServletContext());

        // Check if username already exists
        if (userManager.getUserByUsername(username) != null) {
            request.setAttribute("errorMessage", "Username already exists");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }

        try {
            // Create new user
            RegularUser newUser = new RegularUser();
            newUser.setUsername(username);
            newUser.setPassword(password);
            newUser.setEmail(email);
            newUser.setFullName(fullName);

            // Add user
            boolean success = userManager.addUser(newUser);

            if (success) {
                // Set success message and redirect to login page
                System.out.println("RegisterServlet: Successfully registered user: " + username);
                request.getSession().setAttribute("successMessage", "Registration successful! Please login.");
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                // Set error message and go back to registration page
                System.out.println("RegisterServlet: Failed to register user: " + username);
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Log any exceptions
            System.err.println("RegisterServlet: Exception occurred during registration:");
            e.printStackTrace();

            request.setAttribute("errorMessage", "An error occurred during registration: " + e.getMessage());
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
        }
    }
}