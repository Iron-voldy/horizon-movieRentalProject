package com.movierental.servlet.admin;

import java.io.IOException;
import java.util.List;

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
import com.movierental.model.review.Review;
import com.movierental.model.review.ReviewManager;
import com.movierental.model.user.User;
import com.movierental.model.user.UserManager;

/**
 * Servlet for admin dashboard
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the admin dashboard
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

        // Get statistics for dashboard
        try {
            // Get movie statistics
            MovieManager movieManager = new MovieManager(getServletContext());
            List<Movie> movies = movieManager.getAllMovies();
            int totalMovies = movies.size();
            int availableMovies = 0;

            for (Movie movie : movies) {
                if (movie.isAvailable()) {
                    availableMovies++;
                }
            }

            // Get user statistics
            UserManager userManager = new UserManager(getServletContext());
            List<User> users = userManager.getAllUsers();
            int totalUsers = users.size();

            // Get rental statistics
            RentalManager rentalManager = new RentalManager(getServletContext());
            List<Transaction> transactions = rentalManager.getAllTransactions();
            int totalRentals = transactions.size();
            int activeRentals = 0;
            int overdueRentals = 0;

            for (Transaction transaction : transactions) {
                if (transaction.isActive()) {
                    activeRentals++;
                    if (transaction.isOverdue()) {
                        overdueRentals++;
                    }
                }
            }

            // Get review statistics
            ReviewManager reviewManager = new ReviewManager(getServletContext());
            List<Review> reviews = reviewManager.getAllReviews();
            int totalReviews = reviews.size();

            // Set attributes for JSP
            request.setAttribute("totalMovies", totalMovies);
            request.setAttribute("availableMovies", availableMovies);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalRentals", totalRentals);
            request.setAttribute("activeRentals", activeRentals);
            request.setAttribute("overdueRentals", overdueRentals);
            request.setAttribute("totalReviews", totalReviews);

            // Get recent transactions
            List<Transaction> recentTransactions = rentalManager.getAllTransactions();
            // In a real application, you would limit this list
            request.setAttribute("recentTransactions", recentTransactions);

        } catch (Exception e) {
            System.err.println("Error getting dashboard statistics: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard data");
        }

        // Forward to dashboard JSP
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}