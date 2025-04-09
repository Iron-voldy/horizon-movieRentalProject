package com.movierental.model.recommendation;

import java.io.*;
import java.util.*;

import javax.servlet.ServletContext;

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;
import com.movierental.model.rental.RentalManager;
import com.movierental.model.rental.Transaction;
import com.movierental.model.review.Review;
import com.movierental.model.review.ReviewManager;
import com.movierental.model.watchlist.WatchlistManager;
import com.movierental.model.watchlist.Watchlist;
import com.movierental.model.watchlist.RecentlyWatched;

/**
 * RecommendationManager class handles all recommendation-related operations
 */
public class RecommendationManager {
    private static final String RECOMMENDATION_FILE_NAME = "recommendations.txt";
    private List<Recommendation> recommendations;
    private MovieManager movieManager;
    private ReviewManager reviewManager;
    private RentalManager rentalManager;
    private WatchlistManager watchlistManager;
    private ServletContext servletContext;
    private String dataFilePath;

    // Constructor
    public RecommendationManager() {
        this(null);
    }

    // Constructor with ServletContext
    public RecommendationManager(ServletContext servletContext) {
        this.servletContext = servletContext;
        recommendations = new ArrayList<>();
        initializeFilePath();
        loadRecommendations();

        // Initialize other managers with the same ServletContext
        movieManager = new MovieManager(servletContext);
        reviewManager = new ReviewManager(servletContext);
        rentalManager = new RentalManager(servletContext);
        watchlistManager = new WatchlistManager(servletContext);
    }

    // Initialize the file path
    private void initializeFilePath() {
        if (servletContext != null) {
            // Use WEB-INF/data within the application context
            String webInfDataPath = "/WEB-INF/data";
            dataFilePath = servletContext.getRealPath(webInfDataPath) + File.separator + RECOMMENDATION_FILE_NAME;

            // Make sure directory exists
            File dataDir = new File(servletContext.getRealPath(webInfDataPath));
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created WEB-INF/data directory: " + dataDir.getAbsolutePath() + " - Success: " + created);
            }
        } else {
            // Fallback to simple data directory if not in web context
            String dataPath = "data";
            dataFilePath = dataPath + File.separator + RECOMMENDATION_FILE_NAME;

            // Make sure directory exists
            File dataDir = new File(dataPath);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created fallback data directory: " + dataPath + " - Success: " + created);
            }
        }

        System.out.println("RecommendationManager: Using data file path: " + dataFilePath);

        // Ensure the file exists
        try {
            File file = new File(dataFilePath);
            if (!file.exists()) {
                file.createNewFile();
                System.out.println("Created new recommendations file: " + dataFilePath);
            }
        } catch (IOException e) {
            System.err.println("Error creating recommendations file: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Load recommendations from file
    private void loadRecommendations() {
        File file = new File(dataFilePath);

        if (!file.exists()) {
            try {
                // Create parent directories if they don't exist
                if (file.getParentFile() != null) {
                    file.getParentFile().mkdirs();
                }
                file.createNewFile();
                System.out.println("Created new recommendations file: " + dataFilePath);
            } catch (IOException e) {
                System.err.println("Error creating recommendations file: " + e.getMessage());
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

                Recommendation recommendation = null;
                if (line.startsWith("PERSONAL_RECOMMENDATION,")) {
                    recommendation = PersonalRecommendation.fromFileString(line);
                } else if (line.startsWith("GENERAL_RECOMMENDATION,")) {
                    recommendation = GeneralRecommendation.fromFileString(line);
                } else if (line.startsWith("RECOMMENDATION,")) {
                    recommendation = Recommendation.fromFileString(line);
                }

                if (recommendation != null) {
                    recommendations.add(recommendation);
                }
            }
            System.out.println("Loaded " + recommendations.size() + " recommendations from " + dataFilePath);
        } catch (IOException e) {
            System.err.println("Error loading recommendations: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Save recommendations to file
    private void saveRecommendations() {
        try {
            // Ensure parent directory exists
            File file = new File(dataFilePath);
            if (file.getParentFile() != null && !file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(dataFilePath))) {
                for (Recommendation recommendation : recommendations) {
                    writer.write(recommendation.toFileString());
                    writer.newLine();
                }
            }
            System.out.println("Saved " + recommendations.size() + " recommendations to " + dataFilePath);
        } catch (IOException e) {
            System.err.println("Error saving recommendations: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Generate general recommendations
    public List<GeneralRecommendation> generateGeneralRecommendations() {
        // Clear existing general recommendations
        recommendations.removeIf(rec -> !rec.isPersonalized());

        List<GeneralRecommendation> generalRecommendations = new ArrayList<>();

        // Generate top-rated recommendations
        List<Movie> topRatedMovies = movieManager.getTopRatedMovies(20); // Get top 20 rated movies

        int rank = 1;
        for (Movie movie : topRatedMovies) {
            GeneralRecommendation recommendation = new GeneralRecommendation();
            recommendation.setRecommendationId(UUID.randomUUID().toString());
            recommendation.setMovieId(movie.getMovieId());
            recommendation.setGeneratedDate(new Date());
            recommendation.setScore(movie.getRating()); // Use movie rating as score
            recommendation.setReason("This movie is one of our top-rated films with a rating of " + movie.getRating());
            recommendation.setCategory("top-rated");
            recommendation.setRank(rank++);

            generalRecommendations.add(recommendation);
            recommendations.add(recommendation);
        }

        // Get all unique genres
        Set<String> genres = new HashSet<>();
        for (Movie movie : movieManager.getAllMovies()) {
            genres.add(movie.getGenre());
        }

        // Generate recommendations by genre
        for (String genre : genres) {
            List<Movie> genreMovies = new ArrayList<>();
            for (Movie movie : movieManager.getAllMovies()) {
                if (movie.getGenre().equals(genre)) {
                    genreMovies.add(movie);
                }
            }

            // Sort by rating using bubble sort algorithm (for educational purposes)
            for (int i = 0; i < genreMovies.size() - 1; i++) {
                for (int j = 0; j < genreMovies.size() - i - 1; j++) {
                    if (genreMovies.get(j).getRating() < genreMovies.get(j + 1).getRating()) {
                        // Swap movies
                        Movie temp = genreMovies.get(j);
                        genreMovies.set(j, genreMovies.get(j + 1));
                        genreMovies.set(j + 1, temp);
                    }
                }
            }

            // Take top 5 movies per genre
            int genreRank = 1;
            for (int i = 0; i < Math.min(5, genreMovies.size()); i++) {
                Movie movie = genreMovies.get(i);

                GeneralRecommendation recommendation = new GeneralRecommendation();
                recommendation.setRecommendationId(UUID.randomUUID().toString());
                recommendation.setMovieId(movie.getMovieId());
                recommendation.setGeneratedDate(new Date());
                recommendation.setScore(movie.getRating());
                recommendation.setReason("This is one of the top-rated " + genre + " movies");
                recommendation.setCategory("genre-" + genre.toLowerCase());
                recommendation.setRank(genreRank++);

                generalRecommendations.add(recommendation);
                recommendations.add(recommendation);
            }
        }

        saveRecommendations();
        return generalRecommendations;
    }

    // Generate personal recommendations for a user
    public List<PersonalRecommendation> generatePersonalRecommendations(String userId) {
        // Remove existing personal recommendations for this user
        recommendations.removeIf(rec -> rec.isPersonalized() && userId.equals(rec.getUserId()));

        List<PersonalRecommendation> personalRecommendations = new ArrayList<>();

        // Get user's watched movies, rentals, and watchlist
        RecentlyWatched recentlyWatched = watchlistManager.getRecentlyWatched(userId);
        List<Transaction> rentalHistory = rentalManager.getTransactionsByUser(userId);
        List<Watchlist> watchlist = watchlistManager.getWatchlistByUser(userId);

        // Get movies the user has already seen or in their watchlist
        Set<String> userMovieIds = new HashSet<>();
        if (recentlyWatched != null) {
            userMovieIds.addAll(recentlyWatched.getMovieIds());
        }

        for (Transaction transaction : rentalHistory) {
            userMovieIds.add(transaction.getMovieId());
        }

        for (Watchlist item : watchlist) {
            userMovieIds.add(item.getMovieId());
        }

        // Get user's preferred genres based on watched movies and watchlist
        Map<String, Integer> genreCounts = new HashMap<>();
        for (String movieId : userMovieIds) {
            Movie movie = movieManager.getMovieById(movieId);
            if (movie != null) {
                String genre = movie.getGenre();
                genreCounts.put(genre, genreCounts.getOrDefault(genre, 0) + 1);
            }
        }

        // Sort genres by preference (most watched first)
        List<Map.Entry<String, Integer>> sortedGenres = new ArrayList<>(genreCounts.entrySet());
        Collections.sort(sortedGenres, (g1, g2) -> g2.getValue().compareTo(g1.getValue()));

        // Recommend movies based on preferred genres
        int recommendationCount = 0;
        for (Map.Entry<String, Integer> genreEntry : sortedGenres) {
            String genre = genreEntry.getKey();

            // Get movies of this genre not seen by the user
            List<Movie> genreMovies = new ArrayList<>();
            for (Movie movie : movieManager.getAllMovies()) {
                if (movie.getGenre().equals(genre) && !userMovieIds.contains(movie.getMovieId()) && movie.isAvailable()) {
                    genreMovies.add(movie);
                }
            }

            // Sort by rating using bubble sort
            for (int i = 0; i < genreMovies.size() - 1; i++) {
                for (int j = 0; j < genreMovies.size() - i - 1; j++) {
                    if (genreMovies.get(j).getRating() < genreMovies.get(j + 1).getRating()) {
                        // Swap movies
                        Movie temp = genreMovies.get(j);
                        genreMovies.set(j, genreMovies.get(j + 1));
                        genreMovies.set(j + 1, temp);
                    }
                }
            }

            // Take top movies per genre
            for (int i = 0; i < Math.min(5, genreMovies.size()); i++) {
                Movie movie = genreMovies.get(i);

                // Calculate relevance score based on genre preference and movie rating
                double genreWeight = (double) genreEntry.getValue() /
                        Collections.max(genreCounts.values()); // Normalized to 0-1
                double ratingWeight = movie.getRating() / 10.0; // Normalized to 0-1
                double relevanceScore = 0.7 * genreWeight + 0.3 * ratingWeight; // Weighted average

                PersonalRecommendation recommendation = new PersonalRecommendation();
                recommendation.setRecommendationId(UUID.randomUUID().toString());
                recommendation.setMovieId(movie.getMovieId());
                recommendation.setUserId(userId);
                recommendation.setGeneratedDate(new Date());
                recommendation.setScore(movie.getRating());
                recommendation.setReason("Based on your interest in " + genre + " movies");
                recommendation.setBaseSource("genre-preference");
                recommendation.setRelevanceScore(relevanceScore);

                personalRecommendations.add(recommendation);
                recommendations.add(recommendation);

                recommendationCount++;
                if (recommendationCount >= 15) {
                    break;  // Limit to 15 recommendations total
                }
            }

            if (recommendationCount >= 15) {
                break;
            }
        }

        // If we don't have enough recommendations, add some based on top-rated movies
        if (recommendationCount < 15) {
            List<Movie> topRatedMovies = movieManager.getTopRatedMovies(30);

            for (Movie movie : topRatedMovies) {
                if (!userMovieIds.contains(movie.getMovieId()) && movie.isAvailable()) {
                    PersonalRecommendation recommendation = new PersonalRecommendation();
                    recommendation.setRecommendationId(UUID.randomUUID().toString());
                    recommendation.setMovieId(movie.getMovieId());
                    recommendation.setUserId(userId);
                    recommendation.setGeneratedDate(new Date());
                    recommendation.setScore(movie.getRating());
                    recommendation.setReason("This is one of our highest-rated movies");
                    recommendation.setBaseSource("top-rated");
                    recommendation.setRelevanceScore(0.6); // Slightly lower relevance as not based on preferences

                    personalRecommendations.add(recommendation);
                    recommendations.add(recommendation);

                    recommendationCount++;
                    if (recommendationCount >= 15) {
                        break;
                    }
                }
            }
        }

        saveRecommendations();
        return personalRecommendations;
    }

    // Get personal recommendations for a user
    public List<PersonalRecommendation> getPersonalRecommendations(String userId) {
        List<PersonalRecommendation> userRecs = new ArrayList<>();

        for (Recommendation rec : recommendations) {
            if (rec.isPersonalized() && userId.equals(rec.getUserId())) {
                userRecs.add((PersonalRecommendation) rec);
            }
        }

        // Check if we need to generate new recommendations
        if (userRecs.isEmpty() || isRecommendationsStale(userRecs)) {
            userRecs = generatePersonalRecommendations(userId);
        }

        return userRecs;
    }

    // Get general recommendations
    public List<GeneralRecommendation> getGeneralRecommendations() {
        List<GeneralRecommendation> generalRecs = new ArrayList<>();

        for (Recommendation rec : recommendations) {
            if (!rec.isPersonalized()) {
                generalRecs.add((GeneralRecommendation) rec);
            }
        }

        // Check if we need to generate new recommendations
        if (generalRecs.isEmpty() || isRecommendationsStale(generalRecs)) {
            generalRecs = generateGeneralRecommendations();
        }

        return generalRecs;
    }

    // Get top-rated recommendations
    public List<GeneralRecommendation> getTopRatedRecommendations() {
        List<GeneralRecommendation> topRated = new ArrayList<>();

        for (Recommendation rec : recommendations) {
            if (!rec.isPersonalized() &&
                    rec instanceof GeneralRecommendation &&
                    "top-rated".equals(((GeneralRecommendation) rec).getCategory())) {
                topRated.add((GeneralRecommendation) rec);
            }
        }

        // Sort by rank
        Collections.sort(topRated, new Comparator<GeneralRecommendation>() {
            @Override
            public int compare(GeneralRecommendation r1, GeneralRecommendation r2) {
                return Integer.compare(r1.getRank(), r2.getRank());
            }
        });

        // Generate if empty
        if (topRated.isEmpty()) {
            generateGeneralRecommendations();
            return getTopRatedRecommendations();
        }

        return topRated;
    }

    // Get genre-based recommendations
    public List<GeneralRecommendation> getGenreRecommendations(String genre) {
        String categoryPattern = "genre-" + genre.toLowerCase();
        List<GeneralRecommendation> genreRecs = new ArrayList<>();

        for (Recommendation rec : recommendations) {
            if (!rec.isPersonalized() &&
                    rec instanceof GeneralRecommendation &&
                    categoryPattern.equals(((GeneralRecommendation) rec).getCategory())) {
                genreRecs.add((GeneralRecommendation) rec);
            }
        }

        // Sort by rank
        Collections.sort(genreRecs, new Comparator<GeneralRecommendation>() {
            @Override
            public int compare(GeneralRecommendation r1, GeneralRecommendation r2) {
                return Integer.compare(r1.getRank(), r2.getRank());
            }
        });

        // Generate if empty
        if (genreRecs.isEmpty()) {
            generateGeneralRecommendations();
            return getGenreRecommendations(genre);
        }

        return genreRecs;
    }

    // Check if recommendations are stale (older than 24 hours)
    private boolean isRecommendationsStale(List<? extends Recommendation> recs) {
        if (recs.isEmpty()) {
            return true;
        }

        Date now = new Date();
        long dayInMillis = 24 * 60 * 60 * 1000; // 24 hours

        // Check if any recommendation is older than 24 hours
        for (Recommendation rec : recs) {
            if (now.getTime() - rec.getGeneratedDate().getTime() > dayInMillis) {
                return true;
            }
        }

        return false;
    }

    // Add a recommendation
    public boolean addRecommendation(Recommendation recommendation) {
        if (recommendation == null || recommendation.getRecommendationId() == null) {
            return false;
        }

        // Generate ID if not provided
        if (recommendation.getRecommendationId().isEmpty()) {
            recommendation.setRecommendationId(UUID.randomUUID().toString());
        }

        // Set generation date if not set
        if (recommendation.getGeneratedDate() == null) {
            recommendation.setGeneratedDate(new Date());
        }

        recommendations.add(recommendation);
        saveRecommendations();
        return true;
    }

    // Update a recommendation
    public boolean updateRecommendation(Recommendation updatedRecommendation) {
        if (updatedRecommendation == null || updatedRecommendation.getRecommendationId() == null) {
            return false;
        }

        for (int i = 0; i < recommendations.size(); i++) {
            if (recommendations.get(i).getRecommendationId().equals(updatedRecommendation.getRecommendationId())) {
                recommendations.set(i, updatedRecommendation);
                saveRecommendations();
                return true;
            }
        }

        return false;
    }

    // Delete a recommendation by ID
    public boolean deleteRecommendation(String recommendationId) {
        if (recommendationId == null) {
            return false;
        }

        for (int i = 0; i < recommendations.size(); i++) {
            if (recommendations.get(i).getRecommendationId().equals(recommendationId)) {
                recommendations.remove(i);
                saveRecommendations();
                return true;
            }
        }

        return false;
    }

    // Get a recommendation by ID
    public Recommendation getRecommendationById(String recommendationId) {
        if (recommendationId == null) {
            return null;
        }

        for (Recommendation rec : recommendations) {
            if (rec.getRecommendationId().equals(recommendationId)) {
                return rec;
            }
        }

        return null;
    }

    // Delete all recommendations for a user (e.g., when user is deleted)
    public boolean deleteUserRecommendations(String userId) {
        if (userId == null) {
            return false;
        }

        boolean removed = recommendations.removeIf(rec -> userId.equals(rec.getUserId()));
        if (removed) {
            saveRecommendations();
        }
        return removed;
    }

    // Get all available genres
    public List<String> getAllGenres() {
        Set<String> genres = new HashSet<>();
        for (Movie movie : movieManager.getAllMovies()) {
            genres.add(movie.getGenre());
        }
        return new ArrayList<>(genres);
    }

    // Get all recommendations
    public List<Recommendation> getAllRecommendations() {
        return new ArrayList<>(recommendations);
    }

    // Set ServletContext (can be used to update the context after initialization)
    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
        initializeFilePath();
        // Reload recommendations with the new file path
        recommendations.clear();
        loadRecommendations();

        // Update other managers
        movieManager.setServletContext(servletContext);
        reviewManager.setServletContext(servletContext);
        rentalManager.setServletContext(servletContext);
        watchlistManager.setServletContext(servletContext);
    }
}