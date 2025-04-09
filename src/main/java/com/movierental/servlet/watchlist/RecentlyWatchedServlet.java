package com.movierental.servlet.watchlist;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;
import com.movierental.model.user.User;
import com.movierental.model.watchlist.RecentlyWatched;
import com.movierental.model.watchlist.WatchlistManager;

@WebServlet("/recently-watched")
public class RecentlyWatchedServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Debug logging
        System.out.println("RecentlyWatchedServlet: doGet method called");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            System.out.println("User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID
        String userId = user.getUserId();
        System.out.println("User ID: " + userId);

        // Handle clear action
        String action = request.getParameter("action");
        if ("clear".equals(action)) {
            WatchlistManager watchlistManager = new WatchlistManager(getServletContext());
            watchlistManager.clearRecentlyWatched(userId);
            session.setAttribute("successMessage", "Recently watched list cleared");
            response.sendRedirect(request.getContextPath() + "/recently-watched");
            return;
        }

        // Get recently watched movies
        WatchlistManager watchlistManager = new WatchlistManager(getServletContext());
        RecentlyWatched recentlyWatched = watchlistManager.getRecentlyWatched(userId);

        // Debug logging
        System.out.println("RecentlyWatched retrieved. Total movies: " +
                (recentlyWatched.getMovieIds() != null ? recentlyWatched.getMovieIds().size() : "0"));

        // Get movie details
        MovieManager movieManager = new MovieManager(getServletContext());
        Map<String, Movie> movieMap = new HashMap<>();

        // Defensive initialization
        List<String> movieIds = recentlyWatched.getMovieIds() != null
                ? new ArrayList<>(recentlyWatched.getMovieIds())
                : new ArrayList<>();

        List<Date> watchDates = recentlyWatched.getWatchDates() != null
                ? new ArrayList<>(recentlyWatched.getWatchDates())
                : new ArrayList<>();

        // Safely handle movie retrieval
        for (String movieId : movieIds) {
            Movie movie = movieManager.getMovieById(movieId);
            if (movie != null) {
                movieMap.put(movieId, movie);
            }
        }

        // Debug logging
        System.out.println("Movie Map size: " + movieMap.size());
        System.out.println("Watch Dates size: " + watchDates.size());

        // Set attributes
        request.setAttribute("recentlyWatched", recentlyWatched);
        request.setAttribute("movieMap", movieMap);
        request.setAttribute("movieIds", movieIds);
        request.setAttribute("watchDates", watchDates);

        // Forward to JSP
        request.getRequestDispatcher("/watchlist/recently-watched.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Similar to doGet, handle adding to recently watched
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userId = user.getUserId();
        String movieId = request.getParameter("movieId");

        if (movieId == null || movieId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/recently-watched");
            return;
        }

        WatchlistManager watchlistManager = new WatchlistManager(getServletContext());
        watchlistManager.addToRecentlyWatched(userId, movieId);

        // Get redirect parameter
        String redirect = request.getParameter("redirect");
        if (redirect != null && !redirect.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/" + redirect);
        } else {
            response.sendRedirect(request.getContextPath() + "/recently-watched");
        }
    }
}