package com.movierental.servlet.recommendation;

import java.io.IOException;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;
import com.movierental.model.recommendation.GeneralRecommendation;
import com.movierental.model.recommendation.PersonalRecommendation;
import com.movierental.model.recommendation.Recommendation;
import com.movierental.model.recommendation.RecommendationManager;
import com.movierental.model.user.User;
import com.movierental.model.user.UserManager;

/**
 * Servlet for admin management of recommendations
 */
@WebServlet("/manage-recommendations")
public class ManageRecommendationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display recommendation management UI
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

        // Get action parameter
        String action = request.getParameter("action");

        // Create managers with ServletContext
        RecommendationManager recommendationManager = new RecommendationManager(getServletContext());
        MovieManager movieManager = new MovieManager(getServletContext());
        UserManager userManager = new UserManager(getServletContext());

        // Handle actions
        if ("edit".equals(action)) {
            // Edit form for a specific recommendation
            String recId = request.getParameter("id");
            if (recId != null && !recId.isEmpty()) {
                Recommendation recommendation = recommendationManager.getRecommendationById(recId);
                if (recommendation != null) {
                    // Get the associated movie
                    Movie movie = movieManager.getMovieById(recommendation.getMovieId());

                    // Set attributes for the JSP
                    request.setAttribute("recommendation", recommendation);
                    request.setAttribute("movie", movie);
                    request.setAttribute("allMovies", movieManager.getAllMovies());

                    if (recommendation.isPersonalized()) {
                        // Get all users for dropdown if needed
                        request.setAttribute("allUsers", userManager.getAllUsers());
                    }

                    // Forward to edit page
                    request.getRequestDispatcher("/recommendation/edit-recommendation.jsp").forward(request, response);
                    return;
                }
            }
            // If we get here, the recommendation wasn't found
            session.setAttribute("errorMessage", "Recommendation not found");
            response.sendRedirect(request.getContextPath() + "/manage-recommendations");

        } else if ("delete".equals(action)) {
            // Delete a recommendation
            String recId = request.getParameter("id");
            if (recId != null && !recId.isEmpty()) {
                boolean deleted = recommendationManager.deleteRecommendation(recId);
                if (deleted) {
                    session.setAttribute("successMessage", "Recommendation deleted successfully");
                } else {
                    session.setAttribute("errorMessage", "Failed to delete recommendation");
                }
            }
            response.sendRedirect(request.getContextPath() + "/manage-recommendations");

        } else if ("add".equals(action)) {
            // Show form to add a new recommendation
            String type = request.getParameter("type");
            if (type == null) {
                type = "general"; // Default to general recommendation
            }

            // Set attributes for the JSP
            request.setAttribute("recommendationType", type);
            request.setAttribute("allMovies", movieManager.getAllMovies());

            if ("personal".equals(type)) {
                // For personal recommendations, we need user list
                request.setAttribute("allUsers", userManager.getAllUsers());
            }

            // Forward to add page
            request.getRequestDispatcher("/recommendation/add-recommendation.jsp").forward(request, response);
            return;

        } else {
            // Default: list all recommendations
            List<Recommendation> allRecommendations = recommendationManager.getAllRecommendations();

            // Get movies for the recommendations
            Map<String, Movie> movieMap = new HashMap<>();
            for (Recommendation rec : allRecommendations) {
                String movieId = rec.getMovieId();
                if (!movieMap.containsKey(movieId)) {
                    Movie movie = movieManager.getMovieById(movieId);
                    if (movie != null) {
                        movieMap.put(movieId, movie);
                    }
                }
            }

            // Set attributes for the JSP
            request.setAttribute("recommendations", allRecommendations);
            request.setAttribute("movieMap", movieMap);
            request.setAttribute("allUsers", userManager.getAllUsers());

            // Forward to the management page
            request.getRequestDispatcher("/recommendation/manage-recommendations.jsp").forward(request, response);
        }
    }

    /**
     * Handles POST requests - process recommendation form submissions
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get form parameters
        String action = request.getParameter("action");
        String recType = request.getParameter("recType");
        String recId = request.getParameter("recId");
        String movieId = request.getParameter("movieId");
        String userId = request.getParameter("userId");
        String reason = request.getParameter("reason");
        String scoreStr = request.getParameter("score");

        // Create RecommendationManager
        RecommendationManager recommendationManager = new RecommendationManager(getServletContext());

        // Validate required fields
        if (recType == null || movieId == null || reason == null || scoreStr == null ||
                recType.trim().isEmpty() || movieId.trim().isEmpty() ||
                reason.trim().isEmpty() || scoreStr.trim().isEmpty()) {

            session.setAttribute("errorMessage", "All required fields must be filled");
            if ("update".equals(action) && recId != null) {
                response.sendRedirect(request.getContextPath() + "/manage-recommendations?action=edit&id=" + recId);
            } else {
                response.sendRedirect(request.getContextPath() + "/manage-recommendations?action=add&type=" + recType);
            }
            return;
        }

        try {
            // Parse score
            double score = Double.parseDouble(scoreStr);

            // Process based on action
            if ("update".equals(action)) {
                // Update existing recommendation
                Recommendation existingRec = recommendationManager.getRecommendationById(recId);

                if (existingRec != null) {
                    // Update common fields
                    existingRec.setMovieId(movieId);
                    existingRec.setReason(reason);
                    existingRec.setScore(score);

                    if (existingRec.isPersonalized()) {
                        // Update personal recommendation fields
                        PersonalRecommendation personalRec = (PersonalRecommendation) existingRec;
                        personalRec.setUserId(userId);

                        // Get additional fields specific to personal recommendations
                        String baseSource = request.getParameter("baseSource");
                        String relevanceScoreStr = request.getParameter("relevanceScore");

                        if (baseSource != null && !baseSource.trim().isEmpty()) {
                            personalRec.setBaseSource(baseSource);
                        }

                        if (relevanceScoreStr != null && !relevanceScoreStr.trim().isEmpty()) {
                            try {
                                double relevanceScore = Double.parseDouble(relevanceScoreStr);
                                personalRec.setRelevanceScore(relevanceScore);
                            } catch (NumberFormatException e) {
                                // Use default or existing value
                            }
                        }

                        // Update the recommendation
                        boolean updated = recommendationManager.updateRecommendation(personalRec);

                        if (updated) {
                            session.setAttribute("successMessage", "Personal recommendation updated successfully");
                        } else {
                            session.setAttribute("errorMessage", "Failed to update personal recommendation");
                        }

                    } else {
                        // Update general recommendation fields
                        GeneralRecommendation generalRec = (GeneralRecommendation) existingRec;

                        // Get additional fields specific to general recommendations
                        String category = request.getParameter("category");
                        String rankStr = request.getParameter("rank");

                        if (category != null && !category.trim().isEmpty()) {
                            generalRec.setCategory(category);
                        }

                        if (rankStr != null && !rankStr.trim().isEmpty()) {
                            try {
                                int rank = Integer.parseInt(rankStr);
                                generalRec.setRank(rank);
                            } catch (NumberFormatException e) {
                                // Use default or existing value
                            }
                        }

                        // Update the recommendation
                        boolean updated = recommendationManager.updateRecommendation(generalRec);

                        if (updated) {
                            session.setAttribute("successMessage", "General recommendation updated successfully");
                        } else {
                            session.setAttribute("errorMessage", "Failed to update general recommendation");
                        }
                    }
                } else {
                    session.setAttribute("errorMessage", "Recommendation not found");
                }

            } else {
                // Add new recommendation
                if ("personal".equals(recType)) {
                    // Create new personal recommendation
                    PersonalRecommendation newRec = new PersonalRecommendation();
                    newRec.setRecommendationId(UUID.randomUUID().toString());
                    newRec.setMovieId(movieId);
                    newRec.setUserId(userId);
                    newRec.setReason(reason);
                    newRec.setScore(score);
                    newRec.setGeneratedDate(new Date());

                    // Get additional fields
                    String baseSource = request.getParameter("baseSource");
                    String relevanceScoreStr = request.getParameter("relevanceScore");

                    if (baseSource != null && !baseSource.trim().isEmpty()) {
                        newRec.setBaseSource(baseSource);
                    } else {
                        newRec.setBaseSource("manual");
                    }

                    if (relevanceScoreStr != null && !relevanceScoreStr.trim().isEmpty()) {
                        try {
                            double relevanceScore = Double.parseDouble(relevanceScoreStr);
                            newRec.setRelevanceScore(relevanceScore);
                        } catch (NumberFormatException e) {
                            newRec.setRelevanceScore(0.7); // Default value
                        }
                    } else {
                        newRec.setRelevanceScore(0.7); // Default value
                    }

                    // Add the recommendation
                    boolean added = recommendationManager.addRecommendation(newRec);

                    if (added) {
                        session.setAttribute("successMessage", "Personal recommendation added successfully");
                    } else {
                        session.setAttribute("errorMessage", "Failed to add personal recommendation");
                    }

                } else {
                    // Create new general recommendation
                    GeneralRecommendation newRec = new GeneralRecommendation();
                    newRec.setRecommendationId(UUID.randomUUID().toString());
                    newRec.setMovieId(movieId);
                    newRec.setReason(reason);
                    newRec.setScore(score);
                    newRec.setGeneratedDate(new Date());

                    // Get additional fields
                    String category = request.getParameter("category");
                    String rankStr = request.getParameter("rank");

                    if (category != null && !category.trim().isEmpty()) {
                        newRec.setCategory(category);
                    } else {
                        newRec.setCategory("manual");
                    }

                    if (rankStr != null && !rankStr.trim().isEmpty()) {
                        try {
                            int rank = Integer.parseInt(rankStr);
                            newRec.setRank(rank);
                        } catch (NumberFormatException e) {
                            newRec.setRank(99); // Default value
                        }
                    } else {
                        newRec.setRank(99); // Default value
                    }

                    // Add the recommendation
                    boolean added = recommendationManager.addRecommendation(newRec);

                    if (added) {
                        session.setAttribute("successMessage", "General recommendation added successfully");
                    } else {
                        session.setAttribute("errorMessage", "Failed to add general recommendation");
                    }
                }
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid numeric value");
        }

        // Redirect back to recommendation management
        response.sendRedirect(request.getContextPath() + "/manage-recommendations");
    }
}