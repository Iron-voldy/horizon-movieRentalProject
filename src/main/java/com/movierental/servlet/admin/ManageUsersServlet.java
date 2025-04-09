package com.movierental.servlet.admin;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movierental.model.admin.Admin;
import com.movierental.model.user.PremiumUser;
import com.movierental.model.user.RegularUser;
import com.movierental.model.user.User;
import com.movierental.model.user.UserManager;

/**
 * Servlet for handling user management (admin)
 */
@WebServlet("/admin/users")
public class ManageUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display user list or form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;

        if (admin == null) {
            // Not logged in, redirect to login
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Get action from request
        String action = request.getParameter("action");
        String userId = request.getParameter("id");

        UserManager userManager = new UserManager(getServletContext());

        if ("edit".equals(action) && userId != null) {
            // Display edit user form
            User user = userManager.getUserById(userId);

            if (user == null) {
                session.setAttribute("errorMessage", "User not found");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            request.setAttribute("user", user);
            request.setAttribute("isPremium", user instanceof PremiumUser);

            request.getRequestDispatcher("/admin/users/edit.jsp").forward(request, response);
            return;
        } else if ("delete".equals(action) && userId != null) {
            // Delete user
            boolean deleted = userManager.deleteUser(userId);

            if (deleted) {
                session.setAttribute("successMessage", "User deleted successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to delete user");
            }

            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        // Default action: display user list
        List<User> users = userManager.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin/users/list.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process user edit form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;

        if (admin == null) {
            // Not logged in, redirect to login
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Get action from request
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            // Process edit user form
            processEditUser(request, response);
        } else {
            // Unknown action
            session.setAttribute("errorMessage", "Unknown action");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    /**
     * Process edit user form
     */
    private void processEditUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Get form parameters
        String userId = request.getParameter("userId");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String newPassword = request.getParameter("newPassword");
        String accountType = request.getParameter("accountType");
        String premiumExpiryStr = request.getParameter("premiumExpiry");

        // Validate required fields
        if (userId == null || username == null || email == null || fullName == null ||
                userId.trim().isEmpty() || username.trim().isEmpty() ||
                email.trim().isEmpty() || fullName.trim().isEmpty()) {

            session.setAttribute("errorMessage", "All fields are required");
            response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&id=" + userId);
            return;
        }

        // Create UserManager
        UserManager userManager = new UserManager(getServletContext());

        // Get existing user
        User existingUser = userManager.getUserById(userId);

        if (existingUser == null) {
            session.setAttribute("errorMessage", "User not found");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        // Check if the username is changed and already exists
        if (!existingUser.getUsername().equals(username) && userManager.getUserByUsername(username) != null) {
            session.setAttribute("errorMessage", "Username already exists");
            response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&id=" + userId);
            return;
        }

        User updatedUser;

        // Determine user type
        if ("premium".equals(accountType)) {
            // Premium user
            PremiumUser premiumUser;

            if (existingUser instanceof PremiumUser) {
                premiumUser = (PremiumUser) existingUser;
            } else {
                premiumUser = new PremiumUser();
                premiumUser.setUserId(userId);
            }

            // Set basic properties
            premiumUser.setUsername(username);
            premiumUser.setEmail(email);
            premiumUser.setFullName(fullName);

            // Set new password if provided
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                premiumUser.setPassword(newPassword);
            }

            // Set premium expiry date
            if (premiumExpiryStr != null && !premiumExpiryStr.trim().isEmpty()) {
                try {
                    // Parse yyyy-MM-dd format
                    String[] parts = premiumExpiryStr.split("-");
                    int year = Integer.parseInt(parts[0]);
                    int month = Integer.parseInt(parts[1]) - 1; // Month is 0-based
                    int day = Integer.parseInt(parts[2]);

                    Calendar calendar = Calendar.getInstance();
                    calendar.set(year, month, day);
                    premiumUser.setSubscriptionExpiryDate(calendar.getTime());
                } catch (Exception e) {
                    // Use default (1 month from now) if parsing fails
                    Calendar calendar = Calendar.getInstance();
                    calendar.add(Calendar.MONTH, 1);
                    premiumUser.setSubscriptionExpiryDate(calendar.getTime());
                }
            } else {
                // Default to 1 month from now
                Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.MONTH, 1);
                premiumUser.setSubscriptionExpiryDate(calendar.getTime());
            }

            updatedUser = premiumUser;
        } else {
            // Regular user
            RegularUser regularUser;

            if (existingUser instanceof RegularUser) {
                regularUser = (RegularUser) existingUser;
            } else {
                regularUser = new RegularUser();
                regularUser.setUserId(userId);
            }

            // Set basic properties
            regularUser.setUsername(username);
            regularUser.setEmail(email);
            regularUser.setFullName(fullName);

            // Set new password if provided
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                regularUser.setPassword(newPassword);
            }

            updatedUser = regularUser;
        }

        // Update the user
        boolean success = userManager.updateUser(updatedUser);

        if (success) {
            session.setAttribute("successMessage", "User updated successfully: " + updatedUser.getUsername());
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } else {
            session.setAttribute("errorMessage", "Failed to update user");
            response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&id=" + userId);
        }
    }
}