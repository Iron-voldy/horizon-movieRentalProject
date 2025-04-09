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
import com.movierental.model.user.User;

/**
 * Servlet for handling rental cancellations
 */
@WebServlet("/cancel-rental")
public class CancelRentalServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the cancel rental confirmation page
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

        // Get transaction from database
        RentalManager rentalManager = new RentalManager(getServletContext());
        Transaction transaction = rentalManager.getTransactionById(transactionId);

        if (transaction == null) {
            request.getSession().setAttribute("errorMessage", "Rental transaction not found");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        if (transaction.isReturned() || transaction.isCanceled()) {
            request.getSession().setAttribute("errorMessage", "This rental cannot be canceled because it is already returned or canceled");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        // Verify the user owns this transaction
        String userId = (String) session.getAttribute("userId");
        if (!transaction.getUserId().equals(userId)) {
            request.getSession().setAttribute("errorMessage", "You do not have permission to cancel this rental");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        // Get movie details
        MovieManager movieManager = new MovieManager(getServletContext());
        Movie movie = movieManager.getMovieById(transaction.getMovieId());

        // Set transaction and movie in request attributes
        request.setAttribute("transaction", transaction);
        request.setAttribute("movie", movie);

        // Forward to the cancel confirmation page
        request.getRequestDispatcher("/rental/cancel-rental.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the rental cancellation
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

        // Get transaction ID and reason from form
        String transactionId = request.getParameter("transactionId");
        String reason = request.getParameter("reason");
        String confirmCancel = request.getParameter("confirmCancel");

        if (transactionId == null || transactionId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        if (!"yes".equals(confirmCancel)) {
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        // Get transaction from database
        RentalManager rentalManager = new RentalManager(getServletContext());
        Transaction transaction = rentalManager.getTransactionById(transactionId);

        if (transaction == null) {
            request.getSession().setAttribute("errorMessage", "Rental transaction not found");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        // Verify the user owns this transaction
        if (!transaction.getUserId().equals(userId)) {
            request.getSession().setAttribute("errorMessage", "You do not have permission to cancel this rental");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        if (transaction.isReturned() || transaction.isCanceled()) {
            request.getSession().setAttribute("errorMessage", "This rental cannot be canceled because it is already returned or canceled");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        // Get movie details for success message
        MovieManager movieManager = new MovieManager(getServletContext());
        Movie movie = movieManager.getMovieById(transaction.getMovieId());
        String movieTitle = (movie != null) ? movie.getTitle() : "Unknown movie";

        // Process the cancellation
        boolean success = rentalManager.cancelRental(transactionId, reason);

        if (success) {
            request.getSession().setAttribute("successMessage",
                    "Rental for \"" + movieTitle + "\" has been canceled successfully.");
            response.sendRedirect(request.getContextPath() + "/rental-history");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to cancel rental. Please try again.");
            response.sendRedirect(request.getContextPath() + "/cancel-rental?id=" + transactionId);
        }
    }
}