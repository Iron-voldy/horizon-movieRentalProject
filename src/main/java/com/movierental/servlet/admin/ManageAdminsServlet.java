package com.movierental.servlet.admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movierental.model.admin.Admin;
import com.movierental.model.admin.AdminManager;

/**
 * Servlet for handling admin user management (super admin only)
 */
@WebServlet("/admin/manage-admins")
public class ManageAdminsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display admin list or form
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

        // Check if super admin
        if (!admin.isSuperAdmin()) {
            session.setAttribute("errorMessage", "Access denied. Super admin privileges required.");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        // Get action from request
        String action = request.getParameter("action");
        String adminId = request.getParameter("id");

        AdminManager adminManager = new AdminManager(getServletContext());

        if ("add".equals(action)) {
            // Display add admin form
            request.getRequestDispatcher("/admin/admins/add.jsp").forward(request, response);
            return;
        } else if ("edit".equals(action) && adminId != null) {
            // Display edit admin form
            Admin adminToEdit = adminManager.getAdminById(adminId);

            if (adminToEdit == null) {
                session.setAttribute("errorMessage", "Admin not found");
                response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
                return;
            }

            request.setAttribute("editAdmin", adminToEdit);
            request.getRequestDispatcher("/admin/admins/edit.jsp").forward(request, response);
            return;
        } else if ("delete".equals(action) && adminId != null) {
            // Delete admin

            // Cannot delete yourself
            if (adminId.equals(admin.getAdminId())) {
                session.setAttribute("errorMessage", "You cannot delete your own account");
                response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
                return;
            }

            boolean deleted = adminManager.deleteAdmin(adminId);

            if (deleted) {
                session.setAttribute("successMessage", "Admin deleted successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to delete admin. Cannot delete the last admin or super admin.");
            }

            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        // Default action: display admin list
        List<Admin> admins = adminManager.getAllAdmins();
        request.setAttribute("admins", admins);
        request.getRequestDispatcher("/admin/admins/list.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process admin add/edit form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        Admin currentAdmin = (session != null) ? (Admin) session.getAttribute("admin") : null;

        if (currentAdmin == null) {
            // Not logged in, redirect to login
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Check if super admin
        if (!currentAdmin.isSuperAdmin()) {
            session.setAttribute("errorMessage", "Access denied. Super admin privileges required.");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        // Get action from request
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            // Process add admin form
            processAddAdmin(request, response);
        } else if ("edit".equals(action)) {
            // Process edit admin form
            processEditAdmin(request, response);
        } else {
            // Unknown action
            session.setAttribute("errorMessage", "Unknown action");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
        }
    }

    /**
     * Process add admin form
     */
    private void processAddAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");

        // Validate required fields
        if (username == null || password == null || confirmPassword == null ||
                email == null || fullName == null ||
                username.trim().isEmpty() || password.trim().isEmpty() ||
                confirmPassword.trim().isEmpty() || email.trim().isEmpty() ||
                fullName.trim().isEmpty()) {

            session.setAttribute("errorMessage", "All fields are required");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins?action=add");
            return;
        }

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            session.setAttribute("errorMessage", "Passwords do not match");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins?action=add");
            return;
        }

        // Create AdminManager
        AdminManager adminManager = new AdminManager(getServletContext());

        // Check if username already exists
        if (adminManager.getAdminByUsername(username) != null) {
            session.setAttribute("errorMessage", "Username already exists");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins?action=add");
            return;
        }

        // Create new admin
        Admin newAdmin = new Admin();
        newAdmin.setUsername(username);
        newAdmin.setPassword(password);
        newAdmin.setEmail(email);
        newAdmin.setFullName(fullName);
        newAdmin.setRole("SUPER_ADMIN".equals(role) ? "SUPER_ADMIN" : "ADMIN");

        // Add admin
        boolean success = adminManager.addAdmin(newAdmin);

        if (success) {
            session.setAttribute("successMessage", "Admin added successfully: " + newAdmin.getUsername());
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
        } else {
            session.setAttribute("errorMessage", "Failed to add admin");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins?action=add");
        }
    }

    /**
     * Process edit admin form
     */
    private void processEditAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Get form parameters
        String adminId = request.getParameter("adminId");
        String username = request.getParameter("username");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");

        // Validate required fields
        if (adminId == null || username == null || email == null || fullName == null ||
                adminId.trim().isEmpty() || username.trim().isEmpty() ||
                email.trim().isEmpty() || fullName.trim().isEmpty()) {

            session.setAttribute("errorMessage", "All fields are required");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins?action=edit&id=" + adminId);
            return;
        }

        // Check if passwords match (if provided)
        if (newPassword != null && !newPassword.trim().isEmpty() &&
                !newPassword.equals(confirmPassword)) {

            session.setAttribute("errorMessage", "Passwords do not match");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins?action=edit&id=" + adminId);
            return;
        }

        // Create AdminManager
        AdminManager adminManager = new AdminManager(getServletContext());

        // Get existing admin
        Admin existingAdmin = adminManager.getAdminById(adminId);

        if (existingAdmin == null) {
            session.setAttribute("errorMessage", "Admin not found");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
            return;
        }

        // Check if username is changed and already exists
        if (!existingAdmin.getUsername().equals(username) &&
                adminManager.getAdminByUsername(username) != null) {

            session.setAttribute("errorMessage", "Username already exists");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins?action=edit&id=" + adminId);
            return;
        }

        // Get current admin
        Admin currentAdmin = (Admin) session.getAttribute("admin");

        // Check if trying to change own role from SUPER_ADMIN
        if (adminId.equals(currentAdmin.getAdminId()) &&
                currentAdmin.isSuperAdmin() && !"SUPER_ADMIN".equals(role)) {

            session.setAttribute("errorMessage", "You cannot demote yourself from Super Admin");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins?action=edit&id=" + adminId);
            return;
        }

        // Update admin
        existingAdmin.setUsername(username);
        existingAdmin.setEmail(email);
        existingAdmin.setFullName(fullName);
        existingAdmin.setRole("SUPER_ADMIN".equals(role) ? "SUPER_ADMIN" : "ADMIN");

        // Update password if provided
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            existingAdmin.setPassword(newPassword);
        }

        // Save changes
        boolean success = adminManager.updateAdmin(existingAdmin);

        if (success) {
            session.setAttribute("successMessage", "Admin updated successfully: " + existingAdmin.getUsername());

            // If self-update, update the session with new admin details
            if (adminId.equals(currentAdmin.getAdminId())) {
                session.setAttribute("admin", existingAdmin);
                session.setAttribute("adminUsername", existingAdmin.getUsername());
                session.setAttribute("adminRole", existingAdmin.getRole());
            }

            response.sendRedirect(request.getContextPath() + "/admin/manage-admins");
        } else {
            session.setAttribute("errorMessage", "Failed to update admin");
            response.sendRedirect(request.getContextPath() + "/admin/manage-admins?action=edit&id=" + adminId);
        }
    }
}