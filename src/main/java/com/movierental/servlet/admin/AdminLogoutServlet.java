package com.movierental.servlet.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet for handling admin logout
 */
@WebServlet("/admin/logout")
public class AdminLogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - log out the admin
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null) {
            String username = (String) session.getAttribute("adminUsername");

            // Invalidate session
            session.invalidate();

            System.out.println("AdminLogoutServlet: Admin logged out: " + username);
        }

        // Create new session for messages
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("successMessage", "You have been successfully logged out");

        // Redirect to login page
        response.sendRedirect(request.getContextPath() + "/admin/login");
    }
}