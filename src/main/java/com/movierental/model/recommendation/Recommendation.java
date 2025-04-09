package com.movierental.model.recommendation;

import java.util.Date;

/**
 * Base Recommendation class representing common recommendation attributes and behaviors
 */
public class Recommendation {
    private String recommendationId;
    private String movieId;
    private String userId;    // null for general recommendations
    private Date generatedDate;
    private double score;     // recommendation score/strength
    private String reason;    // reason for recommendation

    // Constructor with all fields
    public Recommendation(String recommendationId, String movieId, String userId,
                          Date generatedDate, double score, String reason) {
        this.recommendationId = recommendationId;
        this.movieId = movieId;
        this.userId = userId;
        this.generatedDate = generatedDate;
        this.score = score;
        this.reason = reason;
    }

    // Default constructor
    public Recommendation() {
        this.recommendationId = "";
        this.movieId = "";
        this.userId = null;
        this.generatedDate = new Date();
        this.score = 0.0;
        this.reason = "";
    }

    // Getters and setters
    public String getRecommendationId() {
        return recommendationId;
    }

    public void setRecommendationId(String recommendationId) {
        this.recommendationId = recommendationId;
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

    public Date getGeneratedDate() {
        return generatedDate;
    }

    public void setGeneratedDate(Date generatedDate) {
        this.generatedDate = generatedDate;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    // Check if this is a personalized recommendation
    public boolean isPersonalized() {
        return false; // Base recommendation is not personalized
    }

    // Convert to file string for storage
    public String toFileString() {
        return "RECOMMENDATION," + recommendationId + "," + movieId + "," +
                (userId != null ? userId : "null") + "," + generatedDate.getTime() + "," +
                score + "," + reason.replace(",", "\\,");
    }

    // Create recommendation from file string
    public static Recommendation fromFileString(String fileString) {
        String[] parts = fileString.split(",(?=([^\\\\]|\\\\[^,])*$)"); // Split by comma, accounting for escaped commas

        if (parts.length >= 7 && parts[0].equals("RECOMMENDATION")) {
            Recommendation recommendation = new Recommendation();
            recommendation.setRecommendationId(parts[1]);
            recommendation.setMovieId(parts[2]);
            recommendation.setUserId("null".equals(parts[3]) ? null : parts[3]);
            recommendation.setGeneratedDate(new Date(Long.parseLong(parts[4])));
            recommendation.setScore(Double.parseDouble(parts[5]));
            recommendation.setReason(parts[6].replace("\\,", ","));
            return recommendation;
        }
        return null;
    }

    @Override
    public String toString() {
        return "Recommendation{" +
                "recommendationId='" + recommendationId + '\'' +
                ", movieId='" + movieId + '\'' +
                ", userId='" + userId + '\'' +
                ", generatedDate=" + generatedDate +
                ", score=" + score +
                ", reason='" + reason + '\'' +
                '}';
    }
}