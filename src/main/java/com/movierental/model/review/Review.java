package com.movierental.model.review;

import java.util.Date;

/**
 * Base Review class representing common review attributes and behaviors
 */
public class Review {
    private String reviewId;
    private String movieId;
    private String userId;  // null for guest reviews
    private String userName;
    private String comment;
    private int rating;     // 1-5 star rating
    private Date reviewDate;

    // Constructor with all fields
    public Review(String reviewId, String movieId, String userId, String userName,
                  String comment, int rating, Date reviewDate) {
        this.reviewId = reviewId;
        this.movieId = movieId;
        this.userId = userId;
        this.userName = userName;
        this.comment = comment;
        this.rating = rating;
        this.reviewDate = reviewDate;
    }

    // Default constructor
    public Review() {
        this.reviewId = "";
        this.movieId = "";
        this.userId = null;
        this.userName = "";
        this.comment = "";
        this.rating = 0;
        this.reviewDate = new Date();
    }

    // Getters and setters
    public String getReviewId() {
        return reviewId;
    }

    public void setReviewId(String reviewId) {
        this.reviewId = reviewId;
    }

    public String getMovieId() {
        return movieId;
    }

    public void setMovieId(String movieId) {
        this.movieId = movieId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public Date getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Date reviewDate) {
        this.reviewDate = reviewDate;
    }

    // Check if this is a verified review
    public boolean isVerified() {
        return false; // Base review is not verified, will be overridden by subclasses
    }

    // Convert review to string representation for file storage
    public String toFileString() {
        return "REVIEW," + reviewId + "," + movieId + "," +
                (userId != null ? userId : "null") + "," + userName + "," +
                comment.replace(",", "\\,") + "," + rating + "," + reviewDate.getTime();
    }

    // Create review from string representation (from file)
    public static Review fromFileString(String fileString) {
        String[] parts = fileString.split(",(?=([^\\\\]|\\\\[^,])*$)"); // Split by comma, accounting for escaped commas

        if (parts.length >= 8 && parts[0].equals("REVIEW")) {
            Review review = new Review();
            review.setReviewId(parts[1]);
            review.setMovieId(parts[2]);
            review.setUserId("null".equals(parts[3]) ? null : parts[3]);
            review.setUserName(parts[4]);
            review.setComment(parts[5].replace("\\,", ","));
            review.setRating(Integer.parseInt(parts[6]));
            review.setReviewDate(new Date(Long.parseLong(parts[7])));
            return review;
        }
        return null;
    }

    @Override
    public String toString() {
        return "Review{" +
                "reviewId='" + reviewId + '\'' +
                ", movieId='" + movieId + '\'' +
                ", userId='" + userId + '\'' +
                ", userName='" + userName + '\'' +
                ", comment='" + comment + '\'' +
                ", rating=" + rating +
                ", reviewDate=" + reviewDate +
                '}';
    }
}