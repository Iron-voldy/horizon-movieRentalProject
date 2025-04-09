package com.movierental.model.review;

import java.util.Date;

/**
 * GuestReview class representing reviews submitted by guests without an account
 */
public class GuestReview extends Review {
    private String emailAddress;  // Optional email address for guest reviewer
    private String ipAddress;     // IP address of the guest reviewer

    // Constructor with all fields
    public GuestReview(String reviewId, String movieId, String userName,
                       String comment, int rating, Date reviewDate,
                       String emailAddress, String ipAddress) {
        super(reviewId, movieId, null, userName, comment, rating, reviewDate);
        this.emailAddress = emailAddress;
        this.ipAddress = ipAddress;
    }

    // Constructor with parent fields
    public GuestReview(Review review, String emailAddress, String ipAddress) {
        super(review.getReviewId(), review.getMovieId(), null,
                review.getUserName(), review.getComment(), review.getRating(),
                review.getReviewDate());
        this.emailAddress = emailAddress;
        this.ipAddress = ipAddress;
    }

    // Default constructor
    public GuestReview() {
        super();
        setUserId(null); // Guest reviews have no user ID
        this.emailAddress = "";
        this.ipAddress = "";
    }

    // Getters and setters for additional fields
    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    @Override
    public boolean isVerified() {
        return false;
    }

    @Override
    public String toFileString() {
        return "GUEST_REVIEW," + super.getReviewId() + "," + super.getMovieId() + "," +
                "null," + super.getUserName() + "," +
                super.getComment().replace(",", "\\,") + "," + super.getRating() + "," +
                super.getReviewDate().getTime() + "," +
                emailAddress + "," + ipAddress;
    }

    // Create guest review from string representation (from file)
    public static GuestReview fromFileString(String fileString) {
        String[] parts = fileString.split(",(?=([^\\\\]|\\\\[^,])*$)"); // Split by comma, accounting for escaped commas

        if (parts.length >= 9 && parts[0].equals("GUEST_REVIEW")) {
            GuestReview review = new GuestReview();
            review.setReviewId(parts[1]);
            review.setMovieId(parts[2]);
            // parts[3] should be "null" for guest reviews
            review.setUserName(parts[4]);
            review.setComment(parts[5].replace("\\,", ","));
            review.setRating(Integer.parseInt(parts[6]));
            review.setReviewDate(new Date(Long.parseLong(parts[7])));
            review.setEmailAddress(parts[8]);
            if (parts.length > 9) {
                review.setIpAddress(parts[9]);
            }
            return review;
        }
        return null;
    }

    @Override
    public String toString() {
        return "GuestReview{" +
                "reviewId='" + getReviewId() + '\'' +
                ", movieId='" + getMovieId() + '\'' +
                ", userName='" + getUserName() + '\'' +
                ", comment='" + getComment() + '\'' +
                ", rating=" + getRating() +
                ", reviewDate=" + getReviewDate() +
                ", emailAddress='" + emailAddress + '\'' +
                ", ipAddress='" + ipAddress + '\'' +
                '}';
    }
}