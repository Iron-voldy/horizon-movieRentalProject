package com.movierental.model.review;

import java.io.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletContext;

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;
import com.movierental.model.rental.RentalManager;
import com.movierental.model.rental.Transaction;

/**
 * ReviewManager class handles all review-related operations
 */
public class ReviewManager {
    private static final String REVIEW_FILE_NAME = "reviews.txt";
    private List<Review> reviews;
    private ServletContext servletContext;
    private String dataFilePath;

    // Constructor without ServletContext (for backward compatibility)
    public ReviewManager() {
        this(null);
    }

    // Constructor with ServletContext
    public ReviewManager(ServletContext servletContext) {
        this.servletContext = servletContext;
        reviews = new ArrayList<>();
        initializeFilePath();
        loadReviews();
    }

    // Initialize file path based on ServletContext
    private void initializeFilePath() {
        if (servletContext != null) {
            // Use WEB-INF/data within the application context
            String webInfDataPath = "/WEB-INF/data";
            dataFilePath = servletContext.getRealPath(webInfDataPath) + File.separator + REVIEW_FILE_NAME;

            // Make sure directory exists
            File dataDir = new File(servletContext.getRealPath(webInfDataPath));
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created WEB-INF/data directory: " + dataDir.getAbsolutePath() + " - Success: " + created);
            }
        } else {
            // Fallback to simple data directory if not in web context
            String dataPath = "data";
            dataFilePath = dataPath + File.separator + REVIEW_FILE_NAME;

            // Make sure directory exists
            File dataDir = new File(dataPath);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created fallback data directory: " + dataPath + " - Success: " + created);
            }
        }

        System.out.println("ReviewManager: Using data file path: " + dataFilePath);
    }

    // Load reviews from file
    private void loadReviews() {
        File file = new File(dataFilePath);

        // Create directory if it doesn't exist
        if (file.getParentFile() != null && !file.getParentFile().exists()) {
            boolean created = file.getParentFile().mkdirs();
            System.out.println("Created directory for reviews: " + file.getParentFile().getAbsolutePath() + " - Success: " + created);
        }

        // Create file if it doesn't exist
        if (!file.exists()) {
            try {
                boolean created = file.createNewFile();
                System.out.println("Created reviews file: " + dataFilePath + " - Success: " + created);
            } catch (IOException e) {
                System.err.println("Error creating reviews file: " + e.getMessage());
                e.printStackTrace();
            }
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue;
                }

                Review review = null;
                if (line.startsWith("VERIFIED_REVIEW,")) {
                    review = VerifiedReview.fromFileString(line);
                } else if (line.startsWith("GUEST_REVIEW,")) {
                    review = GuestReview.fromFileString(line);
                } else if (line.startsWith("REVIEW,")) {
                    review = Review.fromFileString(line);
                }

                if (review != null) {
                    reviews.add(review);
                    System.out.println("Loaded review: " + review.getReviewId());
                }
            }
            System.out.println("Total reviews loaded: " + reviews.size());
        } catch (IOException e) {
            System.err.println("Error loading reviews: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Save reviews to file
    private void saveReviews() {
        try {
            // Ensure parent directory exists
            File file = new File(dataFilePath);
            if (file.getParentFile() != null && !file.getParentFile().exists()) {
                boolean created = file.getParentFile().mkdirs();
                System.out.println("Created directory for reviews: " + file.getParentFile().getAbsolutePath() + " - Success: " + created);
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(dataFilePath))) {
                for (Review review : reviews) {
                    writer.write(review.toFileString());
                    writer.newLine();
                }
            }
            System.out.println("Reviews saved successfully to: " + dataFilePath);
        } catch (IOException e) {
            System.err.println("Error saving reviews: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Add a regular review (from a logged-in user who may not have rented the movie)
    public Review addRegularReview(String userId, String userName, String movieId, String comment, int rating) {
        // Check if user has already reviewed this movie
        for (Review existingReview : reviews) {
            if (existingReview.getMovieId().equals(movieId) &&
                    userId.equals(existingReview.getUserId())) {
                return null; // User already reviewed this movie
            }
        }

        // Create the review
        Review review = new Review();
        review.setReviewId(UUID.randomUUID().toString());
        review.setUserId(userId);
        review.setUserName(userName);
        review.setMovieId(movieId);
        review.setComment(comment);
        review.setRating(validateRating(rating));
        review.setReviewDate(new Date());

        // Add to the list and save
        reviews.add(review);
        saveReviews();

        // Update movie rating
        updateMovieRating(movieId);

        return review;
    }

    // Add a verified review (from a user who rented the movie)
    public VerifiedReview addVerifiedReview(String userId, String userName, String movieId,
                                            String transactionId, String comment, int rating) {
        // Check if user has already reviewed this movie
        for (Review existingReview : reviews) {
            if (existingReview.getMovieId().equals(movieId) &&
                    userId.equals(existingReview.getUserId())) {
                return null; // User already reviewed this movie
            }
        }

        // Check if the transaction exists and is valid for review
        RentalManager rentalManager = new RentalManager(servletContext);
        Transaction transaction = rentalManager.getTransactionById(transactionId);

        if (transaction == null || !transaction.isReturned() ||
                !transaction.getUserId().equals(userId) ||
                !transaction.getMovieId().equals(movieId)) {
            return null; // Invalid transaction
        }

        // Create the verified review
        VerifiedReview review = new VerifiedReview();
        review.setReviewId(UUID.randomUUID().toString());
        review.setUserId(userId);
        review.setUserName(userName);
        review.setMovieId(movieId);
        review.setComment(comment);
        review.setRating(validateRating(rating));
        review.setReviewDate(new Date());
        review.setTransactionId(transactionId);
        review.setWatchDate(transaction.getReturnDate());

        // Add to the list and save
        reviews.add(review);
        saveReviews();

        // Update movie rating
        updateMovieRating(movieId);

        return review;
    }

    // Add a guest review
    public GuestReview addGuestReview(String guestName, String movieId, String comment,
                                      int rating, String emailAddress, String ipAddress) {
        GuestReview review = new GuestReview();
        review.setReviewId(UUID.randomUUID().toString());
        review.setUserName(guestName);
        review.setMovieId(movieId);
        review.setComment(comment);
        review.setRating(validateRating(rating));
        review.setReviewDate(new Date());
        review.setEmailAddress(emailAddress);
        review.setIpAddress(ipAddress);

        // Add to the list and save
        reviews.add(review);
        saveReviews();

        // Update movie rating
        updateMovieRating(movieId);

        return review;
    }

    // Update an existing review
    public boolean updateReview(String reviewId, String userId, String comment, int rating) {
        for (int i = 0; i < reviews.size(); i++) {
            Review review = reviews.get(i);

            if (review.getReviewId().equals(reviewId)) {
                // Check if the review belongs to the user
                if (userId != null && !userId.equals(review.getUserId())) {
                    return false; // Not the review owner
                }

                // Update the review
                review.setComment(comment);
                review.setRating(validateRating(rating));

                // Save changes
                saveReviews();

                // Update movie rating
                updateMovieRating(review.getMovieId());

                return true;
            }
        }

        return false; // Review not found
    }

    // Delete a review
    public boolean deleteReview(String reviewId, String userId) {
        for (int i = 0; i < reviews.size(); i++) {
            Review review = reviews.get(i);

            if (review.getReviewId().equals(reviewId)) {
                // Check if the review belongs to the user or if userId is null (admin)
                if (userId != null && !userId.equals(review.getUserId())) {
                    return false; // Not the review owner or admin
                }

                // Store the movie ID before removing the review
                String movieId = review.getMovieId();

                // Remove the review
                reviews.remove(i);
                saveReviews();

                // Update movie rating
                updateMovieRating(movieId);

                return true;
            }
        }

        return false; // Review not found
    }

    // Get a review by ID
    public Review getReviewById(String reviewId) {
        for (Review review : reviews) {
            if (review.getReviewId().equals(reviewId)) {
                return review;
            }
        }
        return null;
    }

    // Get all reviews for a movie
    public List<Review> getReviewsByMovie(String movieId) {
        List<Review> movieReviews = new ArrayList<>();

        for (Review review : reviews) {
            if (review.getMovieId().equals(movieId)) {
                movieReviews.add(review);
            }
        }

        // Sort by date, newest first
        Collections.sort(movieReviews, new Comparator<Review>() {
            @Override
            public int compare(Review r1, Review r2) {
                return r2.getReviewDate().compareTo(r1.getReviewDate());
            }
        });

        return movieReviews;
    }

    // Get all reviews by a user
    public List<Review> getReviewsByUser(String userId) {
        List<Review> userReviews = new ArrayList<>();

        for (Review review : reviews) {
            if (userId.equals(review.getUserId())) {
                userReviews.add(review);
            }
        }

        // Sort by date, newest first
        Collections.sort(userReviews, new Comparator<Review>() {
            @Override
            public int compare(Review r1, Review r2) {
                return r2.getReviewDate().compareTo(r1.getReviewDate());
            }
        });

        return userReviews;
    }

    // Check if a user has reviewed a movie
    public boolean hasUserReviewedMovie(String userId, String movieId) {
        for (Review review : reviews) {
            if (review.getMovieId().equals(movieId) &&
                    userId.equals(review.getUserId())) {
                return true;
            }
        }
        return false;
    }

    // Get a user's review for a specific movie
    public Review getUserReviewForMovie(String userId, String movieId) {
        for (Review review : reviews) {
            if (review.getMovieId().equals(movieId) &&
                    userId.equals(review.getUserId())) {
                return review;
            }
        }
        return null;
    }

    // Calculate average rating for a movie
    public double calculateAverageRating(String movieId) {
        List<Review> movieReviews = getReviewsByMovie(movieId);

        if (movieReviews.isEmpty()) {
            return 0.0;
        }

        int totalRating = 0;
        for (Review review : movieReviews) {
            totalRating += review.getRating();
        }

        return (double) totalRating / movieReviews.size();
    }

    // Count verified reviews for a movie
    public int countVerifiedReviews(String movieId) {
        int count = 0;

        for (Review review : reviews) {
            if (review.getMovieId().equals(movieId) && review.isVerified()) {
                count++;
            }
        }

        return count;
    }

    // Count guest reviews for a movie
    public int countGuestReviews(String movieId) {
        int count = 0;

        for (Review review : reviews) {
            if (review.getMovieId().equals(movieId) && !review.isVerified()) {
                count++;
            }
        }

        return count;
    }

    // Get rating distribution for a movie
    public Map<Integer, Integer> getRatingDistribution(String movieId) {
        Map<Integer, Integer> distribution = new HashMap<>();

        // Initialize with all possible ratings
        for (int i = 1; i <= 5; i++) {
            distribution.put(i, 0);
        }

        // Count ratings
        for (Review review : reviews) {
            if (review.getMovieId().equals(movieId)) {
                int rating = review.getRating();
                distribution.put(rating, distribution.get(rating) + 1);
            }
        }

        return distribution;
    }

    // Get all reviews
    public List<Review> getAllReviews() {
        return new ArrayList<>(reviews);
    }

    // Get recent reviews
    public List<Review> getRecentReviews(int count) {
        List<Review> allReviews = new ArrayList<>(reviews);

        // Sort by date, newest first
        Collections.sort(allReviews, new Comparator<Review>() {
            @Override
            public int compare(Review r1, Review r2) {
                return r2.getReviewDate().compareTo(r1.getReviewDate());
            }
        });

        // Take only the requested number
        int limit = Math.min(count, allReviews.size());
        return allReviews.subList(0, limit);
    }

    // Update the movie's rating in the database
    private void updateMovieRating(String movieId) {
        double averageRating = calculateAverageRating(movieId);

        // Round to one decimal place
        averageRating = Math.round(averageRating * 10.0) / 10.0;

        // Update movie rating
        MovieManager movieManager = new MovieManager(servletContext);
        Movie movie = movieManager.getMovieById(movieId);

        if (movie != null) {
            movie.setRating(averageRating);
            movieManager.updateMovie(movie);
        }
    }

    // Ensure rating is within valid range (1-5)
    private int validateRating(int rating) {
        if (rating < 1) {
            return 1;
        } else if (rating > 5) {
            return 5;
        }
        return rating;
    }

    // Set ServletContext (can be used to update the context after initialization)
    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
        initializeFilePath();
        // Reload reviews with the new file path
        reviews.clear();
        loadReviews();
    }
}