package com.movierental.model.recommendation;

import java.util.Date;

/**
 * GeneralRecommendation class representing non-personalized, general recommendations
 */
public class GeneralRecommendation extends Recommendation {
    private String category;      // Category of recommendation (e.g., "top-rated", "trending")
    private int rank;             // Ranking within the category

    // Constructor with all fields
    public GeneralRecommendation(String recommendationId, String movieId,
                                 Date generatedDate, double score, String reason,
                                 String category, int rank) {
        super(recommendationId, movieId, null, generatedDate, score, reason);
        this.category = category;
        this.rank = rank;
    }

    // Constructor with parent fields
    public GeneralRecommendation(Recommendation recommendation, String category, int rank) {
        super(recommendation.getRecommendationId(), recommendation.getMovieId(), null,
                recommendation.getGeneratedDate(), recommendation.getScore(), recommendation.getReason());
        this.category = category;
        this.rank = rank;
    }

    // Default constructor
    public GeneralRecommendation() {
        super();
        this.category = "";
        this.rank = 0;
    }

    // Getters and setters for additional fields
    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getRank() {
        return rank;
    }

    public void setRank(int rank) {
        this.rank = rank;
    }

    @Override
    public boolean isPersonalized() {
        return false;
    }

    @Override
    public String toFileString() {
        return "GENERAL_RECOMMENDATION," + super.getRecommendationId() + "," + super.getMovieId() + "," +
                "null," + super.getGeneratedDate().getTime() + "," +
                super.getScore() + "," + super.getReason().replace(",", "\\,") + "," +
                category + "," + rank;
    }

    // Create general recommendation from string representation (from file)
    public static GeneralRecommendation fromFileString(String fileString) {
        String[] parts = fileString.split(",(?=([^\\\\]|\\\\[^,])*$)"); // Split by comma, accounting for escaped commas

        if (parts.length >= 9 && parts[0].equals("GENERAL_RECOMMENDATION")) {
            GeneralRecommendation recommendation = new GeneralRecommendation();
            recommendation.setRecommendationId(parts[1]);
            recommendation.setMovieId(parts[2]);
            // parts[3] should be "null" for general recommendations
            recommendation.setGeneratedDate(new Date(Long.parseLong(parts[4])));
            recommendation.setScore(Double.parseDouble(parts[5]));
            recommendation.setReason(parts[6].replace("\\,", ","));
            recommendation.setCategory(parts[7]);
            recommendation.setRank(Integer.parseInt(parts[8]));
            return recommendation;
        }
        return null;
    }

    @Override
    public String toString() {
        return "GeneralRecommendation{" +
                "recommendationId='" + getRecommendationId() + '\'' +
                ", movieId='" + getMovieId() + '\'' +
                ", generatedDate=" + getGeneratedDate() +
                ", score=" + getScore() +
                ", reason='" + getReason() + '\'' +
                ", category='" + category + '\'' +
                ", rank=" + rank +
                '}';
    }
}