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
import com.movierental.model.user.UserManager;

@WebServlet("/rent-movie")
public class RentMovieServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String movieId = request.getParameter("id");
        if (movieId == null || movieId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Create MovieManager with ServletContext
        MovieManager movieManager = new MovieManager(getServletContext());
        Movie movie = movieManager.getMovieById(movieId);

        if (movie == null) {
            session.setAttribute("errorMessage", "Movie not found");
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        if (!movie.isAvailable()) {
            session.setAttribute("errorMessage", "Movie is currently not available for rent");
            response.sendRedirect(request.getContextPath() + "/movie-details?id=" + movieId);
            return;
        }

        request.setAttribute("movie", movie);
        request.getRequestDispatcher("/rental/rent-movie.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String movieId = request.getParameter("movieId");
        String rentalDaysStr = request.getParameter("rentalDays");

        // Enhanced logging
        System.out.println("RentMovieServlet: Attempting to rent");
        System.out.println("User ID: " + userId);
        System.out.println("Movie ID: " + movieId);
        System.out.println("Rental Days: " + rentalDaysStr);

        // Input validation
        if (movieId == null || rentalDaysStr == null ||
                movieId.trim().isEmpty() || rentalDaysStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Invalid request parameters");
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        try {
            int rentalDays = Integer.parseInt(rentalDaysStr);

            // Validate rental days
            if (rentalDays < 1 || rentalDays > 30) {
                session.setAttribute("errorMessage", "Rental period must be between 1 and 30 days");
                response.sendRedirect(request.getContextPath() + "/rent-movie?id=" + movieId);
                return;
            }

            // Create managers with ServletContext
            UserManager userManager = new UserManager(getServletContext());
            MovieManager movieManager = new MovieManager(getServletContext());
            RentalManager rentalManager = new RentalManager(getServletContext());

            // Get user details
            User user = userManager.getUserById(userId);
            if (user == null) {
                session.setAttribute("errorMessage", "User not found");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            int activeRentals = rentalManager.getActiveRentalsByUser(userId).size();

            System.out.println("Active Rentals: " + activeRentals);
            System.out.println("Rental Limit: " + user.getRentalLimit());

            // Check rental limit
            if (activeRentals >= user.getRentalLimit()) {
                session.setAttribute("errorMessage",
                        "You have reached your rental limit of " + user.getRentalLimit() + " movies");
                response.sendRedirect(request.getContextPath() + "/rent-movie?id=" + movieId);
                return;
            }

            // Check movie availability
            Movie movie = movieManager.getMovieById(movieId);

            if (movie == null) {
                session.setAttribute("errorMessage", "Movie not found");
                response.sendRedirect(request.getContextPath() + "/search-movie");
                return;
            }

            if (!movie.isAvailable()) {
                session.setAttribute("errorMessage", "Movie is currently not available for rent");
                response.sendRedirect(request.getContextPath() + "/movie-details?id=" + movieId);
                return;
            }

            // Process rental
            Transaction transaction = rentalManager.rentMovie(userId, movieId, rentalDays);

            if (transaction != null) {
                System.out.println("Rental successful: Transaction ID " + transaction.getTransactionId());

                // Store transaction details
                session.setAttribute("lastTransactionId", transaction.getTransactionId());
                session.setAttribute("lastRentalMovieId", movieId);
                session.setAttribute("lastRentalDays", rentalDays);

                response.sendRedirect(request.getContextPath() + "/rental-confirmation");
            } else {
                System.out.println("Rental failed for Movie ID: " + movieId);
                session.setAttribute("errorMessage", "Failed to rent movie. Please try again.");
                response.sendRedirect(request.getContextPath() + "/rent-movie?id=" + movieId);
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid rental days. Please enter a valid number.");
            response.sendRedirect(request.getContextPath() + "/rent-movie?id=" + movieId);
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An unexpected error occurred. Please try again.");
            response.sendRedirect(request.getContextPath() + "/rent-movie?id=" + movieId);
        }
    }
}