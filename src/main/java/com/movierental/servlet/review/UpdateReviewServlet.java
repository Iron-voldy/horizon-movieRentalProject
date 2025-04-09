package com.movierental.servlet.review;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;
import com.movierental.model.review.Review;
import com.movierental.model.review.ReviewManager;

/**
 * Servlet for handling review updates
 */
@WebServlet("/update-review")
public class UpdateReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the edit review form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        String userId = (session != null) ? (String) session.getAttribute("userId") : null;

        // Guest reviews cannot be edited
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String reviewId = request.getParameter("reviewId");

        if (reviewId == null || reviewId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user-reviews");
            return;
        }

        // Get review details
        ReviewManager reviewManager = new ReviewManager(getServletContext());
        Review review = reviewManager.getReviewById(reviewId);

        if (review == null) {
            request.getSession().setAttribute("errorMessage", "Review not found");
            response.sendRedirect(request.getContextPath() + "/user-reviews");
            return;
        }

        // Check if the review belongs to the user
        if (!userId.equals(review.getUserId())) {
            request.getSession().setAttribute("errorMessage", "You do not have permission to edit this review");
            response.sendRedirect(request.getContextPath() + "/user-reviews");
            return;
        }

        // Get movie details
        MovieManager movieManager = new MovieManager(getServletContext());
        Movie movie = movieManager.getMovieById(review.getMovieId());

        if (movie == null) {
            request.getSession().setAttribute("errorMessage", "Movie not found");
            response.sendRedirect(request.getContextPath() + "/user-reviews");
            return;
        }

        // Set attributes for the JSP
        request.setAttribute("review", review);
        request.setAttribute("movie", movie);

        // Check if we should show delete confirmation dialog
        String showDeleteConfirm = request.getParameter("showDeleteConfirm");
        if ("true".equals(showDeleteConfirm)) {
            request.setAttribute("showDeleteConfirm", true);
        }

        // Forward to the edit review page
        request.getRequestDispatcher("/review/edit-review.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the review update
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        String userId = (session != null) ? (String) session.getAttribute("userId") : null;

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String reviewId = request.getParameter("reviewId");
        String rating = request.getParameter("rating");
        String comment = request.getParameter("comment");
        String movieId = request.getParameter("movieId");

        // Validate required inputs
        if (reviewId == null || rating == null || comment == null || movieId == null ||
                reviewId.trim().isEmpty() || rating.trim().isEmpty() || movieId.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required");
            doGet(request, response);
            return;
        }

        try {
            int ratingValue = Integer.parseInt(rating);

            // Check if rating is valid (1-5)
            if (ratingValue < 1 || ratingValue > 5) {
                request.setAttribute("errorMessage", "Rating must be between 1 and 5");
                doGet(request, response);
                return;
            }

            // Get review manager
            ReviewManager reviewManager = new ReviewManager(getServletContext());

            // Check if review exists and belongs to the user
            Review existingReview = reviewManager.getReviewById(reviewId);

            if (existingReview == null) {
                request.getSession().setAttribute("errorMessage", "Review not found");
                response.sendRedirect(request.getContextPath() + "/user-reviews");
                return;
            }

            if (!userId.equals(existingReview.getUserId())) {
                request.getSession().setAttribute("errorMessage", "You do not have permission to edit this review");
                response.sendRedirect(request.getContextPath() + "/user-reviews");
                return;
            }

            // Update the review
            boolean success = reviewManager.updateReview(reviewId, userId, comment, ratingValue);

            if (success) {
                request.getSession().setAttribute("successMessage", "Review updated successfully");
                response.sendRedirect(request.getContextPath() + "/movie-reviews?movieId=" + movieId);
            } else {
                request.setAttribute("errorMessage", "Failed to update review");
                doGet(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid rating format");
            doGet(request, response);
        }
    }
}