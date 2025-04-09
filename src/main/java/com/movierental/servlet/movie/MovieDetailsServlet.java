package com.movierental.servlet.movie;

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

@WebServlet("/movie-details")
public class MovieDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            // Redirect to login if no user is logged in
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get movie ID from request
        String movieId = request.getParameter("id");

        if (movieId == null || movieId.trim().isEmpty()) {
            // Redirect to search page if no movie ID provided
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Create MovieManager with ServletContext
        MovieManager movieManager = new MovieManager(getServletContext());

        // Find the movie
        Movie movie = movieManager.getMovieById(movieId);

        if (movie == null) {
            // Set error message if movie not found
            session.setAttribute("errorMessage", "Movie not found");
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Set movie as a request attribute
        request.setAttribute("movie", movie);

        // Determine movie type for additional rendering
        if (movie instanceof com.movierental.model.movie.NewRelease) {
            request.setAttribute("movieType", "newRelease");
        } else if (movie instanceof com.movierental.model.movie.ClassicMovie) {
            request.setAttribute("movieType", "classic");
        } else {
            request.setAttribute("movieType", "regular");
        }

        // Forward to movie details page
        request.getRequestDispatcher("/movie/movie-details.jsp").forward(request, response);
    }
}