/**
 * Step 2: Update MovieManager to handle cover photos and use WEB-INF/data path
 * File: src/main/java/com/movierental/model/movie/MovieManager.java
 */
package com.movierental.model.movie;

import java.io.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import javax.servlet.ServletContext;

/**
 * MovieManager class handles all movie-related operations
 */
public class MovieManager {
    // Changed from a hardcoded path to a dynamic one
    private static final String MOVIE_FILE_NAME = "movies.txt";
    private static final String MOVIE_IMAGES_DIR = "movie_images";

    private List<Movie> movies;
    private ServletContext servletContext;
    private String dataFilePath;
    private String imagesDirectoryPath;

    // Constructor without ServletContext (for backward compatibility)
    public MovieManager() {
        this(null);
    }

    // Constructor with ServletContext
    public MovieManager(ServletContext servletContext) {
        this.servletContext = servletContext;
        movies = new ArrayList<>();
        initializeFilePaths();
        loadMovies();
    }

    // Initialize file paths based on ServletContext
    private void initializeFilePaths() {
        if (servletContext != null) {
            // Use WEB-INF/data within the application context
            String webInfDataPath = "/WEB-INF/data";
            dataFilePath = servletContext.getRealPath(webInfDataPath) + File.separator + MOVIE_FILE_NAME;
            imagesDirectoryPath = servletContext.getRealPath(webInfDataPath) + File.separator + MOVIE_IMAGES_DIR;

            // Make sure directories exist
            File dataDir = new File(servletContext.getRealPath(webInfDataPath));
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created WEB-INF/data directory: " + dataDir.getAbsolutePath() + " - Success: " + created);
            }

            // Create images directory
            File imagesDir = new File(imagesDirectoryPath);
            if (!imagesDir.exists()) {
                boolean created = imagesDir.mkdirs();
                System.out.println("Created movie images directory: " + imagesDir.getAbsolutePath() + " - Success: " + created);
            }
        } else {
            // Fallback to simple data directory if not in web context
            String dataPath = "data";
            dataFilePath = dataPath + File.separator + MOVIE_FILE_NAME;
            imagesDirectoryPath = dataPath + File.separator + MOVIE_IMAGES_DIR;

            // Make sure directories exist
            File dataDir = new File(dataPath);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created fallback data directory: " + dataPath + " - Success: " + created);
            }

            // Create images directory
            File imagesDir = new File(imagesDirectoryPath);
            if (!imagesDir.exists()) {
                boolean created = imagesDir.mkdirs();
                System.out.println("Created movie images directory: " + imagesDir.getAbsolutePath() + " - Success: " + created);
            }
        }

        System.out.println("MovieManager: Using data file path: " + dataFilePath);
        System.out.println("MovieManager: Using images directory: " + imagesDirectoryPath);
    }

    // Load movies from file
    private void loadMovies() {
        File file = new File(dataFilePath);

        // Create directory if it doesn't exist
        if (file.getParentFile() != null) {
            file.getParentFile().mkdirs();
        }

        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.err.println("Error creating movies file: " + e.getMessage());
            }
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue;
                }

                Movie movie = null;
                if (line.startsWith("NEW_RELEASE,")) {
                    movie = NewRelease.fromFileString(line);
                } else if (line.startsWith("CLASSIC,")) {
                    movie = ClassicMovie.fromFileString(line);
                } else if (line.startsWith("REGULAR,")) {
                    movie = Movie.fromFileString(line);
                }

                if (movie != null) {
                    movies.add(movie);
                }
            }
        } catch (IOException e) {
            System.err.println("Error loading movies: " + e.getMessage());
        }
    }

    // Save movies to file
    private void saveMovies() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(dataFilePath))) {
            for (Movie movie : movies) {
                writer.write(movie.toFileString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error saving movies: " + e.getMessage());
        }
    }

    // Add a new movie with cover photo
    public boolean addMovie(Movie movie, InputStream coverPhotoStream, String originalFileName) {
        // Generate a unique ID if not provided
        if (movie.getMovieId() == null || movie.getMovieId().isEmpty()) {
            movie.setMovieId(UUID.randomUUID().toString());
        }

        // Save the cover photo if provided
        if (coverPhotoStream != null) {
            String fileExtension = getFileExtension(originalFileName);
            String photoFileName = movie.getMovieId() + fileExtension;
            String photoPath = imagesDirectoryPath + File.separator + photoFileName;

            try {
                savePhoto(coverPhotoStream, photoPath);
                movie.setCoverPhotoPath(MOVIE_IMAGES_DIR + "/" + photoFileName);
            } catch (IOException e) {
                System.err.println("Error saving cover photo: " + e.getMessage());
                // Continue adding the movie even if photo upload fails
            }
        }

        movies.add(movie);
        saveMovies();
        return true;
    }

    // Helper method to save a photo file
    private void savePhoto(InputStream inputStream, String filePath) throws IOException {
        File outputFile = new File(filePath);

        // Ensure parent directory exists
        if (outputFile.getParentFile() != null) {
            outputFile.getParentFile().mkdirs();
        }

        try (FileOutputStream outputStream = new FileOutputStream(outputFile)) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
        }
    }

    // Helper method to get file extension
    private String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty() || !fileName.contains(".")) {
            return ".jpg"; // Default extension
        }
        return fileName.substring(fileName.lastIndexOf('.'));
    }

    // Update movie with a new cover photo
    public boolean updateMovie(Movie updatedMovie, InputStream coverPhotoStream, String originalFileName) {
        for (int i = 0; i < movies.size(); i++) {
            if (movies.get(i).getMovieId().equals(updatedMovie.getMovieId())) {
                // If a new cover photo is provided, save it and update the path
                if (coverPhotoStream != null) {
                    String fileExtension = getFileExtension(originalFileName);
                    String photoFileName = updatedMovie.getMovieId() + fileExtension;
                    String photoPath = imagesDirectoryPath + File.separator + photoFileName;

                    try {
                        savePhoto(coverPhotoStream, photoPath);
                        updatedMovie.setCoverPhotoPath(MOVIE_IMAGES_DIR + "/" + photoFileName);
                    } catch (IOException e) {
                        System.err.println("Error updating cover photo: " + e.getMessage());
                        // Continue updating the movie even if photo update fails
                        // Keep the old photo path
                        updatedMovie.setCoverPhotoPath(movies.get(i).getCoverPhotoPath());
                    }
                } else {
                    // No new photo provided, keep the old one
                    updatedMovie.setCoverPhotoPath(movies.get(i).getCoverPhotoPath());
                }

                movies.set(i, updatedMovie);
                saveMovies();
                return true;
            }
        }
        return false;
    }

    // Add a new regular movie with cover photo
    public Movie addRegularMovie(String title, String director, String genre,
                                 int releaseYear, double rating, InputStream coverPhotoStream, String originalFileName) {
        Movie movie = new Movie();
        movie.setMovieId(UUID.randomUUID().toString());
        movie.setTitle(title);
        movie.setDirector(director);
        movie.setGenre(genre);
        movie.setReleaseYear(releaseYear);
        movie.setRating(rating);
        movie.setAvailable(true);

        // Add the movie with the cover photo
        addMovie(movie, coverPhotoStream, originalFileName);

        return movie;
    }

    // Add a new release movie with cover photo
    public NewRelease addNewRelease(String title, String director, String genre,
                                    int releaseYear, double rating, InputStream coverPhotoStream, String originalFileName) {
        NewRelease movie = new NewRelease();
        movie.setMovieId(UUID.randomUUID().toString());
        movie.setTitle(title);
        movie.setDirector(director);
        movie.setGenre(genre);
        movie.setReleaseYear(releaseYear);
        movie.setRating(rating);
        movie.setAvailable(true);
        movie.setReleaseDate(new Date());

        // Add the movie with the cover photo
        addMovie(movie, coverPhotoStream, originalFileName);

        return movie;
    }

    // Add a classic movie with cover photo
    public ClassicMovie addClassicMovie(String title, String director, String genre,
                                        int releaseYear, double rating,
                                        String significance, boolean hasAwards,
                                        InputStream coverPhotoStream, String originalFileName) {
        ClassicMovie movie = new ClassicMovie();
        movie.setMovieId(UUID.randomUUID().toString());
        movie.setTitle(title);
        movie.setDirector(director);
        movie.setGenre(genre);
        movie.setReleaseYear(releaseYear);
        movie.setRating(rating);
        movie.setAvailable(true);
        movie.setSignificance(significance);
        movie.setHasAwards(hasAwards);

        // Add the movie with the cover photo
        addMovie(movie, coverPhotoStream, originalFileName);

        return movie;
    }

    // Get movie by ID
    public Movie getMovieById(String movieId) {
        for (Movie movie : movies) {
            if (movie.getMovieId().equals(movieId)) {
                return movie;
            }
        }
        return null;
    }

    // Get all movies
    public List<Movie> getAllMovies() {
        return new ArrayList<>(movies);
    }

    // Search movies by title
    public List<Movie> searchByTitle(String titleQuery) {
        List<Movie> results = new ArrayList<>();
        String query = titleQuery.toLowerCase();

        for (Movie movie : movies) {
            if (movie.getTitle().toLowerCase().contains(query)) {
                results.add(movie);
            }
        }

        return results;
    }

    // Search movies by director
    public List<Movie> searchByDirector(String directorQuery) {
        List<Movie> results = new ArrayList<>();
        String query = directorQuery.toLowerCase();

        for (Movie movie : movies) {
            if (movie.getDirector().toLowerCase().contains(query)) {
                results.add(movie);
            }
        }

        return results;
    }

    // Search movies by genre
    public List<Movie> searchByGenre(String genreQuery) {
        List<Movie> results = new ArrayList<>();
        String query = genreQuery.toLowerCase();

        for (Movie movie : movies) {
            if (movie.getGenre().toLowerCase().contains(query)) {
                results.add(movie);
            }
        }

        return results;
    }

    // Get available movies
    public List<Movie> getAvailableMovies() {
        List<Movie> results = new ArrayList<>();

        for (Movie movie : movies) {
            if (movie.isAvailable()) {
                results.add(movie);
            }
        }

        return results;
    }

    // Update movie availability
    public boolean updateAvailability(String movieId, boolean available) {
        Movie movie = getMovieById(movieId);
        if (movie != null) {
            movie.setAvailable(available);
            saveMovies();
            return true;
        }
        return false;
    }

    // Update movie with existing methods (maintaining backward compatibility)
    public boolean updateMovie(Movie updatedMovie) {
        return updateMovie(updatedMovie, null, null);
    }

    // Delete movie and its cover photo
    public boolean deleteMovie(String movieId) {
        Movie movieToDelete = null;

        // Find the movie first to get its cover photo path
        for (Movie movie : movies) {
            if (movie.getMovieId().equals(movieId)) {
                movieToDelete = movie;
                break;
            }
        }

        if (movieToDelete != null) {
            // Delete the cover photo if it exists
            if (movieToDelete.getCoverPhotoPath() != null && !movieToDelete.getCoverPhotoPath().isEmpty()) {
                String photoPath = null;
                if (servletContext != null) {
                    photoPath = servletContext.getRealPath("/WEB-INF/data") +
                            File.separator + movieToDelete.getCoverPhotoPath();
                } else {
                    photoPath = "data" + File.separator + movieToDelete.getCoverPhotoPath();
                }

                File photoFile = new File(photoPath);
                if (photoFile.exists()) {
                    photoFile.delete();
                }
            }

            // Remove the movie from the list
            movies.remove(movieToDelete);
            saveMovies();
            return true;
        }

        return false;
    }

    // Sort movies by rating (bubble sort implementation)
    public List<Movie> sortByRating() {
        List<Movie> sortedMovies = new ArrayList<>(movies);
        int n = sortedMovies.size();

        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (sortedMovies.get(j).getRating() < sortedMovies.get(j + 1).getRating()) {
                    // Swap movies
                    Movie temp = sortedMovies.get(j);
                    sortedMovies.set(j, sortedMovies.get(j + 1));
                    sortedMovies.set(j + 1, temp);
                }
            }
        }

        return sortedMovies;
    }

    // Get top rated movies
    public List<Movie> getTopRatedMovies(int count) {
        List<Movie> sortedMovies = sortByRating();
        int limit = Math.min(count, sortedMovies.size());
        return sortedMovies.subList(0, limit);
    }

    // Get the full URL path for a movie's cover photo
    public String getCoverPhotoUrl(Movie movie) {
        if (movie.getCoverPhotoPath() == null || movie.getCoverPhotoPath().isEmpty()) {
            return ""; // No photo available
        }

        if (servletContext != null) {
            // When in web context, return a URL relative to the application
            return servletContext.getContextPath() + "/image-servlet?movieId=" + movie.getMovieId();
        } else {
            // For testing or non-web contexts
            return movie.getCoverPhotoPath();
        }
    }

    // Set ServletContext (can be used to update the context after initialization)
    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
        initializeFilePaths();
        // Reload movies with the new file path
        movies.clear();
        loadMovies();
    }

    // Get the file path for a movie's cover photo
    public String getCoverPhotoFilePath(String movieId) {
        Movie movie = getMovieById(movieId);
        if (movie == null || movie.getCoverPhotoPath() == null || movie.getCoverPhotoPath().isEmpty()) {
            return null;
        }

        if (servletContext != null) {
            return servletContext.getRealPath("/WEB-INF/data") + File.separator + movie.getCoverPhotoPath();
        } else {
            return "data" + File.separator + movie.getCoverPhotoPath();
        }
    }

    // Get the images directory path
    public String getImagesDirectoryPath() {
        return imagesDirectoryPath;
    }
}