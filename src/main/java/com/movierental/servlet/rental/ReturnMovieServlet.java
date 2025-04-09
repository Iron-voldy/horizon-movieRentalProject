package com.movierental.servlet.rental;

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
import com.movierental.model.rental.Transaction;

/**
 * Servlet for handling movie returns
 */
@WebServlet("/return-movie")
public class ReturnMovieServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display return confirmation
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Not logged in, redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String transactionId = request.getParameter("id");
        if (transactionId == null || transactionId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        // Get transaction from database - use ServletContext here
        RentalManager rentalManager = new RentalManager(getServletContext());
        Transaction transaction = rentalManager.getTransactionById(transactionId);

        if (transaction == null) {
            request.getSession().setAttribute("errorMessage", "Rental transaction not found");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        if (transaction.isReturned()) {
            request.getSession().setAttribute("errorMessage", "This movie has already been returned");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        // Verify the user owns this transaction
        String userId = (String) session.getAttribute("userId");
        if (!transaction.getUserId().equals(userId)) {
            request.getSession().setAttribute("errorMessage", "You do not have permission to return this movie");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        // Get movie details - use ServletContext here
        MovieManager movieManager = new MovieManager(getServletContext());
        Movie movie = movieManager.getMovieById(transaction.getMovieId());

        // Set transaction and movie in request attributes
        request.setAttribute("transaction", transaction);
        request.setAttribute("movie", movie);

        // Forward to the return confirmation page
        request.getRequestDispatcher("/rental/return-movie.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the return
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Not logged in, redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from session
        String userId = (String) session.getAttribute("userId");

        // Get transaction ID from form
        String transactionId = request.getParameter("transactionId");
        String confirmReturn = request.getParameter("confirmReturn");

        if (transactionId == null || transactionId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        if (!"yes".equals(confirmReturn)) {
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        // Get transaction from database - use ServletContext here
        RentalManager rentalManager = new RentalManager(getServletContext());
        Transaction transaction = rentalManager.getTransactionById(transactionId);

        if (transaction == null) {
            request.getSession().setAttribute("errorMessage", "Rental transaction not found");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        // Verify the user owns this transaction
        if (!transaction.getUserId().equals(userId)) {
            request.getSession().setAttribute("errorMessage", "You do not have permission to return this movie");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        if (transaction.isReturned()) {
            request.getSession().setAttribute("errorMessage", "This movie has already been returned");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        // Get movie details for success message - use ServletContext here
        MovieManager movieManager = new MovieManager(getServletContext());
        Movie movie = movieManager.getMovieById(transaction.getMovieId());
        String movieTitle = (movie != null) ? movie.getTitle() : "Unknown movie";

        // Process the return
        boolean success = rentalManager.returnMovie(transactionId);

        if (success) {
            // Get updated transaction to check for late fees
            Transaction updatedTransaction = rentalManager.getTransactionById(transactionId);

            if (updatedTransaction.getLateFee() > 0) {
                request.getSession().setAttribute("successMessage",
                        "Movie \"" + movieTitle + "\" returned successfully. " +
                                "Late fee charged: $" + String.format("%.2f", updatedTransaction.getLateFee()));
            } else {
                request.getSession().setAttribute("successMessage",
                        "Movie \"" + movieTitle + "\" returned successfully.");
            }

            response.sendRedirect(request.getContextPath() + "/rental-history");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to process return. Please try again.");
            response.sendRedirect(request.getContextPath() + "/return-movie?id=" + transactionId);
        }
    }
}