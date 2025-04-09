package com.movierental.servlet.movie;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;

/**
 * Servlet for handling movie deletion
 */
@WebServlet("/delete-movie")
public class DeleteMovieServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display delete confirmation
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get movie ID from request
        String movieId = request.getParameter("id");

        if (movieId == null || movieId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Get movie from database
        MovieManager movieManager = new MovieManager(getServletContext()); // Pass ServletContext
        Movie movie = movieManager.getMovieById(movieId);

        if (movie == null) {
            request.getSession().setAttribute("errorMessage", "Movie not found");
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Set movie in request attributes
        request.setAttribute("movie", movie);

        // Forward to delete confirmation page
        request.getRequestDispatcher("/movie/delete-movie.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process movie deletion
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get movie ID from request
        String movieId = request.getParameter("movieId");
        String confirmDelete = request.getParameter("confirmDelete");

        if (movieId == null || movieId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Check if deletion was confirmed
        if (!"yes".equals(confirmDelete)) {
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Get movie manager with ServletContext
        MovieManager movieManager = new MovieManager(getServletContext());

        // Get movie title for success message before deletion
        Movie movie = movieManager.getMovieById(movieId);
        String movieTitle = (movie != null) ? movie.getTitle() : "Unknown movie";

        // Delete movie
        boolean deleted = movieManager.deleteMovie(movieId);

        if (deleted) {
            // Set success message
            request.getSession().setAttribute("successMessage", "Movie deleted successfully: " + movieTitle);
        } else {
            // Set error message
            request.getSession().setAttribute("errorMessage", "Failed to delete movie");
        }

        // Redirect to movie list
        response.sendRedirect(request.getContextPath() + "/search-movie");
    }
}