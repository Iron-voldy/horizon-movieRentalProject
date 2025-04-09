package com.movierental.servlet.review;

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

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;
import com.movierental.model.review.Review;
import com.movierental.model.review.ReviewManager;

/**
 * Servlet for viewing a user's reviews
 */
@WebServlet("/user-reviews")
public class UserReviewsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the user's reviews
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

        // Get reviews by the user
        ReviewManager reviewManager = new ReviewManager(getServletContext());
        List<Review> userReviews = reviewManager.getReviewsByUser(userId);

        // Get movies for each review
        MovieManager movieManager = new MovieManager(getServletContext());
        Map<String, Movie> movieMap = new HashMap<>();

        for (Review review : userReviews) {
            String movieId = review.getMovieId();
            if (!movieMap.containsKey(movieId)) {
                Movie movie = movieManager.getMovieById(movieId);
                if (movie != null) {
                    movieMap.put(movieId, movie);
                }
            }
        }

        // Set attributes for the JSP
        request.setAttribute("userReviews", userReviews);
        request.setAttribute("movieMap", movieMap);

        // Forward to the user reviews page
        request.getRequestDispatcher("/review/user-reviews.jsp").forward(request, response);
    }
}