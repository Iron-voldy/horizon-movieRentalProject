/**
 * Step 4: Update NewRelease class to include cover photo path
 * File: src/main/java/com/movierental/model/movie/NewRelease.java
 */
package com.movierental.model.movie;

import java.util.Date;

/**
 * NewRelease class representing new movies with premium pricing
 */
public class NewRelease extends Movie {
    private Date releaseDate;

    // Constructor with all fields including cover photo
    public NewRelease(String movieId, String title, String director, String genre,
                      int releaseYear, double rating, boolean available, Date releaseDate,
                      String coverPhotoPath) {
        super(movieId, title, director, genre, releaseYear, rating, available, coverPhotoPath);
        this.releaseDate = releaseDate;
    }

    // Constructor with all fields without cover photo
    public NewRelease(String movieId, String title, String director, String genre,
                      int releaseYear, double rating, boolean available, Date releaseDate) {
        super(movieId, title, director, genre, releaseYear, rating, available);
        this.releaseDate = releaseDate;
    }

    // Constructor without release date
    public NewRelease(String movieId, String title, String director, String genre,
                      int releaseYear, double rating, boolean available) {
        super(movieId, title, director, genre, releaseYear, rating, available);
        this.releaseDate = new Date(); // Default to current date
    }

    // Default constructor
    public NewRelease() {
        super();
        this.releaseDate = new Date();
    }

    public Date getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(Date releaseDate) {
        this.releaseDate = releaseDate;
    }

    // Check if the movie is still considered a new release (less than 3 months old)
    public boolean isStillNewRelease() {
        long diffInMillies = new Date().getTime() - releaseDate.getTime();
        long diffInDays = diffInMillies / (1000 * 60 * 60 * 24);
        return diffInDays < 90; // 3 months = ~90 days
    }

    @Override
    public double calculateRentalPrice(int daysRented) {
        // New releases cost more
        return 5.99 * daysRented;
    }

    @Override
    public String toFileString() {
        return "NEW_RELEASE," + getMovieId() + "," + getTitle() + "," + getDirector() + "," +
                getGenre() + "," + getReleaseYear() + "," + getRating() + "," +
                isAvailable() + "," + releaseDate.getTime() + "," + getCoverPhotoPath();
    }

    // Create NewRelease from string representation (from file)
    public static NewRelease fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 9 && parts[0].equals("NEW_RELEASE")) {
            NewRelease movie = new NewRelease();
            movie.setMovieId(parts[1]);
            movie.setTitle(parts[2]);
            movie.setDirector(parts[3]);
            movie.setGenre(parts[4]);
            movie.setReleaseYear(Integer.parseInt(parts[5]));
            movie.setRating(Double.parseDouble(parts[6]));
            movie.setAvailable(Boolean.parseBoolean(parts[7]));
            movie.setReleaseDate(new Date(Long.parseLong(parts[8])));

            // Handle cover photo path if available
            if (parts.length > 9) {
                movie.setCoverPhotoPath(parts[9]);
            }

            return movie;
        }
        return null;
    }
}