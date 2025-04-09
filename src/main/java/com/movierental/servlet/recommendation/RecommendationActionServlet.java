package com.movierental.servlet.recommendation;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movierental.model.recommendation.RecommendationManager;
import com.movierental.model.user.User;

/**
 * Servlet for handling quick recommendation actions like generate and clear
 */
@WebServlet("/recommendation-action")
public class RecommendationActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - performs various recommendation actions
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from user object
        String userId = user.getUserId();

        // Get action parameter
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/view-recommendations");
            return;
        }

        // Create RecommendationManager with ServletContext
        RecommendationManager recommendationManager = new RecommendationManager(getServletContext());

        // Handle different actions
        switch(action) {
            case "generate-personal":
                // Generate personal recommendations
                recommendationManager.generatePersonalRecommendations(userId);
                session.setAttribute("successMessage", "Personal recommendations generated successfully");
                response.sendRedirect(request.getContextPath() + "/view-recommendations?type=personal");
                break;

            case "generate-general":
                // Generate general recommendations
                recommendationManager.generateGeneralRecommendations();
                session.setAttribute("successMessage", "General recommendations generated successfully");
                response.sendRedirect(request.getContextPath() + "/view-recommendations?type=general");
                break;

            case "clear-personal":
                // Clear personal recommendations
                recommendationManager.deleteUserRecommendations(userId);
                session.setAttribute("successMessage", "Personal recommendations have been cleared");
                response.sendRedirect(request.getContextPath() + "/view-recommendations?type=personal");
                break;

            case "generate-top-rated":
                // Generate/refresh top rated recommendations
                recommendationManager.generateGeneralRecommendations();
                session.setAttribute("successMessage", "Top rated recommendations refreshed");
                response.sendRedirect(request.getContextPath() + "/top-rated");
                break;

            case "generate-genre":
                // Generate/refresh genre recommendations
                String genre = request.getParameter("genre");
                recommendationManager.generateGeneralRecommendations();
                session.setAttribute("successMessage", "Genre recommendations refreshed");

                if (genre != null && !genre.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/genre-recommendations?genre=" + genre);
                } else {
                    response.sendRedirect(request.getContextPath() + "/view-recommendations?type=general");
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/view-recommendations");
                break;
        }
    }

    /**
     * Handles POST requests - redirects to doGet
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}