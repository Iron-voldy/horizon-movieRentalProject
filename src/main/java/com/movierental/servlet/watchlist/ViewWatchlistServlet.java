package com.movierental.servlet.watchlist;

import java.io.IOException;
import java.util.ArrayList;
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
import com.movierental.model.watchlist.WatchlistManager;
import com.movierental.model.watchlist.Watchlist;
import com.movierental.model.user.User;

/**
 * Servlet handling viewing the watchlist
 */
@WebServlet("/view-watchlist")
public class ViewWatchlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the watchlist
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("ViewWatchlistServlet.doGet() called");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            System.out.println("User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from user object
        String userId = user.getUserId();
        System.out.println("User ID: " + userId);

        // Get filter parameters
        String filter = request.getParameter("filter");
        String sort = request.getParameter("sort");

        // Default values
        if (filter == null) {
            filter = "all"; // all, unwatched, watched
        }

        if (sort == null) {
            sort = "priority"; // priority, added-desc, added-asc
        }

        System.out.println("Filter: " + filter + ", Sort: " + sort);

        // Get watchlist manager with ServletContext
        WatchlistManager watchlistManager = new WatchlistManager(getServletContext());

        // Get watchlist based on filter
        List<Watchlist> watchlist;
        if ("unwatched".equals(filter)) {
            watchlist = watchlistManager.getUnwatchedByUser(userId);
        } else if ("watched".equals(filter)) {
            watchlist = watchlistManager.getWatchedByUser(userId);
        } else {
            watchlist = watchlistManager.getWatchlistByUser(userId);
        }

        // If the list is null, initialize it as empty
        if (watchlist == null) {
            watchlist = new ArrayList<>();
        }

        System.out.println("Retrieved " + watchlist.size() + " watchlist entries");

        // Sort watchlist
        if ("priority".equals(sort)) {
            watchlist = watchlistManager.sortByPriority(watchlist);
        } else if ("added-desc".equals(sort)) {
            watchlist = watchlistManager.sortByDateAdded(watchlist, false);
        } else if ("added-asc".equals(sort)) {
            watchlist = watchlistManager.sortByDateAdded(watchlist, true);
        }

        // Get movie details for each watchlist item
        MovieManager movieManager = new MovieManager(getServletContext());
        Map<String, Movie> movieMap = new HashMap<>();

        for (Watchlist item : watchlist) {
            String movieId = item.getMovieId();
            if (!movieMap.containsKey(movieId)) {
                Movie movie = movieManager.getMovieById(movieId);
                if (movie != null) {
                    movieMap.put(movieId, movie);
                } else {
                    System.out.println("Warning: Movie not found for ID: " + movieId);
                }
            }
        }

        // Get watchlist statistics
        int totalCount = watchlistManager.getWatchlistCount(userId);
        int unwatchedCount = watchlistManager.getUnwatchedCount(userId);
        int watchedCount = watchlistManager.getWatchedCount(userId);

        System.out.println("Watchlist stats - Total: " + totalCount + ", Unwatched: " + unwatchedCount + ", Watched: " + watchedCount);

        // Get recently watched movies
        List<String> recentMovieIds = new ArrayList<>();
        try {
            recentMovieIds = watchlistManager.getRecentlyWatched(userId).getMovieIds();
            System.out.println("Retrieved " + recentMovieIds.size() + " recently watched movies");

            // Get movie details for recently watched
            for (String movieId : recentMovieIds) {
                if (!movieMap.containsKey(movieId)) {
                    Movie movie = movieManager.getMovieById(movieId);
                    if (movie != null) {
                        movieMap.put(movieId, movie);
                    } else {
                        System.out.println("Warning: Recently watched movie not found for ID: " + movieId);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Error getting recently watched movies: " + e.getMessage());
            e.printStackTrace();
            // Initialize as empty if there's an error
        }

        // Set attributes for JSP
        request.setAttribute("watchlist", watchlist);
        request.setAttribute("movieMap", movieMap);
        request.setAttribute("filter", filter);
        request.setAttribute("sort", sort);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("unwatchedCount", unwatchedCount);
        request.setAttribute("watchedCount", watchedCount);
        request.setAttribute("recentMovieIds", recentMovieIds);

        System.out.println("Forwarding to watchlist.jsp");

        // Forward to watchlist JSP
        request.getRequestDispatcher("/watchlist/watchlist.jsp").forward(request, response);
    }
}