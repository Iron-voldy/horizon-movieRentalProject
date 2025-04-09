package com.movierental.servlet.review;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movierental.model.review.Review;
import com.movierental.model.review.ReviewManager;

/**
 * Servlet for handling review deletion
 */
@WebServlet("/delete-review")
public class DeleteReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - confirm review deletion
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        String userId = (session != null) ? (String) session.getAttribute("userId") : null;

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String reviewId = request.getParameter("reviewId");
        String confirm = request.getParameter("confirm");

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
            request.getSession().setAttribute("errorMessage", "You do not have permission to delete this review");
            response.sendRedirect(request.getContextPath() + "/user-reviews");
            return;
        }

        // If confirmation is provided, delete the review
        if ("yes".equals(confirm)) {
            String movieId = review.getMovieId();
            boolean deleted = reviewManager.deleteReview(reviewId, userId);

            if (deleted) {
                request.getSession().setAttribute("successMessage", "Review deleted successfully");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to delete review");
            }

            // Redirect based on where the request came from
            String referer = request.getHeader("Referer");
            if (referer != null && referer.contains("movie-reviews")) {
                response.sendRedirect(request.getContextPath() + "/movie-reviews?movieId=" + movieId);
            } else {
                response.sendRedirect(request.getContextPath() + "/user-reviews");
            }

            return;
        }

        // Set attributes for the confirmation page
        request.setAttribute("review", review);

        // Forward to the confirmation page - will use JavaScript confirmation in the edit-review.jsp page instead
        response.sendRedirect(request.getContextPath() + "/update-review?reviewId=" + reviewId + "&showDeleteConfirm=true");
    }

    /**
     * Handles POST requests - process review deletion
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
        String confirmDelete = request.getParameter("confirmDelete");

        if (reviewId == null || reviewId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user-reviews");
            return;
        }

        if (!"yes".equals(confirmDelete)) {
            // User didn't confirm deletion
            response.sendRedirect(request.getContextPath() + "/update-review?reviewId=" + reviewId);
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

        // Store the movie ID before deleting
        String movieId = review.getMovieId();

        // Delete the review
        boolean deleted = reviewManager.deleteReview(reviewId, userId);

        if (deleted) {
            request.getSession().setAttribute("successMessage", "Review deleted successfully");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to delete review");
        }

        // Redirect based on the provided redirect parameter
        String redirectTo = request.getParameter("redirectTo");
        if ("movie".equals(redirectTo)) {
            response.sendRedirect(request.getContextPath() + "/movie-reviews?movieId=" + movieId);
        } else {
            response.sendRedirect(request.getContextPath() + "/user-reviews");
        }
    }
}