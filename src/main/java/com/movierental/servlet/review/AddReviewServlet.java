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
import com.movierental.model.rental.RentalManager;
import com.movierental.model.review.GuestReview;
import com.movierental.model.review.Review;
import com.movierental.model.review.ReviewManager;
import com.movierental.model.review.VerifiedReview;
import com.movierental.model.rental.Transaction;

/**
 * Servlet for handling adding new reviews
 */
@WebServlet("/add-review")
public class AddReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the add review form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get movieId from request
        String movieId = request.getParameter("movieId");
        if (movieId == null || movieId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Get movie details
        MovieManager movieManager = new MovieManager(getServletContext());
        Movie movie = movieManager.getMovieById(movieId);

        if (movie == null) {
            request.getSession().setAttribute("errorMessage", "Movie not found");
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        String userId = (session != null) ? (String) session.getAttribute("userId") : null;

        // Check if user has already reviewed this movie
        ReviewManager reviewManager = new ReviewManager(getServletContext());
        boolean userHasReviewed = false;

        if (userId != null) {
            userHasReviewed = reviewManager.hasUserReviewedMovie(userId, movieId);

            if (userHasReviewed) {
                // User has already reviewed this movie, redirect to edit page
                Review review = reviewManager.getUserReviewForMovie(userId, movieId);
                if (review != null) {
                    response.sendRedirect(request.getContextPath() + "/update-review?reviewId=" + review.getReviewId());
                    return;
                }
            }

            // Check if user has rented this movie (for verified review)
            RentalManager rentalManager = new RentalManager(getServletContext());
            boolean hasRented = rentalManager.hasUserRentedMovie(userId, movieId);
            request.setAttribute("hasRented", hasRented);
        }

        // Set movie in request attributes
        request.setAttribute("movie", movie);

        // Forward to the add review page
        request.getRequestDispatcher("/review/add-review.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the review submission
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get parameters from form
        String movieId = request.getParameter("movieId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        // Check for required fields
        if (movieId == null || ratingStr == null || comment == null ||
                movieId.trim().isEmpty() || ratingStr.trim().isEmpty() || comment.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required");
            doGet(request, response);
            return;
        }

        try {
            int rating = Integer.parseInt(ratingStr);

            // Validate rating (1-5)
            if (rating < 1 || rating > 5) {
                request.setAttribute("errorMessage", "Rating must be between 1 and 5");
                doGet(request, response);
                return;
            }

            // Get movie details for redirect
            MovieManager movieManager = new MovieManager(getServletContext());
            Movie movie = movieManager.getMovieById(movieId);

            if (movie == null) {
                request.getSession().setAttribute("errorMessage", "Movie not found");
                response.sendRedirect(request.getContextPath() + "/search-movie");
                return;
            }

            // Check if user is logged in
            HttpSession session = request.getSession(false);
            String userId = (session != null) ? (String) session.getAttribute("userId") : null;

            ReviewManager reviewManager = new ReviewManager(getServletContext());
            Review review = null;

            if (userId != null) {
                // Check if user has already reviewed this movie
                if (reviewManager.hasUserReviewedMovie(userId, movieId)) {
                    request.getSession().setAttribute("errorMessage", "You have already reviewed this movie");
                    response.sendRedirect(request.getContextPath() + "/movie-reviews?movieId=" + movieId);
                    return;
                }

                // Get user's name from session
                String userName = (String) session.getAttribute("username");

                // Check if this is a verified review (user has rented the movie)
                RentalManager rentalManager = new RentalManager(getServletContext());
                boolean hasRented = rentalManager.hasUserRentedMovie(userId, movieId);

                if (hasRented) {
                    // Get the transaction ID for the rental
                    String transactionId = null;
                    for (Transaction transaction : rentalManager.getRentalHistoryForMovie(movieId)) {
                        if (transaction.getUserId().equals(userId) && transaction.isReturned()) {
                            transactionId = transaction.getTransactionId();
                            break;
                        }
                    }

                    if (transactionId != null) {
                        // Add verified review
                        review = reviewManager.addVerifiedReview(userId, userName, movieId, transactionId, comment, rating);
                    } else {
                        // Fall back to regular review if transaction couldn't be found
                        review = reviewManager.addRegularReview(userId, userName, movieId, comment, rating);
                    }
                } else {
                    // Add regular review
                    review = reviewManager.addRegularReview(userId, userName, movieId, comment, rating);
                }
            } else {
                // Guest review
                String guestName = request.getParameter("guestName");
                String email = request.getParameter("email");

                if (guestName == null || guestName.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Name is required for guest reviews");
                    doGet(request, response);
                    return;
                }

                // Get client IP address
                String ipAddress = request.getRemoteAddr();

                // Add guest review
                review = reviewManager.addGuestReview(guestName, movieId, comment, rating, email, ipAddress);
            }

            if (review != null) {
                request.getSession().setAttribute("successMessage", "Your review has been submitted successfully");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to submit review. Please try again.");
            }

            // Redirect to movie reviews page
            response.sendRedirect(request.getContextPath() + "/movie-reviews?movieId=" + movieId);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid rating format");
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            doGet(request, response);
        }
    }
}