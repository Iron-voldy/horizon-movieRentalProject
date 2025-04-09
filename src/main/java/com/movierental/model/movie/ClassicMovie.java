/**
 * Step 3: Update ClassicMovie class to include cover photo path
 * File: src/main/java/com/movierental/model/movie/ClassicMovie.java
 */
package com.movierental.model.movie;

/**
 * ClassicMovie class representing classic/older movies with different pricing
 */
public class ClassicMovie extends Movie {
    private String significance; // Historical or cultural significance
    private boolean hasAwards;   // Whether the movie has won major awards

    // Constructor with all fields including cover photo
    public ClassicMovie(String movieId, String title, String director, String genre,
                        int releaseYear, double rating, boolean available,
                        String significance, boolean hasAwards, String coverPhotoPath) {
        super(movieId, title, director, genre, releaseYear, rating, available, coverPhotoPath);
        this.significance = significance;
        this.hasAwards = hasAwards;
    }

    // Constructor without cover photo
    public ClassicMovie(String movieId, String title, String director, String genre,
                        int releaseYear, double rating, boolean available,
                        String significance, boolean hasAwards) {
        super(movieId, title, director, genre, releaseYear, rating, available);
        this.significance = significance;
        this.hasAwards = hasAwards;
    }

    // Constructor without classic-specific properties
    public ClassicMovie(String movieId, String title, String director, String genre,
                        int releaseYear, double rating, boolean available) {
        super(movieId, title, director, genre, releaseYear, rating, available);
        this.significance = "Classic film";
        this.hasAwards = false;
    }

    // Default constructor
    public ClassicMovie() {
        super();
        this.significance = "";
        this.hasAwards = false;
    }

    public String getSignificance() {
        return significance;
    }

    public void setSignificance(String significance) {
        this.significance = significance;
    }

    public boolean hasAwards() {
        return hasAwards;
    }

    public void setHasAwards(boolean hasAwards) {
        this.hasAwards = hasAwards;
    }

    // Check if the movie is old enough to be considered a classic (more than 25 years)
    public boolean isClassicByAge() {
        int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
        return (currentYear - getReleaseYear()) > 25;
    }

    @Override
    public double calculateRentalPrice(int daysRented) {
        // Classics get a slight discount but with a premium for award winners
        double basePrice = 2.99 * daysRented;
        if (hasAwards) {
            basePrice += 1.00; // Extra $1 for award-winning classics
        }
        return basePrice;
    }

    @Override
    public String toFileString() {
        return "CLASSIC," + getMovieId() + "," + getTitle() + "," + getDirector() + "," +
                getGenre() + "," + getReleaseYear() + "," + getRating() + "," +
                isAvailable() + "," + significance + "," + hasAwards + "," + getCoverPhotoPath();
    }

    // Create ClassicMovie from string representation (from file)
    public static ClassicMovie fromFileString(String fileString) {
        String[] parts = fileString.split(",");
        if (parts.length >= 10 && parts[0].equals("CLASSIC")) {
            ClassicMovie movie = new ClassicMovie();
            movie.setMovieId(parts[1]);
            movie.setTitle(parts[2]);
            movie.setDirector(parts[3]);
            movie.setGenre(parts[4]);
            movie.setReleaseYear(Integer.parseInt(parts[5]));
            movie.setRating(Double.parseDouble(parts[6]));
            movie.setAvailable(Boolean.parseBoolean(parts[7]));
            movie.setSignificance(parts[8]);
            movie.setHasAwards(Boolean.parseBoolean(parts[9]));

            // Handle cover photo path if available
            if (parts.length > 10) {
                movie.setCoverPhotoPath(parts[10]);
            }

            return movie;
        }
        return null;
    }
}