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
import com.movierental.model.watchlist.Watchlist;
import com.movierental.model.watchlist.WatchlistManager;
import com.movierental.model.user.User;

/**
 * Servlet handling watchlist item management
 */
@WebServlet("/manage-watchlist")
public class ManageWatchlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the watchlist management form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("ManageWatchlistServlet.doGet() called");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            System.out.println("User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get watchlist ID from request
        String watchlistId = request.getParameter("id");
        System.out.println("Watchlist ID: " + watchlistId);

        if (watchlistId == null || watchlistId.trim().isEmpty()) {
            System.out.println("No watchlist ID provided, redirecting to view-watchlist");
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        // Get user ID from session
        String userId = user.getUserId();

        // Get watchlist entry
        WatchlistManager watchlistManager = new WatchlistManager(getServletContext());
        Watchlist watchlist = watchlistManager.getWatchlistById(watchlistId);

        if (watchlist == null) {
            System.out.println("Watchlist entry not found");
            request.getSession().setAttribute("errorMessage", "Watchlist entry not found");
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        // Check if entry belongs to the user
        if (!watchlist.getUserId().equals(userId)) {
            System.out.println("User does not have permission to manage this entry");
            request.getSession().setAttribute("errorMessage", "You do not have permission to manage this entry");
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        // Get movie details
        MovieManager movieManager = new MovieManager(getServletContext());
        Movie movie = movieManager.getMovieById(watchlist.getMovieId());

        if (movie == null) {
            System.out.println("Movie not found");
            request.getSession().setAttribute("errorMessage", "Movie not found");
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        // Set attributes for JSP
        request.setAttribute("watchlist", watchlist);
        request.setAttribute("movie", movie);

        System.out.println("Forwarding to manage-watchlist.jsp");

        // Forward to management page
        request.getRequestDispatcher("/watchlist/manage-watchlist.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - update watchlist item
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("ManageWatchlistServlet.doPost() called");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            System.out.println("User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from session
        String userId = user.getUserId();
        System.out.println("User ID: " + userId);

        // Get form parameters
        String watchlistId = request.getParameter("watchlistId");
        String priorityStr = request.getParameter("priority");
        String notes = request.getParameter("notes");
        String watchedStr = request.getParameter("watched");

        System.out.println("Watchlist ID: " + watchlistId);
        System.out.println("Priority: " + priorityStr);
        System.out.println("Watched: " + watchedStr);

        // Validate required fields
        if (watchlistId == null || priorityStr == null ||
                watchlistId.trim().isEmpty() || priorityStr.trim().isEmpty()) {

            System.out.println("Required fields are missing");
            request.setAttribute("errorMessage", "Required fields are missing");
            doGet(request, response);
            return;
        }

        // Get watchlist entry
        WatchlistManager watchlistManager = new WatchlistManager(getServletContext());
        Watchlist watchlist = watchlistManager.getWatchlistById(watchlistId);

        if (watchlist == null) {
            System.out.println("Watchlist entry not found");
            request.getSession().setAttribute("errorMessage", "Watchlist entry not found");
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        // Check if entry belongs to the user
        if (!watchlist.getUserId().equals(userId)) {
            System.out.println("User does not have permission to manage this entry");
            request.getSession().setAttribute("errorMessage", "You do not have permission to manage this entry");
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        try {
            // Update watchlist entry
            int priority = Integer.parseInt(priorityStr);
            boolean watched = "on".equals(watchedStr) || "true".equals(watchedStr);

            System.out.println("Parsed priority: " + priority);
            System.out.println("Parsed watched: " + watched);

            watchlist.setPriority(priority);
            watchlist.setNotes(notes);

            // Handle watched status
            if (watched && !watchlist.isWatched()) {
                // Mark as watched if previously unwatched
                System.out.println("Marking as watched");
                watchlist.markAsWatched();
                // Add to recently watched
                watchlistManager.addToRecentlyWatched(userId, watchlist.getMovieId());
            } else if (!watched && watchlist.isWatched()) {
                // Mark as unwatched if previously watched
                System.out.println("Marking as unwatched");
                watchlist.setWatched(false);
            }

            // Update the entry
            boolean updated = watchlistManager.updateWatchlist(watchlist);

            if (updated) {
                System.out.println("Watchlist entry updated successfully");
                request.getSession().setAttribute("successMessage", "Watchlist entry updated");
                response.sendRedirect(request.getContextPath() + "/view-watchlist");
            } else {
                System.out.println("Failed to update watchlist entry");
                request.setAttribute("errorMessage", "Failed to update watchlist entry");
                doGet(request, response);
            }

        } catch (NumberFormatException e) {
            System.out.println("Invalid priority format: " + e.getMessage());
            request.setAttribute("errorMessage", "Invalid priority");
            doGet(request, response);
        }
    }
}