package com.movierental.servlet.review;

import java.io.IOException;
import java.util.List;
import java.util.Map;

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
import com.movierental.model.user.User;

/**
 * Servlet for displaying all reviews for a specific movie
 */
@WebServlet("/movie-reviews")
public class ViewMovieReviewsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

        // Get all reviews for the movie
        ReviewManager reviewManager = new ReviewManager(getServletContext());
        List<Review> reviews = reviewManager.getReviewsByMovie(movieId);

        // Get review statistics
        double averageRating = reviewManager.calculateAverageRating(movieId);
        int verifiedReviewsCount = reviewManager.countVerifiedReviews(movieId);
        int guestReviewsCount = reviewManager.countGuestReviews(movieId);
        Map<Integer, Integer> ratingDistribution = reviewManager.getRatingDistribution(movieId);

        // Check if the current user has already reviewed this movie
        HttpSession session = request.getSession(false);
        String userId = (session != null) ? (String) session.getAttribute("userId") : null;

        boolean hasReviewed = false;
        Review userReview = null;

        if (userId != null) {
            userReview = reviewManager.getUserReviewForMovie(userId, movieId);
            hasReviewed = (userReview != null);
        }

        // Set attributes for the JSP
        request.setAttribute("movie", movie);
        request.setAttribute("reviews", reviews);
        request.setAttribute("averageRating", averageRating);
        request.setAttribute("verifiedReviewsCount", verifiedReviewsCount);
        request.setAttribute("guestReviewsCount", guestReviewsCount);
        request.setAttribute("ratingDistribution", ratingDistribution);
        request.setAttribute("hasReviewed", hasReviewed);
        request.setAttribute("userReview", userReview);

        // Forward to the movie reviews page
        request.getRequestDispatcher("/review/movie-reviews.jsp").forward(request, response);
    }
}