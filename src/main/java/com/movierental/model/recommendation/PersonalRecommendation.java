package com.movierental.model.recommendation;

import java.util.Date;

/**
 * PersonalRecommendation class representing personalized recommendations for a specific user
 */
public class PersonalRecommendation extends Recommendation {
    private String baseSource;      // Source of the recommendation (e.g., "watch history", "similar genre")
    private double relevanceScore;  // How relevant the recommendation is to the user (0-1)

    // Constructor with all fields
    public PersonalRecommendation(String recommendationId, String movieId, String userId,
                                  Date generatedDate, double score, String reason,
                                  String baseSource, double relevanceScore) {
        super(recommendationId, movieId, userId, generatedDate, score, reason);
        this.baseSource = baseSource;
        this.relevanceScore = relevanceScore;
    }

    // Constructor with parent fields
    public PersonalRecommendation(Recommendation recommendation, String baseSource, double relevanceScore) {
        super(recommendation.getRecommendationId(), recommendation.getMovieId(), recommendation.getUserId(),
                recommendation.getGeneratedDate(), recommendation.getScore(), recommendation.getReason());
        this.baseSource = baseSource;
        this.relevanceScore = relevanceScore;
    }

    // Default constructor
    public PersonalRecommendation() {
        super();
        this.baseSource = "";
        this.relevanceScore = 0.0;
    }

    // Getters and setters for additional fields
    public String getBaseSource() {
        return baseSource;
    }

    public void setBaseSource(String baseSource) {
        this.baseSource = baseSource;
    }

    public double getRelevanceScore() {
        return relevanceScore;
    }

    public void setRelevanceScore(double relevanceScore) {
        this.relevanceScore = relevanceScore;
    }

    @Override
    public boolean isPersonalized() {
        return true;
    }

    @Override
    public String toFileString() {
        return "PERSONAL_RECOMMENDATION," + super.getRecommendationId() + "," + super.getMovieId() + "," +
                super.getUserId() + "," + super.getGeneratedDate().getTime() + "," +
                super.getScore() + "," + super.getReason().replace(",", "\\,") + "," +
                baseSource + "," + relevanceScore;
    }

    // Create personal recommendation from string representation (from file)
    public static PersonalRecommendation fromFileString(String fileString) {
        String[] parts = fileString.split(",(?=([^\\\\]|\\\\[^,])*$)"); // Split by comma, accounting for escaped commas

        if (parts.length >= 9 && parts[0].equals("PERSONAL_RECOMMENDATION")) {
            PersonalRecommendation recommendation = new PersonalRecommendation();
            recommendation.setRecommendationId(parts[1]);
            recommendation.setMovieId(parts[2]);
            recommendation.setUserId("null".equals(parts[3]) ? null : parts[3]);
            recommendation.setGeneratedDate(new Date(Long.parseLong(parts[4])));
            recommendation.setScore(Double.parseDouble(parts[5]));
            recommendation.setReason(parts[6].replace("\\,", ","));
            recommendation.setBaseSource(parts[7]);
            recommendation.setRelevanceScore(Double.parseDouble(parts[8]));
            return recommendation;
        }
        return null;
    }

    @Override
    public String toString() {
        return "PersonalRecommendation{" +
                "recommendationId='" + getRecommendationId() + '\'' +
                ", movieId='" + getMovieId() + '\'' +
                ", userId='" + getUserId() + '\'' +
                ", generatedDate=" + getGeneratedDate() +
                ", score=" + getScore() +
                ", reason='" + getReason() + '\'' +
                ", baseSource='" + baseSource + '\'' +
                ", relevanceScore=" + relevanceScore +
                '}';
    }
}