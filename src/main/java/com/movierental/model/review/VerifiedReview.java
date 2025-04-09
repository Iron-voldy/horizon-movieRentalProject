package com.movierental.model.review;

import java.util.Date;

/**
 * VerifiedReview class representing reviews submitted by users who have rented the movie
 */
public class VerifiedReview extends Review {
    private String transactionId; // ID of the rental transaction
    private Date watchDate;      // Date the movie was watched (typically return date)

    // Constructor with all fields
    public VerifiedReview(String reviewId, String movieId, String userId, String userName,
                          String comment, int rating, Date reviewDate,
                          String transactionId, Date watchDate) {
        super(reviewId, movieId, userId, userName, comment, rating, reviewDate);
        this.transactionId = transactionId;
        this.watchDate = watchDate;
    }

    // Constructor with parent fields
    public VerifiedReview(Review review, String transactionId, Date watchDate) {
        super(review.getReviewId(), review.getMovieId(), review.getUserId(),
                review.getUserName(), review.getComment(), review.getRating(),
                review.getReviewDate());
        this.transactionId = transactionId;
        this.watchDate = watchDate;
    }

    // Default constructor
    public VerifiedReview() {
        super();
        this.transactionId = "";
        this.watchDate = new Date();
    }

    // Getters and setters for additional fields
    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public Date getWatchDate() {
        return watchDate;
    }

    public void setWatchDate(Date watchDate) {
        this.watchDate = watchDate;
    }

    @Override
    public boolean isVerified() {
        return true;
    }

    @Override
    public String toFileString() {
        return "VERIFIED_REVIEW," + super.getReviewId() + "," + super.getMovieId() + "," +
                super.getUserId() + "," + super.getUserName() + "," +
                super.getComment().replace(",", "\\,") + "," + super.getRating() + "," +
                super.getReviewDate().getTime() + "," +
                transactionId + "," + watchDate.getTime();
    }

    // Create verified review from string representation (from file)
    public static VerifiedReview fromFileString(String fileString) {
        String[] parts = fileString.split(",(?=([^\\\\]|\\\\[^,])*$)"); // Split by comma, accounting for escaped commas

        if (parts.length >= 10 && parts[0].equals("VERIFIED_REVIEW")) {
            VerifiedReview review = new VerifiedReview();
            review.setReviewId(parts[1]);
            review.setMovieId(parts[2]);
            review.setUserId("null".equals(parts[3]) ? null : parts[3]);
            review.setUserName(parts[4]);
            review.setComment(parts[5].replace("\\,", ","));
            review.setRating(Integer.parseInt(parts[6]));
            review.setReviewDate(new Date(Long.parseLong(parts[7])));
            review.setTransactionId(parts[8]);
            review.setWatchDate(new Date(Long.parseLong(parts[9])));
            return review;
        }
        return null;
    }

    @Override
    public String toString() {
        return "VerifiedReview{" +
                "reviewId='" + getReviewId() + '\'' +
                ", movieId='" + getMovieId() + '\'' +
                ", userId='" + getUserId() + '\'' +
                ", userName='" + getUserName() + '\'' +
                ", comment='" + getComment() + '\'' +
                ", rating=" + getRating() +
                ", reviewDate=" + getReviewDate() +
                ", transactionId='" + transactionId + '\'' +
                ", watchDate=" + watchDate +
                '}';
    }
}