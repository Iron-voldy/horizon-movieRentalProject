package com.movierental.servlet.user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movierental.model.user.PremiumUser;
import com.movierental.model.user.RegularUser;
import com.movierental.model.user.User;
import com.movierental.model.user.UserManager;

/**
 * Servlet for handling user profile updates
 */
@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the update profile form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Not logged in, redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from session
        String userId = (String) session.getAttribute("userId");

        // Create UserManager and get user
        UserManager userManager = new UserManager(getServletContext());
        User user = userManager.getUserById(userId);

        if (user == null) {
            // User not found (should not happen normally)
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Add user to request attributes
        request.setAttribute("user", user);

        // Forward to update profile page
        request.getRequestDispatcher("/user/update-profile.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the update profile form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Not logged in, redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from session
        String userId = (String) session.getAttribute("userId");

        // Create UserManager and get user
        UserManager userManager = new UserManager(getServletContext());
        User user = userManager.getUserById(userId);

        if (user == null) {
            // User not found (should not happen normally)
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get form parameters
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String upgradeAccount = request.getParameter("upgradeAccount");

        // Check if current password is correct if they want to change password
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (currentPassword == null || !user.authenticate(currentPassword)) {
                request.setAttribute("errorMessage", "Current password is incorrect");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/user/update-profile.jsp").forward(request, response);
                return;
            }

            // Check if new passwords match
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "New passwords do not match");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/user/update-profile.jsp").forward(request, response);
                return;
            }

            // Update password
            user.setPassword(newPassword);
        }

        // Update email and full name if provided
        if (email != null && !email.trim().isEmpty()) {
            user.setEmail(email);
        }

        if (fullName != null && !fullName.trim().isEmpty()) {
            user.setFullName(fullName);
        }

        // Handle account upgrade if requested
        if ("yes".equals(upgradeAccount) && user instanceof RegularUser) {
            userManager.upgradeToPremium(userId);
            // Get the newly upgraded user
            user = userManager.getUserById(userId);
        } else {
            // Just update the existing user
            userManager.updateUser(user);
        }

        // Update session with new user data
        session.setAttribute("user", user);

        // Set success message
        request.setAttribute("successMessage", "Profile updated successfully!");
        request.setAttribute("user", user);

        // Forward back to update profile page
        request.getRequestDispatcher("/user/update-profile.jsp").forward(request, response);
    }
}