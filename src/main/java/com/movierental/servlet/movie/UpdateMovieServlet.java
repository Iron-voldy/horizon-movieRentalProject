/**
 * Step 7: Update UpdateMovieServlet to handle file uploads
 * File: src/main/java/com/movierental/servlet/movie/UpdateMovieServlet.java
 */
package com.movierental.servlet.movie;

import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.movierental.model.movie.ClassicMovie;
import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;
import com.movierental.model.movie.NewRelease;

/**
 * Servlet for handling movie updates with file uploads
 */
@WebServlet("/update-movie")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 5 * 1024 * 1024,   // 5 MB
        maxRequestSize = 10 * 1024 * 1024 // 10 MB
)
public class UpdateMovieServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the edit movie form
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
        MovieManager movieManager = new MovieManager(getServletContext());
        Movie movie = movieManager.getMovieById(movieId);

        if (movie == null) {
            request.getSession().setAttribute("errorMessage", "Movie not found");
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Set movie in request attributes
        request.setAttribute("movie", movie);

        // Set movie type
        if (movie instanceof NewRelease) {
            request.setAttribute("movieType", "newRelease");
        } else if (movie instanceof ClassicMovie) {
            request.setAttribute("movieType", "classic");
        } else {
            request.setAttribute("movieType", "regular");
        }

        // Forward to edit page
        request.getRequestDispatcher("/movie/edit-movie.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the edit movie form with file upload
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String movieId = request.getParameter("movieId");
        String title = request.getParameter("title");
        String director = request.getParameter("director");
        String genre = request.getParameter("genre");
        String releaseYearStr = request.getParameter("releaseYear");
        String ratingStr = request.getParameter("rating");
        String availableStr = request.getParameter("available");
        String movieType = request.getParameter("movieType");

        // Additional parameters for specific movie types
        String releaseDateStr = request.getParameter("releaseDate");
        String significance = request.getParameter("significance");
        String hasAwardsStr = request.getParameter("hasAwards");

        // Get the cover photo file part
        Part coverPhotoPart = null;
        try {
            coverPhotoPart = request.getPart("coverPhoto");
        } catch (Exception e) {
            // Part not found or not a multipart request
            getServletContext().log("Error getting coverPhoto part: " + e.getMessage());
        }

        // Validate required fields
        if (movieId == null || title == null || director == null || genre == null ||
                releaseYearStr == null || ratingStr == null ||
                movieId.trim().isEmpty() || title.trim().isEmpty() ||
                director.trim().isEmpty() || genre.trim().isEmpty() ||
                releaseYearStr.trim().isEmpty() || ratingStr.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required");
            doGet(request, response);
            return;
        }

        try {
            // Parse numeric values
            int releaseYear = Integer.parseInt(releaseYearStr);
            double rating = Double.parseDouble(ratingStr);
            boolean available = "on".equals(availableStr) || "true".equals(availableStr);

            // Validate rating range (0-10)
            if (rating < 0 || rating > 10) {
                request.setAttribute("errorMessage", "Rating must be between 0 and 10");
                doGet(request, response);
                return;
            }

            // Create MovieManager
            MovieManager movieManager = new MovieManager(getServletContext());

            // Get existing movie
            Movie existingMovie = movieManager.getMovieById(movieId);

            if (existingMovie == null) {
                request.getSession().setAttribute("errorMessage", "Movie not found");
                response.sendRedirect(request.getContextPath() + "/search-movie");
                return;
            }

            // Get cover photo input stream and file name if available
            InputStream coverPhotoStream = null;
            String originalFileName = null;

            if (coverPhotoPart != null && coverPhotoPart.getSize() > 0) {
                coverPhotoStream = coverPhotoPart.getInputStream();
                String contentDisposition = coverPhotoPart.getHeader("content-disposition");
                if (contentDisposition != null) {
                    // Extract file name from content-disposition header
                    for (String part : contentDisposition.split(";")) {
                        part = part.trim();
                        if (part.startsWith("filename=")) {
                            originalFileName = part.substring(part.indexOf("=") + 1).replace("\"", "");
                            break;
                        }
                    }
                }
            }

            // Create updated movie based on type
            Movie updatedMovie = null;

            switch (movieType) {
                case "newRelease":
                    NewRelease newRelease;

                    // Check if the existing movie is already a NewRelease
                    if (existingMovie instanceof NewRelease) {
                        newRelease = (NewRelease) existingMovie;
                    } else {
                        newRelease = new NewRelease();
                        newRelease.setMovieId(movieId);
                    }

                    // Update basic properties
                    newRelease.setTitle(title);
                    newRelease.setDirector(director);
                    newRelease.setGenre(genre);
                    newRelease.setReleaseYear(releaseYear);
                    newRelease.setRating(rating);
                    newRelease.setAvailable(available);

                    // Update release date if provided
                    if (releaseDateStr != null && !releaseDateStr.trim().isEmpty()) {
                        try {
                            Date releaseDate = new SimpleDateFormat("yyyy-MM-dd").parse(releaseDateStr);
                            newRelease.setReleaseDate(releaseDate);
                        } catch (ParseException e) {
                            // Keep existing date if parsing fails
                        }
                    }

                    updatedMovie = newRelease;
                    break;

                case "classic":
                    ClassicMovie classicMovie;

                    // Check if the existing movie is already a ClassicMovie
                    if (existingMovie instanceof ClassicMovie) {
                        classicMovie = (ClassicMovie) existingMovie;
                    } else {
                        classicMovie = new ClassicMovie();
                        classicMovie.setMovieId(movieId);
                    }

                    // Update basic properties
                    classicMovie.setTitle(title);
                    classicMovie.setDirector(director);
                    classicMovie.setGenre(genre);
                    classicMovie.setReleaseYear(releaseYear);
                    classicMovie.setRating(rating);
                    classicMovie.setAvailable(available);

                    // Update classic-specific properties
                    classicMovie.setSignificance(significance != null ? significance : "");
                    classicMovie.setHasAwards("on".equals(hasAwardsStr) || "true".equals(hasAwardsStr));

                    updatedMovie = classicMovie;
                    break;

                default: // Regular movie
                    Movie regularMovie = new Movie();
                    regularMovie.setMovieId(movieId);
                    regularMovie.setTitle(title);
                    regularMovie.setDirector(director);
                    regularMovie.setGenre(genre);
                    regularMovie.setReleaseYear(releaseYear);
                    regularMovie.setRating(rating);
                    regularMovie.setAvailable(available);

                    updatedMovie = regularMovie;
                    break;
            }

            // Update movie in database with the cover photo if provided
            boolean success = movieManager.updateMovie(updatedMovie, coverPhotoStream, originalFileName);

            // Close the input stream if it was opened
            if (coverPhotoStream != null) {
                coverPhotoStream.close();
            }

            if (success) {
                // Set success message
                request.getSession().setAttribute("successMessage", "Movie updated successfully: " + updatedMovie.getTitle());

                // Redirect to movie list
                response.sendRedirect(request.getContextPath() + "/search-movie");
            } else {
                request.setAttribute("errorMessage", "Failed to update movie");
                doGet(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid number format. Please check your input.");
            doGet(request, response);
        }
    }
}