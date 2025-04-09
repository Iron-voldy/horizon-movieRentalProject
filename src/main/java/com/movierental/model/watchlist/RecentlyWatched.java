package com.movierental.model.watchlist;

import java.util.Date;
import java.util.Stack;

/**
 * RecentlyWatched class implements a stack to manage recently watched movies
 */
public class RecentlyWatched {
    private Stack<String> movieIds;     // Stack for movie IDs
    private Stack<Date> watchDates;     // Parallel stack for watch dates
    private int maxSize;                // maximum movies to keep track of

    // Constructor
    public RecentlyWatched(String userId) {
        this.movieIds = new Stack<>();
        this.watchDates = new Stack<>();
        this.maxSize = 10;  // default to track last 10 movies
    }

    // Constructor with customizable size
    public RecentlyWatched(String userId, int maxSize) {
        this.movieIds = new Stack<>();
        this.watchDates = new Stack<>();
        this.maxSize = maxSize;
    }

    // Add a movie to recently watched (push operation)
    public void addMovie(String movieId) {
        // Remove existing entry if it exists
        int existingIndex = movieIds.indexOf(movieId);
        if (existingIndex != -1) {
            // Remove the existing movie and its date
            movieIds.removeElementAt(existingIndex);
            watchDates.removeElementAt(existingIndex);
        }

        // Push new movie to the top of the stack
        movieIds.push(movieId);
        watchDates.push(new Date());

        // Ensure stack doesn't exceed max size
        while (movieIds.size() > maxSize) {
            movieIds.removeElementAt(0);
            watchDates.removeElementAt(0);
        }
    }

    // Get the most recently watched movie (peek operation)
    public String getMostRecentMovie() {
        if (movieIds.isEmpty()) {
            return null;
        }
        return movieIds.peek();
    }

    // Remove the most recently watched movie (pop operation)
    public String removeRecentMovie() {
        if (movieIds.isEmpty()) {
            return null;
        }
        watchDates.pop();
        return movieIds.pop();
    }

    // Check if a movie is in the recently watched stack
    public boolean contains(String movieId) {
        return movieIds.contains(movieId);
    }

    // Get the watch date for a specific movie
    public Date getWatchDateForMovie(String movieId) {
        int index = movieIds.indexOf(movieId);
        if (index >= 0) {
            return watchDates.get(index);
        }
        return null;
    }

    // Get all movie IDs in the recently watched stack
    public Stack<String> getMovieIds() {
        return (Stack<String>) movieIds.clone();
    }

    // Get all watch dates
    public Stack<Date> getWatchDates() {
        return (Stack<Date>) watchDates.clone();
    }

    // Get the number of movies in the recently watched stack
    public int size() {
        return movieIds.size();
    }

    // Clear the recently watched stack
    public void clear() {
        movieIds.clear();
        watchDates.clear();
    }

    // Convert to string representation for file storage
    public String toFileString() {
        StringBuilder sb = new StringBuilder();
        sb.append("userId").append(",").append(maxSize);

        for (int i = 0; i < movieIds.size(); i++) {
            sb.append(",").append(movieIds.get(i))
                    .append(",").append(watchDates.get(i).getTime());
        }

        return sb.toString();
    }

    // Create RecentlyWatched from string representation (from file)
    public static RecentlyWatched fromFileString(String fileString) {
        String[] parts = fileString.split(",");

        if (parts.length >= 2) {
            String userId = parts[0];
            int maxSize = Integer.parseInt(parts[1]);

            RecentlyWatched recentlyWatched = new RecentlyWatched(userId, maxSize);

            // Parse movie IDs and watch dates
            for (int i = 2; i < parts.length; i += 2) {
                if (i + 1 < parts.length) {
                    String movieId = parts[i];
                    Date watchDate = new Date(Long.parseLong(parts[i + 1]));

                    recentlyWatched.movieIds.push(movieId);
                    recentlyWatched.watchDates.push(watchDate);
                }
            }

            return recentlyWatched;
        }

        return null;
    }
}