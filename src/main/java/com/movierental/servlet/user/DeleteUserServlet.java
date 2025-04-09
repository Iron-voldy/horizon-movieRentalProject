package com.movierental.servlet.user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movierental.model.user.UserManager;

/**
 * Servlet for handling user account deletion
 */
@WebServlet("/delete-account")
public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the delete account confirmation
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

        // Forward to the delete confirmation page
        // Note: You would need to create a delete-account.jsp page for this
        request.getRequestDispatcher("/user/delete-account.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the account deletion
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

        // Get confirmation parameter
        String confirmDelete = request.getParameter("confirmDelete");

        if (!"yes".equals(confirmDelete)) {
            // User did not confirm deletion
            response.sendRedirect(request.getContextPath() + "/update-profile");
            return;
        }

        // Create UserManager and delete user
        UserManager userManager = new UserManager();
        boolean deleted = userManager.deleteUser(userId);

        if (deleted) {
            // Invalidate session
            session.invalidate();

            // Create a new session to display success message
            session = request.getSession(true);
            session.setAttribute("successMessage", "Your account has been successfully deleted.");

            // Redirect to home page
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else {
            // Deletion failed
            request.setAttribute("errorMessage", "Failed to delete account. Please try again.");
            request.getRequestDispatcher("/user/delete-account.jsp").forward(request, response);
        }
    }
}