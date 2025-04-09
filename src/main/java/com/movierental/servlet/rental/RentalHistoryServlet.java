package com.movierental.servlet.rental;

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
import com.movierental.model.rental.RentalManager;
import com.movierental.model.rental.Transaction;
import com.movierental.model.user.User;

@WebServlet("/rental-history")
public class RentalHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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

        // Get user ID from session
        String userId = (String) session.getAttribute("userId");

        // Get rental history from database
        RentalManager rentalManager = new RentalManager(getServletContext());
        List<Transaction> allTransactions = rentalManager.getTransactionsByUser(userId);

        // Create separate lists for different transaction states
        List<Transaction> activeRentals = new ArrayList<>();
        List<Transaction> rentalHistory = new ArrayList<>();
        List<Transaction> canceledRentals = new ArrayList<>();

        // Separate transactions by state
        for (Transaction transaction : allTransactions) {
            if (transaction.isReturned()) {
                rentalHistory.add(transaction);
            } else if (transaction.isCanceled()) {
                canceledRentals.add(transaction);
            } else {
                activeRentals.add(transaction);
            }
        }

        // Get overdue rentals
        List<Transaction> overdueRentals = rentalManager.getOverdueRentalsByUser(userId);

        // Fetch movie details for each transaction
        MovieManager movieManager = new MovieManager(getServletContext());
        Map<String, Movie> movieMap = new HashMap<>();

        // Fill movie map for all transactions
        for (Transaction transaction : allTransactions) {
            String movieId = transaction.getMovieId();
            if (!movieMap.containsKey(movieId)) {
                Movie movie = movieManager.getMovieById(movieId);
                if (movie != null) {
                    movieMap.put(movieId, movie);
                }
            }
        }

        // Debug logging
        System.out.println("RentalHistoryServlet: Active Rentals - " + activeRentals.size());
        System.out.println("RentalHistoryServlet: Rental History - " + rentalHistory.size());
        System.out.println("RentalHistoryServlet: Canceled Rentals - " + canceledRentals.size());
        System.out.println("RentalHistoryServlet: Overdue Rentals - " + overdueRentals.size());

        // Set data in request attributes
        request.setAttribute("activeRentals", activeRentals);
        request.setAttribute("rentalHistory", rentalHistory);
        request.setAttribute("canceledRentals", canceledRentals);
        request.setAttribute("overdueRentals", overdueRentals);
        request.setAttribute("movieMap", movieMap);

        // Forward to the rental history page
        request.getRequestDispatcher("/rental/rental-history.jsp").forward(request, response);
    }
}