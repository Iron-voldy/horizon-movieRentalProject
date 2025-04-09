package com.movierental.servlet.movie;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;

/**
 * Servlet for handling movie search functionality
 */
@WebServlet("/search-movie")
public class SearchMovieServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display search form and results
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Create MovieManager with ServletContext for proper file path handling
        MovieManager movieManager = new MovieManager(getServletContext());
        List<Movie> movies = new ArrayList<>();

        // Get search parameters
        String searchQuery = request.getParameter("searchQuery");
        String searchType = request.getParameter("searchType");

        // If search parameters are provided, filter results
        if (searchQuery != null && !searchQuery.trim().isEmpty() && searchType != null) {
            switch (searchType) {
                case "title":
                    movies = movieManager.searchByTitle(searchQuery);
                    break;
                case "director":
                    movies = movieManager.searchByDirector(searchQuery);
                    break;
                case "genre":
                    movies = movieManager.searchByGenre(searchQuery);
                    break;
                default:
                    // Default to all movies if search type is invalid
                    movies = movieManager.getAllMovies();
                    break;
            }
        } else {
            // If no search parameters, show all movies
            movies = movieManager.getAllMovies();
        }

        // Add all movies to request attributes
        request.setAttribute("movies", movies);

        // Pass search parameters back to form
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("searchType", searchType);

        // Forward to search page
        request.getRequestDispatcher("/movie/search-movie.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process search form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Just redirect to doGet for processing
        doGet(request, response);
    }
}