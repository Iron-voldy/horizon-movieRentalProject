package com.movierental.servlet.watchlist;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;
import com.movierental.model.user.User;
import com.movierental.model.watchlist.Watchlist;
import com.movierental.model.watchlist.WatchlistManager;

@WebServlet("/add-to-watchlist")
public class AddToWatchlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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

        // Get movie ID from request
        String movieId = request.getParameter("movieId");
        System.out.println("Movie ID from request: " + movieId);

        if (movieId == null || movieId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Create MovieManager with ServletContext for proper file path handling
        MovieManager movieManager = new MovieManager(getServletContext());

        // Find the movie
        Movie movie = movieManager.getMovieById(movieId);
        System.out.println("Found movie: " + (movie != null ? movie.getTitle() : "null"));

        if (movie == null) {
            session.setAttribute("errorMessage", "Movie not found");
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Check if movie is already in watchlist
        String userId = user.getUserId();
        WatchlistManager watchlistManager = new WatchlistManager(getServletContext()); // Pass ServletContext here

        if (watchlistManager.isInWatchlist(userId, movieId)) {
            Watchlist existingEntry = watchlistManager.getWatchlistByUserAndMovie(userId, movieId);
            if (existingEntry != null) {
                session.setAttribute("infoMessage", "Movie is already in your watchlist.");
                response.sendRedirect(request.getContextPath() + "/manage-watchlist?id=" + existingEntry.getWatchlistId());
            } else {
                session.setAttribute("infoMessage", "Movie is already in your watchlist.");
                response.sendRedirect(request.getContextPath() + "/view-watchlist");
            }
            return;
        }

        // Set movie as a request attribute
        request.setAttribute("movie", movie);

        // Forward to add to watchlist form
        request.getRequestDispatcher("/watchlist/add-to-watchlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("AddToWatchlistServlet.doPost() called");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from user object
        String userId = user.getUserId();
        System.out.println("User ID: " + userId);

        // Get form parameters
        String movieId = request.getParameter("movieId");
        String priorityStr = request.getParameter("priority");
        String notes = request.getParameter("notes");
        String redirect = request.getParameter("redirect");

        System.out.println("Movie ID from form: " + movieId);
        System.out.println("Priority: " + priorityStr);

        // Validate required fields
        if (movieId == null || movieId.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Movie ID is required");

            // Need to get movie for the form
            MovieManager movieManager = new MovieManager(getServletContext());
            Movie movie = movieManager.getMovieById(movieId);
            request.setAttribute("movie", movie);

            request.getRequestDispatcher("/watchlist/add-to-watchlist.jsp").forward(request, response);
            return;
        }

        try {
            // Default priority to medium (3) if not specified
            int priority = 3;
            if (priorityStr != null && !priorityStr.trim().isEmpty()) {
                priority = Integer.parseInt(priorityStr);
            }
            System.out.println("Parsed priority: " + priority);

            // Add to watchlist - use ServletContext here
            WatchlistManager watchlistManager = new WatchlistManager(getServletContext());
            Watchlist watchlist = watchlistManager.addToWatchlist(userId, movieId, priority, notes);

            if (watchlist != null) {
                // Success
                System.out.println("Movie added to watchlist successfully");
                session.setAttribute("successMessage", "Movie added to your watchlist");

                // Redirect based on redirect parameter
                if (redirect != null && !redirect.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/" + redirect);
                } else {
                    response.sendRedirect(request.getContextPath() + "/view-watchlist");
                }
            } else {
                // Failed
                System.out.println("Failed to add movie to watchlist");
                request.setAttribute("errorMessage", "Failed to add movie to watchlist");

                // Need to get movie for the form
                MovieManager movieManager = new MovieManager(getServletContext());
                Movie movie = movieManager.getMovieById(movieId);
                request.setAttribute("movie", movie);

                request.getRequestDispatcher("/watchlist/add-to-watchlist.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid priority");
            doGet(request, response);
        }
    }
}