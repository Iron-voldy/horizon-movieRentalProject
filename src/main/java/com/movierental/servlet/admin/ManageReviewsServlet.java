package com.movierental.servlet.admin;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movierental.model.admin.Admin;
import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;
import com.movierental.model.review.Review;
import com.movierental.model.review.ReviewManager;
import com.movierental.model.user.User;
import com.movierental.model.user.UserManager;

/**
 * Servlet for handling review management (admin)
 */
@WebServlet("/admin/reviews")
public class ManageReviewsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display review list or form
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

        // Get action and id from request
        String action = request.getParameter("action");
        String reviewId = request.getParameter("id");

        // Create managers
        ReviewManager reviewManager = new ReviewManager(getServletContext());
        MovieManager movieManager = new MovieManager(getServletContext());
        UserManager userManager = new UserManager(getServletContext());

        if ("moderate".equals(action) && reviewId != null) {
            // Display review moderation form
            Review review = reviewManager.getReviewById(reviewId);

            if (review == null) {
                session.setAttribute("errorMessage", "Review not found");
                response.sendRedirect(request.getContextPath() + "/admin/reviews");
                return;
            }

            // Get movie details
            Movie movie = movieManager.getMovieById(review.getMovieId());

            // Get user details (if available)
            User user = null;
            if (review.getUserId() != null) {
                user = userManager.getUserById(review.getUserId());
            }

            request.setAttribute("review", review);
            request.setAttribute("movie", movie);
            request.setAttribute("user", user);

            request.getRequestDispatcher("/admin/reviews/moderate.jsp").forward(request, response);
            return;
        } else if ("delete".equals(action) && reviewId != null) {
            // Delete review
            Review review = reviewManager.getReviewById(reviewId);

            if (review == null) {
                session.setAttribute("errorMessage", "Review not found");
                response.sendRedirect(request.getContextPath() + "/admin/reviews");
                return;
            }

            // Store movie ID for recalculating rating after deletion
            String movieId = review.getMovieId();

            // Delete the review (pass null for userId to override user permission check)
            boolean deleted = reviewManager.deleteReview(reviewId, null);

            if (deleted) {
                session.setAttribute("successMessage", "Review deleted successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to delete review");
            }

            response.sendRedirect(request.getContextPath() + "/admin/reviews");
            return;
        }

        // Default action: display review list
        List<Review> reviews = reviewManager.getAllReviews();

        // Create maps for movie and user info
        Map<String, Movie> movieMap = new HashMap<>();
        Map<String, User> userMap = new HashMap<>();

        for (Review review : reviews) {
            // Get movie info
            String movieId = review.getMovieId();
            if (!movieMap.containsKey(movieId)) {
                Movie movie = movieManager.getMovieById(movieId);
                if (movie != null) {
                    movieMap.put(movieId, movie);
                }
            }

            // Get user info (if available)
            String userId = review.getUserId();
            if (userId != null && !userMap.containsKey(userId)) {
                User user = userManager.getUserById(userId);
                if (user != null) {
                    userMap.put(userId, user);
                }
            }
        }

        request.setAttribute("reviews", reviews);
        request.setAttribute("movieMap", movieMap);
        request.setAttribute("userMap", userMap);

        request.getRequestDispatcher("/admin/reviews/list.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process review update
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

        // Get parameters
        String action = request.getParameter("action");
        String reviewId = request.getParameter("reviewId");

        if ("update".equals(action) && reviewId != null) {
            // Process review update
            String comment = request.getParameter("comment");
            String ratingStr = request.getParameter("rating");

            if (comment == null || ratingStr == null ||
                    comment.trim().isEmpty() || ratingStr.trim().isEmpty()) {

                session.setAttribute("errorMessage", "Comment and rating are required");
                response.sendRedirect(request.getContextPath() + "/admin/reviews?action=moderate&id=" + reviewId);
                return;
            }

            try {
                int rating = Integer.parseInt(ratingStr);

                // Validate rating (1-5)
                if (rating < 1 || rating > 5) {
                    session.setAttribute("errorMessage", "Rating must be between 1 and 5");
                    response.sendRedirect(request.getContextPath() + "/admin/reviews?action=moderate&id=" + reviewId);
                    return;
                }

                // Create ReviewManager
                ReviewManager reviewManager = new ReviewManager(getServletContext());

                // Get the review
                Review review = reviewManager.getReviewById(reviewId);

                if (review == null) {
                    session.setAttribute("errorMessage", "Review not found");
                    response.sendRedirect(request.getContextPath() + "/admin/reviews");
                    return;
                }

                // Update the review (pass null for userId to override user permission check)
                boolean success = reviewManager.updateReview(reviewId, null, comment, rating);

                if (success) {
                    session.setAttribute("successMessage", "Review updated successfully");
                    response.sendRedirect(request.getContextPath() + "/admin/reviews");
                } else {
                    session.setAttribute("errorMessage", "Failed to update review");
                    response.sendRedirect(request.getContextPath() + "/admin/reviews?action=moderate&id=" + reviewId);
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid rating format");
                response.sendRedirect(request.getContextPath() + "/admin/reviews?action=moderate&id=" + reviewId);
            }
        } else {
            // Unknown action
            session.setAttribute("errorMessage", "Unknown action");
            response.sendRedirect(request.getContextPath() + "/admin/reviews");
        }
    }
}