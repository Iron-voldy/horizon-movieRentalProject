package com.movierental.servlet.admin;

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

import com.movierental.model.admin.Admin;
import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;
import com.movierental.model.rental.RentalManager;
import com.movierental.model.rental.Transaction;
import com.movierental.model.user.User;
import com.movierental.model.user.UserManager;

/**
 * Servlet for handling rental management (admin)
 */
@WebServlet("/admin/rentals")
public class ManageRentalsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display rental list or details
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;

        if (admin == null) {
            // Not logged in, redirect to login
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Get action and id from request
        String action = request.getParameter("action");
        String transactionId = request.getParameter("id");

        // Create managers
        RentalManager rentalManager = new RentalManager(getServletContext());
        UserManager userManager = new UserManager(getServletContext());
        MovieManager movieManager = new MovieManager(getServletContext());

        if ("view".equals(action) && transactionId != null) {
            // Display rental details
            Transaction transaction = rentalManager.getTransactionById(transactionId);

            if (transaction == null) {
                session.setAttribute("errorMessage", "Rental transaction not found");
                response.sendRedirect(request.getContextPath() + "/admin/rentals");
                return;
            }

            // Get user and movie details
            User user = userManager.getUserById(transaction.getUserId());
            Movie movie = movieManager.getMovieById(transaction.getMovieId());

            request.setAttribute("transaction", transaction);
            request.setAttribute("user", user);
            request.setAttribute("movie", movie);

            request.getRequestDispatcher("/admin/rentals/details.jsp").forward(request, response);
            return;
        } else if ("return".equals(action) && transactionId != null) {
            // Process return
            Transaction transaction = rentalManager.getTransactionById(transactionId);

            if (transaction == null) {
                session.setAttribute("errorMessage", "Rental transaction not found");
                response.sendRedirect(request.getContextPath() + "/admin/rentals");
                return;
            }

            if (transaction.isReturned()) {
                session.setAttribute("errorMessage", "This movie has already been returned");
                response.sendRedirect(request.getContextPath() + "/admin/rentals");
                return;
            }

            boolean returned = rentalManager.returnMovie(transactionId);

            if (returned) {
                session.setAttribute("successMessage", "Movie marked as returned successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to mark movie as returned");
            }

            response.sendRedirect(request.getContextPath() + "/admin/rentals");
            return;
        } else if ("cancel".equals(action) && transactionId != null) {
            // Process cancellation
            Transaction transaction = rentalManager.getTransactionById(transactionId);

            if (transaction == null) {
                session.setAttribute("errorMessage", "Rental transaction not found");
                response.sendRedirect(request.getContextPath() + "/admin/rentals");
                return;
            }

            if (transaction.isReturned() || transaction.isCanceled()) {
                session.setAttribute("errorMessage", "This rental cannot be canceled");
                response.sendRedirect(request.getContextPath() + "/admin/rentals");
                return;
            }

            boolean canceled = rentalManager.cancelRental(transactionId, "Canceled by admin");

            if (canceled) {
                session.setAttribute("successMessage", "Rental canceled successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to cancel rental");
            }

            response.sendRedirect(request.getContextPath() + "/admin/rentals");
            return;
        } else if ("delete".equals(action) && transactionId != null) {
            // Delete rental record
            boolean deleted = rentalManager.deleteTransaction(transactionId);

            if (deleted) {
                session.setAttribute("successMessage", "Rental record deleted successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to delete rental record");
            }

            response.sendRedirect(request.getContextPath() + "/admin/rentals");
            return;
        }

        // Default action: display rental list
        // Get filter parameter
        String filter = request.getParameter("filter");
        if (filter == null) {
            filter = "all"; // Default filter
        }

        List<Transaction> transactions;

        // Apply filter
        switch (filter) {
            case "active":
                transactions = new ArrayList<>();
                for (Transaction t : rentalManager.getAllTransactions()) {
                    if (t.isActive()) {
                        transactions.add(t);
                    }
                }
                break;
            case "returned":
                transactions = new ArrayList<>();
                for (Transaction t : rentalManager.getAllTransactions()) {
                    if (t.isReturned()) {
                        transactions.add(t);
                    }
                }
                break;
            case "canceled":
                transactions = new ArrayList<>();
                for (Transaction t : rentalManager.getAllTransactions()) {
                    if (t.isCanceled()) {
                        transactions.add(t);
                    }
                }
                break;
            case "overdue":
                transactions = rentalManager.getOverdueRentals();
                break;
            default:
                transactions = rentalManager.getAllTransactions();
                break;
        }

        // Create maps for user and movie info
        Map<String, User> userMap = new HashMap<>();
        Map<String, Movie> movieMap = new HashMap<>();

        for (Transaction transaction : transactions) {
            // Get user info
            String userId = transaction.getUserId();
            if (!userMap.containsKey(userId)) {
                User user = userManager.getUserById(userId);
                if (user != null) {
                    userMap.put(userId, user);
                }
            }

            // Get movie info
            String movieId = transaction.getMovieId();
            if (!movieMap.containsKey(movieId)) {
                Movie movie = movieManager.getMovieById(movieId);
                if (movie != null) {
                    movieMap.put(movieId, movie);
                }
            }
        }

        request.setAttribute("transactions", transactions);
        request.setAttribute("userMap", userMap);
        request.setAttribute("movieMap", movieMap);
        request.setAttribute("filter", filter);

        request.getRequestDispatcher("/admin/rentals/list.jsp").forward(request, response);
    }
}