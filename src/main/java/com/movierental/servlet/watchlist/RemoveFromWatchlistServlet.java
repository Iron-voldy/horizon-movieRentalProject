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

/**
 * Servlet handling removal from watchlist
 */
@WebServlet("/remove-from-watchlist")
public class RemoveFromWatchlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - confirm removal from watchlist
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("RemoveFromWatchlistServlet.doGet() called");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            System.out.println("User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get parameters
        String watchlistId = request.getParameter("id");
        String confirm = request.getParameter("confirm");

        System.out.println("Watchlist ID: " + watchlistId);
        System.out.println("Confirm: " + confirm);

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
            System.out.println("User does not have permission to remove this entry");
            request.getSession().setAttribute("errorMessage", "You do not have permission to remove this entry");
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

        // If confirmation parameter is provided, remove directly
        if ("yes".equals(confirm)) {
            System.out.println("Confirmation received, removing watchlist item");
            boolean removed = watchlistManager.removeFromWatchlist(watchlistId);

            if (removed) {
                System.out.println("Watchlist item removed successfully");
                request.getSession().setAttribute("successMessage", "Movie removed from watchlist");
            } else {
                System.out.println("Failed to remove watchlist item");
                request.getSession().setAttribute("errorMessage", "Failed to remove movie from watchlist");
            }

            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        // Set attributes for confirmation page
        request.setAttribute("watchlist", watchlist);
        request.setAttribute("movie", movie);

        System.out.println("Forwarding to remove-from-watchlist.jsp");

        // Forward to confirmation page
        request.getRequestDispatcher("/watchlist/remove-from-watchlist.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process removal from watchlist
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("RemoveFromWatchlistServlet.doPost() called");

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

        // Get parameters
        String watchlistId = request.getParameter("watchlistId");
        String confirmRemove = request.getParameter("confirmRemove");

        System.out.println("Watchlist ID: " + watchlistId);
        System.out.println("Confirm Remove: " + confirmRemove);

        if (watchlistId == null || watchlistId.trim().isEmpty()) {
            System.out.println("No watchlist ID provided, redirecting to view-watchlist");
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        if (!"yes".equals(confirmRemove)) {
            // User didn't confirm removal
            System.out.println("User did not confirm removal");
            response.sendRedirect(request.getContextPath() + "/manage-watchlist?id=" + watchlistId);
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
            System.out.println("User does not have permission to remove this entry");
            request.getSession().setAttribute("errorMessage", "You do not have permission to remove this entry");
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        // Remove from watchlist
        boolean removed = watchlistManager.removeFromWatchlist(watchlistId);

        if (removed) {
            System.out.println("Watchlist item removed successfully");
            request.getSession().setAttribute("successMessage", "Movie removed from watchlist");
        } else {
            System.out.println("Failed to remove watchlist item");
            request.getSession().setAttribute("errorMessage", "Failed to remove movie from watchlist");
        }

        // Redirect to watchlist
        response.sendRedirect(request.getContextPath() + "/view-watchlist");
    }
}