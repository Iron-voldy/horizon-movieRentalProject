package com.movierental.servlet.rental;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

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
import com.movierental.model.user.UserManager;

/**
 * Servlet for handling editing of rental details
 */
@WebServlet("/edit-rental")
public class EditRentalServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - displays the edit rental form
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
            request.getSession().setAttribute("errorMessage", "This rental cannot be edited because it is already returned or canceled");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        // Verify the user owns this transaction
        String userId = (String) session.getAttribute("userId");
        if (!transaction.getUserId().equals(userId)) {
            request.getSession().setAttribute("errorMessage", "You do not have permission to edit this rental");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        // Get movie details
        MovieManager movieManager = new MovieManager(getServletContext());
        Movie movie = movieManager.getMovieById(transaction.getMovieId());

        if (movie == null) {
            request.getSession().setAttribute("errorMessage", "Movie information not found");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        // Get rental duration
        int rentalDuration = transaction.getRentalDuration();

        // Set attributes for the JSP
        request.setAttribute("transaction", transaction);
        request.setAttribute("movie", movie);
        request.setAttribute("rentalDuration", rentalDuration);

        // Forward to the edit rental page
        request.getRequestDispatcher("/rental/edit-rental.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the rental update
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

        // Get parameters from form
        String transactionId = request.getParameter("transactionId");
        String rentalDaysStr = request.getParameter("rentalDays");

        // Validate parameters
        if (transactionId == null || rentalDaysStr == null ||
                transactionId.trim().isEmpty() || rentalDaysStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Missing required parameters");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        try {
            int rentalDays = Integer.parseInt(rentalDaysStr);

            // Validate rental days
            if (rentalDays < 1 || rentalDays > 30) {
                request.getSession().setAttribute("errorMessage", "Rental period must be between 1 and 30 days");
                response.sendRedirect(request.getContextPath() + "/edit-rental?id=" + transactionId);
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
                request.getSession().setAttribute("errorMessage", "You do not have permission to edit this rental");
                response.sendRedirect(request.getContextPath() + "/rental-history");
                return;
            }

            if (transaction.isReturned() || transaction.isCanceled()) {
                request.getSession().setAttribute("errorMessage", "This rental cannot be edited because it is already returned or canceled");
                response.sendRedirect(request.getContextPath() + "/rental-history");
                return;
            }

            // Get movie details for success message
            MovieManager movieManager = new MovieManager(getServletContext());
            Movie movie = movieManager.getMovieById(transaction.getMovieId());
            String movieTitle = (movie != null) ? movie.getTitle() : "Unknown movie";

            // Update the rental
            boolean success = rentalManager.updateRentalDueDate(transactionId, rentalDays);

            if (success) {
                // Get the updated transaction for the confirmation message
                Transaction updatedTransaction = rentalManager.getTransactionById(transactionId);
                SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
                String newDueDate = dateFormat.format(updatedTransaction.getDueDate());

                request.getSession().setAttribute("successMessage",
                        "Rental for \"" + movieTitle + "\" has been updated successfully. New due date: " + newDueDate);
                response.sendRedirect(request.getContextPath() + "/rental-history");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update rental. Please try again.");
                response.sendRedirect(request.getContextPath() + "/edit-rental?id=" + transactionId);
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid rental days format");
            response.sendRedirect(request.getContextPath() + "/edit-rental?id=" + transactionId);
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/edit-rental?id=" + transactionId);
        }
    }
}