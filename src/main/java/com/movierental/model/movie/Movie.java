/**
 * Step 1: Update Movie class to include cover photo path
 * File: src/main/java/com/movierental/model/movie/Movie.java
 */
package com.movierental.model.movie;

public class Movie {
    private String movieId;
    private String title;
    private String director;
    private String genre;
    private int releaseYear;
    private double rating;
    private boolean available;
    private String coverPhotoPath; // New field for cover photo

    // Constructor with all fields including cover photo
    public Movie(String movieId, String title, String director, String genre, int releaseYear,
                 double rating, boolean available, String coverPhotoPath) {
        this.movieId = movieId;
        this.title = title;
        this.director = director;
        this.genre = genre;
        this.releaseYear = releaseYear;
        this.rating = rating;
        this.available = available;
        this.coverPhotoPath = coverPhotoPath;
    }

    // Constructor without cover photo (set default empty path)
    public Movie(String movieId, String title, String director, String genre, int releaseYear,
                 double rating, boolean available) {
        this(movieId, title, director, genre, releaseYear, rating, available, "");
    }

    // Default constructor
    public Movie() {
        this.movieId = "";
        this.title = "";
        this.director = "";
        this.genre = "";
        this.releaseYear = 0;
        this.rating = 0.0;
        this.available = true;
        this.coverPhotoPath = "";
    }

    // Getters and setters (existing ones unchanged)
    public String getMovieId() {
        return movieId;
    }

    public void setMovieId(String movieId) {
        this.movieId = movieId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public int getReleaseYear() {
        return releaseYear;
    }

    public void setReleaseYear(int releaseYear) {
        this.releaseYear = releaseYear;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    // New getter and setter for coverPhotoPath
    public String getCoverPhotoPath() {
        return coverPhotoPath;
    }

    public void setCoverPhotoPath(String coverPhotoPath) {
        this.coverPhotoPath = coverPhotoPath;
    }

    // Calculate rental price (to be overridden by subclasses)
    public double calculateRentalPrice(int daysRented) {
        return 3.99 * daysRented; // Base rental price
    }

    // Update toFileString to include cover photo path
    public String toFileString() {
        return "REGULAR," + movieId + "," + title + "," + director + "," +
                genre + "," + releaseYear + "," + rating + "," + available + "," + coverPhotoPath;
    }

    // Update fromFileString to handle cover photo path
    public static Movie fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 9) { // Updated to check for at least 9 parts
            Movie movie = new Movie();
            movie.setMovieId(parts[1]);
            movie.setTitle(parts[2]);
            movie.setDirector(parts[3]);
            movie.setGenre(parts[4]);
            movie.setReleaseYear(Integer.parseInt(parts[5]));
            movie.setRating(Double.parseDouble(parts[6]));
            movie.setAvailable(Boolean.parseBoolean(parts[7]));
            movie.setCoverPhotoPath(parts[8]); // Add cover photo path
            return movie;
        }
        return null;
    }

    @Override
    public String toString() {
        return "Movie{" +
                "movieId='" + movieId + '\'' +
                ", title='" + title + '\'' +
                ", director='" + director + '\'' +
                ", genre='" + genre + '\'' +
                ", releaseYear=" + releaseYear +
                ", rating=" + rating +
                ", available=" + available +
                ", coverPhotoPath='" + coverPhotoPath + '\'' +
                '}';
    }
}